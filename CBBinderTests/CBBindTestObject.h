//
//  CBBindTestObject.h
//  CBBinder
//
//  Created by Carmen Udrescu on 30/09/2018.
//  Copyright © 2018 CB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBBindTestObject : NSObject

// Just a string value.
@property (strong) NSString *stringValue;

// Just an integer value.
@property (readwrite) NSInteger integerValue;


@end
