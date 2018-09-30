//
//  CBBindService.m
//  CBBinder
//
//  Created by Bogdan Udrescu on 30/09/2018.
//  Copyright © 2018 CB. All rights reserved.
//

#import "CBBindService.h"
#import "CBObjectProperty.h"
#import "CBObjectProperty+CBObservable.h"
#import "NSObject+CBObservable.h"

// Maintain observer/observable and automatically synch values between objects properties.
@implementation CBBindService {

    // The bindings dataset.
    NSMutableDictionary <CBObjectProperty *, NSMutableArray<CBObjectProperty *> *> *_bindings;

    // Lock against multiple accesses.
    NSLock *_lock;

}

// Initializer.
- (instancetype)init {
    if (self = [super init]) {
        _bindings = [NSMutableDictionary dictionary];
        _lock = [[NSLock alloc] init];
    }
    return self;
}

// Creates a bind between a source propery and a target property.
- (void)bind:(id)sourceObject forKeyPath:(NSString *)sourceKeyPath with:(id)targetObject forKeyPath:(NSString *)targetKeyPath {
    [self bind:[CBObjectProperty withObject:sourceObject keyPath:sourceKeyPath]
          with:[CBObjectProperty withObject:targetObject keyPath:targetKeyPath]];
}

// Creates a bind between a source propery and a target property.
- (void)bind:(CBObjectProperty *)sourceProperty with:(CBObjectProperty *)targetProperty {
    [self bind:sourceProperty withTargetArray:@[targetProperty]];
}

// Creates a bind between a source propery and a list of target properties.
- (void)bind:(CBObjectProperty *)sourceProperty withTargetArray:(NSArray<CBObjectProperty *> *)targetPropertyArray {

//    [_lock lock];

    NSMutableArray<CBObjectProperty *> *array = _bindings[sourceProperty];

    if (array == nil) {
        array = [NSMutableArray array];
        _bindings[sourceProperty] = array;

        [sourceProperty addPropertyObserverTarget:self action:@selector(propertyValueChanged:)];
    }

    [array addObjectsFromArray:targetPropertyArray];

//    [_lock unlock];
}

// Observer property changes.
- (void)propertyValueChanged:(CBKeyPathValueChangeEvent *)event {

//    [_lock lock];

    NSMutableArray<CBObjectProperty *> *targetArray = _bindings[event.property];

//    [_lock unlock];

    for (CBObjectProperty *targetProperty in targetArray) {
        targetProperty.value = event.value;
    }

}

@end
