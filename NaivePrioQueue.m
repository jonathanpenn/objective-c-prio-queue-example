//
//  NaivePrioQueue.m
//  PrioQueueProject
//
//  Created by Josh Smith on 1/22/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import "NaivePrioQueue.h"

@interface NaivePrioQueue ()
@property (strong, nonatomic) NSComparator comparator;
@property (strong, nonatomic) NSMutableArray *datastore;
@property (strong, nonatomic) NSArray *sorted;
@end

@implementation NaivePrioQueue

- (instancetype) initWithComparator:(NSComparator)cmp
{
    if (self = [self init]) {
        self.comparator = cmp;
        self.datastore = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) push:(id)obj {
    [self.datastore addObject:obj];
    self.sorted = [self.datastore sortedArrayUsingComparator:self.comparator];
}

- (id) pop
{
    id first = [self.sorted firstObject];
    [self.datastore removeObject:first];
    self.sorted = [self.datastore sortedArrayUsingComparator:self.comparator];
    return first;
}

- (id) front
{
    return [self.sorted firstObject];
}

- (NSUInteger) count
{
    return [self.sorted count];
}

- (NSArray *) allObjects {
    return self.sorted;
}

- (id) nextObject
{
    return [self pop];
}

@end
