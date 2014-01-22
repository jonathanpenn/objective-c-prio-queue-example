//
//  NaivePrioQueue.h
//  PrioQueueProject
//
//  Created by Josh Smith on 1/22/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NaivePrioQueue : NSEnumerator

- (instancetype) initWithComparator:(NSComparator) cmp;
- (NSUInteger) count;
- (id) pop;
- (id) front;
- (void) push:(id) obj;

@end
