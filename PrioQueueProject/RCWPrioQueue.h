//
//  RCWPrioQueue.h
//  PrioQueueProject
//
//  Created by Josh Smith on 1/21/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RCWPrioCanCompare <NSObject>

- (CFComparisonResult) compareWith:(id<RCWPrioCanCompare>) otherObj;
- (NSString *) comparisonValue;

@end

@interface RCWPrioQueue : NSEnumerator

- (NSUInteger) count;
- (void) push:(id<RCWPrioCanCompare>) obj;
- (id) pop;
- (id) front;

@end
