//
//  NSObject+CBObservable.m
//  CBBinder
//
//  Created by Bogdan Udrescu on 13/06/2018.
//  Copyright © 2018 CB. All rights reserved.
//

#import "NSObject+CBObservable.h"


// Proxy observer which forwards the property event to all registered observer targets.
@interface CBObserverProxy : NSObject

// Initialize the observer proxy with the observable. The observable is the instance which events are proxied by this object and forward to the target observers by performing the associated selectors and passing the property change details.
- (instancetype)initWithObservable:(NSObject *)observable;

// Adds the observer to listen to property changes of the observable.
- (void)addProxyObserverTarget:(NSObject *)target action:(SEL)action forKeyPath:(NSString *)keyPath;

// Removes the observer target.
- (void)removeProxyObserverTarget:(NSObject *)target forKeyPath:(NSString *)keyPath;

@end


#import <objc/runtime.h>

// Objc associatedObject key.
static void *CBObservableProxyKey;

// Extend NSObject's KVO to support action based property observers.
@implementation NSObject (CBObservable)

// Adds an observer for the specified keyPath.
- (void)addObserverTarget:(NSObject *)target action:(SEL)action forKeyPath:(NSString *)keyPath {
    [[self observerProxy] addProxyObserverTarget:target action:action forKeyPath:keyPath];
}

// Removes an observer for the specified keyPath.
- (void)removeObserverTarget:(NSObject *)target forKeyPath:(NSString *)keyPath {
    [[self observerProxy] removeProxyObserverTarget:target forKeyPath:keyPath];
}

// Gets the associated observer proxy.
- (CBObserverProxy *)observerProxy {

    __block CBObserverProxy *proxy = objc_getAssociatedObject(self, &CBObservableProxyKey);

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        proxy = [[CBObserverProxy alloc] initWithObservable:self];
        objc_setAssociatedObject(self, &CBObservableProxyKey, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });

    if (proxy == nil) {
        proxy = objc_getAssociatedObject(self, &CBObservableProxyKey);
    }

    return proxy;
}

@end


// The change event.
@implementation CBKeyPathValueChangeEvent

// Init the event.
- (instancetype)initWithObject:(id)object keyPath:(NSString *)keyPath value:(id)value oldValue:(id)oldValue  {
    if (self = [super init]) {
        _object = object;
        _keyPath = keyPath;
        _value = [self ensureNilWithValue:value];
        _oldValue = [self ensureNilWithValue:oldValue];
    }
    
    return self;
}

// Check if NSNull and provide nil instead.
- (id)ensureNilWithValue:(id)value {
    if ([value isKindOfClass:[NSNull class]]) {
        return nil;

    } else {
        return value;
    }
}

// Describe the object.
- (NSString *)description {
    return [NSString stringWithFormat:@"CBKeyPathValueChangeEvent [object = %@, keyPath = %@, value = %@, oldValue = %@]", _object, _keyPath, _value, _oldValue];
}

@end


// Wraps the target observer and it's action.
@interface CBTargetAction : NSObject

// The observer.
@property (readonly) NSObject *target;

// The action.
@property (readonly) SEL action;

// Wrap the observer and action.
- (instancetype)initWithTarget:(NSObject *)target action:(SEL)action;

@end


// Proxy observer.
@implementation CBObserverProxy {

    // The observed instance.
    __weak NSObject *_observable;

    // Map the key path to each observer.
    NSMutableDictionary<NSString *, NSMutableArray<CBTargetAction *> *> *_keyPath2TargetActions;

    // We need to synch basically everything to be safe of consurrent adding/removing/event propagation during which _keyPath2TargetActions and it's wrapped arrays might get change.
    NSLock *_lock;
    
}

// Initialize the proxy observer.
- (instancetype)initWithObservable:(NSObject *)observable {
    if (self = [super init]) {
        _observable = observable;
        _keyPath2TargetActions = [NSMutableDictionary dictionary];
        _lock = [[NSLock alloc] init];
    }

    return self;
}

// Adds an observer to the proxy.
- (void)addProxyObserverTarget:(NSObject *)target action:(SEL)action forKeyPath:(NSString *)keyPath {
    [_lock lock];

    NSMutableArray<CBTargetAction *> *array = _keyPath2TargetActions[keyPath];

    BOOL first = array == nil;
    
    if (first) {
        array = [NSMutableArray array];
        _keyPath2TargetActions[keyPath] = array;

        // Add the real observer only once.
        [_observable addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }

    [array addObject:[[CBTargetAction alloc] initWithTarget:target action:action]];

    [_lock unlock];
}

// Removes the observer target.
- (void)removeProxyObserverTarget:(NSObject *)target forKeyPath:(NSString *)keyPath {
    [_lock lock];

    NSMutableArray<CBTargetAction *> *array = _keyPath2TargetActions[keyPath];
    NSMutableArray<CBTargetAction *> *removed = [NSMutableArray arrayWithCapacity:1];

    for (CBTargetAction *targetAction in array) {
        if (targetAction.target == target) {
            [removed addObject:targetAction];
        }
    }

    [array removeObjectsInArray:removed];

    if (array.count == 0 && removed.count > 0) {
        // Remove the real observer only once.
        [_observable removeObserver:self forKeyPath:keyPath];

        _keyPath2TargetActions[keyPath] = nil;
    }

    [_lock unlock];
}

// Proxy observe value implementation.
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    id value = change[NSKeyValueChangeNewKey];
    id oldValue = change[NSKeyValueChangeOldKey];

    if ([value isEqual:oldValue]) {
        return;
    }

    CBKeyPathValueChangeEvent *event = [[CBKeyPathValueChangeEvent alloc] initWithObject:object
                                                                                 keyPath:keyPath
                                                                                   value:value
                                                                                oldValue:oldValue];

    [_lock lock];

    NSMutableArray<CBTargetAction *> *array = _keyPath2TargetActions[keyPath];

    for (CBTargetAction *targetAction in array) {
        if ([targetAction.target respondsToSelector:targetAction.action]) {
            [targetAction.target performSelector:targetAction.action withObject:event];
        }
    }

    [_lock unlock];
}

@end


// Wraps the target observer and it's action.
@implementation CBTargetAction

// Wrap the observer and action.
- (instancetype)initWithTarget:(NSObject *)target action:(SEL)action {
    if (self = [super init]) {
        _target = target;
        _action = action;
    }
    
    return self;
}

@end

