//
//  CBObservableTests.m
//  CBBinder
//
//  Created by Carmen Udrescu on 24/06/2018.
//  Copyright © 2018 CB. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CBBinder.h"


// A property wrapper test object.
@interface CBObject : NSObject

// Just a string value.
@property (strong) NSString *stringValue;

// Just an integer value.
@property (readwrite) NSInteger *integerValue;

@end

@implementation CBObject

@end


// Test CBObservable functionality.
@interface CBObservableTests : XCTestCase

@end

@implementation CBObservableTests {

    CBObject *object;

    XCTestExpectation *stringValueExpectation;

}

- (void)setUp {
    [super setUp];

    object = [[CBObject alloc] init];
}

- (void)testExample {
    
    stringValueExpectation = [[XCTestExpectation alloc] init];
    stringValueExpectation.assertForOverFulfill = YES;
    
    [object addObserverTarget:self action:@selector(stringValueChanged:) forKeyPath:@"stringValue"];

    object.stringValue = @"NewValue";

    stringValueExpectation.
    
    
    [object removeObserverTarget:self forKeyPath:@"stringValue"];

    object.stringValue = @"NewValueNotObserved";
}

- (void)stringValueChanged:(CBKeyPathValueChangeEvent *)event {
    NSLog(@"stringValueChanged event: %@", event);

    XCTAssertNil(event.oldValue, @"Unexpected old value");
    XCTAssertTrue([event.value isEqualToString:@"NewValue"], @"Unexpected new value");

    [stringValueExpectation fulfill];
}

@end


