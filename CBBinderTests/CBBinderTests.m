//
//  CBBinderTests.m
//  CBBinderTests
//
//  Created by Bogdan Udrescu on 13/06/2018.
//  Copyright © 2018 CB. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CBBinder.h"
#import "CBBindTestObject.h"

@interface CBBinderTests : XCTestCase

@end

@implementation CBBinderTests {

    CBBindService *bindService;

    CBBindTestObject *object1;

    CBBindTestObject *object2;

    CBBindTestObject *object3;

}

- (void)setUp {
    [super setUp];

    bindService = [[CBBindService alloc] init];

    object1 = [[CBBindTestObject alloc] init];
    object2 = [[CBBindTestObject alloc] init];
    object3 = [[CBBindTestObject alloc] init];

    [bindService bind:[CBObjectProperty withObject:object1 keyPath:@"stringValue"]
      withTargetArray:@[[CBObjectProperty withObject:object2 keyPath:@"stringValue"], [CBObjectProperty withObject:object3 keyPath:@"stringValue"]]];

    [bindService bind:[CBObjectProperty withObject:object2 keyPath:@"stringValue"]
                 with:[CBObjectProperty withObject:object1 keyPath:@"stringValue"]];

    [bindService bind:object3 forKeyPath:@"integerValue" with:object1 forKeyPath:@"integerValue"];

    [bindService bind:[CBObjectProperty withObject:object2 keyPath:@"integerValue"]
                 with:[CBObjectProperty withObject:object1 keyPath:@"integerValue"]];
}

- (void)tearDown {
    bindService = nil;

    object1 = nil;
    object2 = nil;
    object3 = nil;
}

- (void)testBind {

    XCTAssertEqual(object1.integerValue, 0, @"Default is not 0");
    XCTAssertEqual(object2.integerValue, 0, @"Default is not 0");
    XCTAssertEqual(object3.integerValue, 0, @"Default is not 0");

    XCTAssertNil(object1.stringValue, @"Default is not nil");
    XCTAssertNil(object2.stringValue, @"Default is not nil");
    XCTAssertNil(object3.stringValue, @"Default is not nil");

    object1.stringValue = @"Bow";
    XCTAssertEqual(object1.stringValue, @"Bow", @"Value is not Bow");
    XCTAssertEqual(object2.stringValue, @"Bow", @"Value is not Bow");
    XCTAssertEqual(object3.stringValue, @"Bow", @"Value is not Bow");

    object2.stringValue = @"String";
    XCTAssertEqual(object1.stringValue, @"String", @"Value is not String");
    XCTAssertEqual(object2.stringValue, @"String", @"Value is not String");
    XCTAssertEqual(object3.stringValue, @"String", @"Value is not String");

    object3.stringValue = @"Pen";
    XCTAssertEqual(object1.stringValue, @"String", @"Value is not String");
    XCTAssertEqual(object2.stringValue, @"String", @"Value is not String");
    XCTAssertEqual(object3.stringValue, @"Pen", @"Value is not Pen");

    object3.integerValue = 3;
    XCTAssertEqual(object1.integerValue, 3, @"Value is not 3");
    XCTAssertEqual(object2.integerValue, 0, @"Value is not 0");
    XCTAssertEqual(object3.integerValue, 3, @"Value is not 3");

    object2.integerValue = 6;
    XCTAssertEqual(object1.integerValue, 6, @"Value is not 6");
    XCTAssertEqual(object2.integerValue, 6, @"Value is not 6");
    XCTAssertEqual(object3.integerValue, 3, @"Value is not 3");

    object1.integerValue = 9;
    XCTAssertEqual(object1.integerValue, 9, @"Value is not 9");
    XCTAssertEqual(object2.integerValue, 6, @"Value is not 6");
    XCTAssertEqual(object3.integerValue, 3, @"Value is not 3");

}


@end
