//
//  CBBindService.h
//  CBBinder
//
//  Created by Bogdan Udrescu on 30/09/2018.
//  Copyright © 2018 CB. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBObjectProperty;

/**
 Maintain observer/observable and automatically synch values between objects properties.
 */
@interface CBBindService : NSObject

/**
 Creates a bind between a source propery and a target property.

 @param sourceObject Instance owning the source property.
 @param sourceKeyPath Keypath indicating the source property which is observed for value changes.
 @param targetObject Instance owning the target property.
 @param targetKeyPath Keypath to the target property where the source value is set when changed.
 */
- (void)bind:(id)sourceObject forKeyPath:(NSString *)sourceKeyPath with:(id)targetObject forKeyPath:(NSString *)targetKeyPath;

/**
 Creates a bind between a source propery and a target property.

 @param sourceProperty Property which observer for value changes.
 @param targetProperty Property set with the value observed from the sourceProperty.
 */
- (void)bind:(CBObjectProperty *)sourceProperty with:(CBObjectProperty *)targetProperty;

/**
 Creates a bind between a source propery and a list of target properties.

 @param sourceProperty Property which observer for value changes.
 @param targetPropertyArray List of properties set with the value observed from the sourceProperty.
 */
- (void)bind:(CBObjectProperty *)sourceProperty withTargetArray:(NSArray<CBObjectProperty *> *)targetPropertyArray;

@end



