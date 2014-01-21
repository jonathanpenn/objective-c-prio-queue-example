//
//  PrioQueueProject.h
//  PrioQueueProject
//
//  Created by Josh Smith on 1/20/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//
#import <UIKit/UIKit.h>

@import CoreData;

@interface PrioQueueProject : UIManagedDocument

+ (instancetype) queue;
+ (NSURL *) fileURL;
- (NSUInteger) count;
- (id) front;
- (id) pop;
- (void) push:(id<NSCoding>) obj withPriority:(NSUInteger) prio;

@end
