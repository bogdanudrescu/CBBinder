//
//  CBObservableTests.m
//  CBBinder
//
//  Created by Bogdan Udrescu on 24/06/2018.
//  Copyright © 2018 CB. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CBBinder.h"
#import "CBBindTestObject.h"


// Test CBObservable functionality.
@interface CBObservableTests : XCTestCase

@end

@implementation CBObservableTests {

    CBBindTestObject *object;

    XCTestExpectation *stringValueExpectation;

    XCTestExpectation *stringValueExpectation2;

    XCTestExpectation *integerValueExpectation;

    XCTestExpectation *integerValueExpectation2;

}

- (void)setUp {
    [super setUp];

    object = [[CBBindTestObject alloc] init];
}

- (void)tearDown {
    object = nil;
}

- (void)testObserverTarget {

    stringValueExpectation = [self observerExpectationWithDescription:@"Initial string value change"];
    integerValueExpectation = [self observerExpectationWithDescription:@"Initial integer value change"];
    stringValueExpectation2 = [self observerExpectationWithDescription:@"String value change with no event passed to action selector."];
    integerValueExpectation2 = [self observerExpectationWithDescription:@"Same integer value change multiple times"];

    [object addObserverTarget:self action:@selector(stringValueChanged:) forKeyPath:@"stringValue"];
    [object addObserverTarget:self action:@selector(integerValueChanged:) forKeyPath:@"integerValue"];

    object.stringValue = @"NewValue";
    object.integerValue = 2;

    [self waitForExpectations:@[stringValueExpectation, integerValueExpectation] timeout:1];

    [object removeObserverTarget:self forKeyPath:@"stringValue"];
    [object removeObserverTarget:self forKeyPath:@"integerValue"];

    [object addObserverTarget:self action:@selector(stringValueChanged2) forKeyPath:@"stringValue"];
    [object addObserverTarget:self action:@selector(integerValueChanged2:) forKeyPath:@"integerValue"];

    object.stringValue = @"ObservedValue";

    object.integerValue = 5;
    object.integerValue = 5;
    object.integerValue = 5; // This should not trigger another event.

    [self waitForExpectations:@[stringValueExpectation2, integerValueExpectation2] timeout:1];

    [object removeObserverTarget:self forKeyPath:@"stringValue"];
    [object removeObserverTarget:self forKeyPath:@"integerValue"];

    // If still observed the expectations should fail since assertForOverFulfill is set and expectedFulfillmentCount is 1.
    object.stringValue = @"ObservedValue2";
    object.integerValue = 7;

    // Ensure this won't crash the test.
    [object removeObserverTarget:self forKeyPath:@"stringValue"];
}

- (void)stringValueChanged:(CBKeyPathValueChangeEvent *)event {
    XCTAssertNil(event.oldValue, @"Unexpected string old value");
    XCTAssertTrue([event.value isEqualToString:@"NewValue"], @"Unexpected string new value");

    [stringValueExpectation fulfill];
}

- (void)stringValueChanged2 {
    XCTAssertTrue([object.stringValue isEqualToString:@"ObservedValue"], @"Unexpected string value 2");

    [stringValueExpectation2 fulfill];
}

- (void)integerValueChanged:(CBKeyPathValueChangeEvent *)event {
    XCTAssertEqual([event.oldValue integerValue], 0, @"Unexpected integer old value");
    XCTAssertEqual([event.value integerValue], 2, @"Unexpected integer new value");

    [integerValueExpectation fulfill];
}

- (void)integerValueChanged2:(CBKeyPathValueChangeEvent *)event {
    XCTAssertEqual([event.oldValue integerValue], 2, @"Unexpected integer old value 2");
    XCTAssertEqual([event.value integerValue], 5, @"Unexpected integer new value 2");

    [integerValueExpectation2 fulfill];
}

- (XCTestExpectation *)observerExpectationWithDescription:(NSString *)description {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:description];
    expectation.assertForOverFulfill = YES;
    expectation.expectedFulfillmentCount = 1;

    return expectation;
}

@end


