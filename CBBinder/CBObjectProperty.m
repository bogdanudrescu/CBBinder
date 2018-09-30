//
//  CBObjectProperty.m
//  CBBinder
//
//  Created by Bogdan Udrescu on 30/09/2018.
//  Copyright © 2018 CB. All rights reserved.
//

#import "CBObjectProperty.h"

// Resembles a object property identified by an instance and the path to its property.
@implementation CBObjectProperty

// Creates an object property wrapping an instance and the path to one of its properties.
+ (instancetype)withObject:(id)object keyPath:(NSString *)keyPath {
    return [[CBObjectProperty alloc] initWithObject:object keyPath:keyPath];
}

// Creates an object property wrapping an instance and the path to one of its properties.
- (instancetype)initWithObject:(id)object keyPath:(NSString *)keyPath {
    if (self = [super init]) {
        _object = object;
        _keyPath = keyPath;
    }
    return self;
}

// Describe the object.
- (NSString *)description {
    return [NSString stringWithFormat:@"<CBObjectProperty object = %@, keyPath = %@>", _object, _keyPath];
}

// Copy.
- (id)copyWithZone:(nullable NSZone *)zone {
    return [[self.class allocWithZone:zone] initWithObject:_object keyPath:_keyPath];
}

// Equality with other instance.
- (BOOL)isEqual:(id)object {

    CBObjectProperty *objectProperty = (CBObjectProperty *)object;

    if (objectProperty) {
        return [self.object isEqual:objectProperty.object] && [self.keyPath isEqualToString:objectProperty.keyPath];

    } else {
        return false;
    }
}

// Hash code.
- (NSUInteger)hash {

    NSUInteger hash = 17;

    hash = 31 * hash + [self.object hash];
    hash = 31 * hash + [self.keyPath hash];

    return hash;
}

@end


// Provides read and write access to the property value.
@implementation CBObjectProperty (CBPropertyValue)

// Reads the underlying property value.
- (id)value {
    return [self.object valueForKeyPath:self.keyPath];
}

// Writes the value into the underlying property.
- (void)setValue:(id)value {
    [self.object setValue:value forKeyPath:self.keyPath];
}

@end
