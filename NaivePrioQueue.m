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
    [self.datastore sortUsingComparator:self.comparator];
}

- (id) pop
{
    id first = [self.datastore firstObject];
    [self.datastore removeObject:first];
    [self.datastore sortUsingComparator:self.comparator];
    return first;
}

- (id) front
{
    return [self.datastore firstObject];
}

- (NSUInteger) count
{
    return [self.datastore count];
}

- (NSArray *) allObjects {
    return self.datastore;
}

- (id) nextObject
{
    return [self pop];
}

@end
