//
//  CBObjectProperty.h
//  CBBinder
//
//  Created by Bogdan Udrescu on 30/09/2018.
//  Copyright © 2018 CB. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Resembles a object property identified by an instance and the path to its property.
 */
@interface CBObjectProperty : NSObject <NSCopying>

/**
 The instance where the property exists.
 */
@property (readonly, weak, nonatomic) id object;

/**
 The keypath identifying the property.
 */
@property (readonly, strong, nonatomic) NSString *keyPath;

/**
 Creates an object property wrapping an instance and the path to one of its properties.

 @param object Instance where the property exists.
 @param keyPath Keypath identifying the property.
 @return An instance of CBObjectProperty.
 */
+ (instancetype)withObject:(id)object keyPath:(NSString *)keyPath;

@end


/**
 Provides read and write access to the property value.
 */
@interface CBObjectProperty (CBPropertyValue)

/**
 Access the underlying property value.
 */
@property (readwrite, nonatomic) id value;

@end
