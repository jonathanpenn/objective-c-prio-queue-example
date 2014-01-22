//
//  RCWPrioQueue.m
//  PrioQueueProject
//
//  Created by Josh Smith on 1/21/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import "RCWPrioQueue.h"

CFComparisonResult compare(const void *lefthandside, const void *righthandside, void *unused) {
    id<RCWPrioCanCompare> left = (__bridge id<RCWPrioCanCompare>)lefthandside;
    id<RCWPrioCanCompare> right = (__bridge id<RCWPrioCanCompare>)righthandside;
    return [left compareWith:right];
}

CFBinaryHeapCallBacks callbacks = { 0, NULL, NULL, NULL, compare };

@interface RCWPrioQueue ()
@end

@implementation RCWPrioQueue

- (instancetype) init {
    if (self = [super init]) {
        binHeap = CFBinaryHeapCreate(kCFAllocatorDefault, 0, &callbacks, NULL);
    }
    return self;
}

- (NSUInteger) count {
    return CFBinaryHeapGetCount(binHeap);
}

- (id) front {
    CFTypeRef retRef = NULL;
    id retObj = nil;
    BOOL ok = CFBinaryHeapGetMinimumIfPresent(binHeap, &retRef);
    if (ok) {
        retObj = CFBridgingRelease(retRef);
    }
    return retObj;
}

- (id) pop {
    id retObj = [self front];
    if (retObj) {
        CFBinaryHeapRemoveMinimumValue(binHeap);
    }
    return retObj;
}

- (void) push:(id<RCWPrioCanCompare>)obj {
    CFBinaryHeapAddValue(binHeap, CFBridgingRetain(obj));
}

- (id) nextObject {
    return [self pop];
}

- (NSArray *) allObjects {
    NSMutableArray *retval = [NSMutableArray array];
    for (int i=0; i < [self count]; i++) {
        [retval addObject:[self pop]];
    }
    return retval;
}

@end
