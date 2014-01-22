//
//  PrioQueueProjectTests.m
//  PrioQueueProjectTests
//
//  Created by Josh Smith on 1/20/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PrioQueueProject.h"

@interface PrioQueueProjectTests : XCTestCase

@end

@implementation PrioQueueProjectTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateQueue
{
    PrioQueueProject *queue = [PrioQueueProject queue];
    XCTAssertNotNil(queue, @"I should at least init");
}


- (void) testQueueCounts
{
    PrioQueueProject *queue = [PrioQueueProject queue];
    XCTAssert(queue.count == 0, @"Count is zero");
    
    [queue push:@"First" withPriority:10];
    XCTAssert(queue.count == 1, @"Count is one");
    
    [queue push:@"Firstish" withPriority:10];
    [queue push:@"Second" withPriority:11];
    [queue push:@"Third" withPriority:12];
    XCTAssert(queue.count == 4, @"Count is four");
}

- (void) testPriority
{
    PrioQueueProject *queue = [PrioQueueProject queue];
    [queue push:@1 withPriority:1];
    [queue push:@3 withPriority:3];
    [queue push:@2 withPriority:2];
    [queue push:@4 withPriority:4];
    
    XCTAssertEqualObjects(@4, [queue front], @"4 is the highest priority");
}

- (void) testPop
{
    PrioQueueProject *queue = [PrioQueueProject queue];
    [queue push:@1 withPriority:1];
    [queue push:@3 withPriority:3];
    [queue push:@2 withPriority:2];
    [queue push:@4 withPriority:4];
    
    XCTAssertEqualObjects(@4, [queue pop], @"4 is the highest priority");
    XCTAssertEqualObjects(@3, [queue pop], @"now 3 is the highest priority");
    XCTAssertEqualObjects(@2, [queue pop], @"now 2 is the highest priority");
    XCTAssertEqualObjects(@1, [queue pop], @"now 1 is the highest priority");
    XCTAssertNil([queue pop], @"There is nothing left");
}

- (void) testSpeed
{
    PrioQueueProject *queue = [PrioQueueProject queue];
    NSLog(@"Start at %@",[NSDate date]);
    for (int i = 0;i < 100; i++) {
        u_int32_t prio = arc4random_uniform(10000);
        u_int32_t randval = arc4random_uniform(400);
        [queue push:@(randval) withPriority:prio];
    }
    NSLog(@"End at %@",[NSDate date]);

}


@end
