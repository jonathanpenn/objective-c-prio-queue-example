//
//  RCWPrioQueueTests.m
//  PrioQueueProject
//
//  Created by Josh Smith on 1/21/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RCWPrioQueue.h"

@interface ForTestClass : NSObject <RCWPrioCanCompare>
@property (strong, nonatomic) NSString *actual;
@end

@implementation ForTestClass

-(CFComparisonResult) compareWith:(id<RCWPrioCanCompare>)otherObj {
    NSComparisonResult res = [self.comparisonValue compare:otherObj.comparisonValue];
    switch (res) {
        case NSOrderedSame:
            return kCFCompareEqualTo;
            break;
        case NSOrderedAscending:
            return kCFCompareLessThan;
        default:
            return kCFCompareGreaterThan;
            break;
    }
}

- (NSString *) comparisonValue {
    return self.actual;
}

@end

@interface RCWPrioQueueTests : XCTestCase

@end

@implementation RCWPrioQueueTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testInit
{
    RCWPrioQueue *t = [[RCWPrioQueue alloc] init];
    XCTAssertNotNil(t, @"should at least init");
}

- (void) testQueueCounts
{
    RCWPrioQueue *queue = [[RCWPrioQueue alloc] init];
    XCTAssert(queue.count == 0, @"Count is zero");
    
    ForTestClass *first = [[ForTestClass alloc] init];
    first.actual = @"A First";
    
    [queue push:first];
    
    XCTAssert(queue.count == 1, @"Count is one");
    
    ForTestClass *second = [[ForTestClass alloc] init];
    second.actual = @"B Second";
    
    ForTestClass *third = [[ForTestClass alloc] init];
    third.actual = @"C Third";
    
    ForTestClass *fourth = [[ForTestClass alloc] init];
    fourth.actual = @"D Fourth";
    
    [queue push:fourth];
    [queue push:second];
    [queue push:third];
    XCTAssert(queue.count == 4, @"Count is four");
}

- (void) testPriority
{
    RCWPrioQueue *queue = [[RCWPrioQueue alloc] init];
    ForTestClass *first = [[ForTestClass alloc] init];
    first.actual = @"A First";
    
    ForTestClass *second = [[ForTestClass alloc] init];
    second.actual = @"B Second";
    
    ForTestClass *third = [[ForTestClass alloc] init];
    third.actual = @"C Third";
    
    ForTestClass *fourth = [[ForTestClass alloc] init];
    fourth.actual = @"D Fourth";
    
    [queue push:fourth];
    [queue push:first];
    [queue push:second];
    [queue push:third];
    XCTAssertEqualObjects(first, [queue front], @"first is first");
}

- (void) testPop
{
    RCWPrioQueue *queue = [[RCWPrioQueue alloc] init];
    ForTestClass *first = [[ForTestClass alloc] init];
    first.actual = @"A First";
    
    ForTestClass *second = [[ForTestClass alloc] init];
    second.actual = @"B Second";
    
    ForTestClass *third = [[ForTestClass alloc] init];
    third.actual = @"C Third";
    
    ForTestClass *fourth = [[ForTestClass alloc] init];
    fourth.actual = @"D Fourth";
    
    [queue push:fourth];
    [queue push:first];
    [queue push:second];
    [queue push:third];
    XCTAssertEqualObjects(first, [queue pop], @"first is first");
    XCTAssertEqualObjects(second, [queue pop], @"second is first");
    XCTAssertEqualObjects(third, [queue pop], @"third is first");
    XCTAssertEqualObjects(fourth, [queue pop], @"fourth is first");
}

- (void) testSpeed
{
    RCWPrioQueue *queue = [[RCWPrioQueue alloc] init];
    NSLog(@"Start at %@",[NSDate date]);
    for (int i = 0;i < 10000; i++) {
        u_int32_t randval = arc4random_uniform(400);
        ForTestClass *toinsert = [[ForTestClass alloc] init];
        toinsert.actual = [NSString stringWithFormat:@"%d",randval];
        [queue push:toinsert];
    }
    NSLog(@"End at %@",[NSDate date]);
    
}


@end
