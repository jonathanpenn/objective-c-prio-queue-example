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

CFBinaryHeapCallBacks defaultCallbacks = { 0, NULL, NULL, NULL, compare };

@interface RCWPrioQueue ()
@property (assign, nonatomic) CFBinaryHeapRef binHeap;
@end

@implementation RCWPrioQueue

- (instancetype) init {
    if (self = [super init]) {
        self.binHeap = CFBinaryHeapCreate(kCFAllocatorDefault, 0, &defaultCallbacks, NULL);
    }
    return self;
}

- (NSUInteger) count {
    return CFBinaryHeapGetCount(self.binHeap);
}

- (id) front {
    CFTypeRef retRef = NULL;
    id retObj = nil;
    BOOL ok = CFBinaryHeapGetMinimumIfPresent(self.binHeap, &retRef);
    if (ok) {
        retObj = CFBridgingRelease(retRef);
    }
    return retObj;
}

- (id) pop {
    id retObj = [self front];
    if (retObj) {
        CFBinaryHeapRemoveMinimumValue(self.binHeap);
    }
    return retObj;
}

- (void) push:(id<RCWPrioCanCompare>)obj {
    CFBinaryHeapAddValue(self.binHeap, CFBridgingRetain(obj));
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
