//
//  CBObjectProperty+CBObservable.h
//  CBBinder
//
//  Created by Bogdan Udrescu on 30/09/2018.
//  Copyright © 2018 CB. All rights reserved.
//

#import "CBObjectProperty.h"

/**
 Observer defined for a property.
 */
@interface CBObjectProperty (CBObservable)

/**
 Adds an observer to monitor the change of this property.

 @param target Target to be notified about the property change.
 @param action The action to be invoked when the property changes. The selector may receive one argument of type CBKeyPathValueChangeEvent.
 */
- (void)addPropertyObserverTarget:(NSObject *)target action:(SEL)action;

/**
 Removes an observer.

 @param target The observer target instance to remove.
 */
- (void)removePropertyObserverTarget:(NSObject *)target;

@end

