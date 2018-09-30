//
//  CBObjectProperty+CBObservable.m
//  CBBinder
//
//  Created by Bogdan Udrescu on 30/09/2018.
//  Copyright © 2018 CB. All rights reserved.
//

#import "CBObjectProperty+CBObservable.h"
#import "NSObject+CBObservable.h"

// Observer defined for a property.
@implementation CBObjectProperty (CBObservable)

// Adds an observer to monitor the change of this property.
- (void)addPropertyObserverTarget:(NSObject *)target action:(SEL)action {
    [self.object addObserverTarget:target action:action forKeyPath:self.keyPath];
}

// Removes an observer.
- (void)removePropertyObserverTarget:(NSObject *)target {
    [self.object removeObserverTarget:target forKeyPath:self.keyPath];
}

@end
