//
//  NSObject+CBObservable.h
//  CBBinder
//
//  Created by Carmen Udrescu on 13/06/2018.
//  Copyright © 2018 CB. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Extend NSObject's KVO to support action based property observers with new and old values.
 */
@interface NSObject (CBObservable)

/**
 Adds an observer for the specified keyPath.

 @param target The observer target instance to be notified about the property change.
 @param action The action to be invoked when the property at keyPath changes. The selector may receive one argument of type CBKeyPathValueChangeEvent.
 @param keyPath KeyPath of the property to observe.
 */
- (void)addObserverTarget:(NSObject *)target action:(SEL)action forKeyPath:(NSString *)keyPath;

/**
 Removes an observer for the specified keyPath.
 
 @param target The observer target instance to remove.
 @param keyPath KeyPath of the property.
 */
- (void)removeObserverTarget:(NSObject *)target forKeyPath:(NSString *)keyPath;

@end

/**
 The change event.
 */
@interface CBKeyPathValueChangeEvent : NSObject

/**
 The object where the change occurs.
 */
@property (readonly) id object;

/**
 The key path.
 */
@property (readonly) NSString *keyPath;

/**
 New value of the property.
 */
@property (readonly) id value;

/**
 Old value of the property.
 */
@property (readonly) id oldValue;

@end
