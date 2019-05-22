//
//  LibBluetoothTests.m
//  LibBluetoothTests
//
//  Created by 鐘妘甄 on 2019/5/17.
//  Copyright © 2019 鐘妘甄. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LibBluetooth/SCCoreBluetooth.h>

@interface LibBluetoothTests : XCTestCase
{
    SCBluetooth* scb_;
}
@end

@implementation LibBluetoothTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    scb_ = [SCBluetooth new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
