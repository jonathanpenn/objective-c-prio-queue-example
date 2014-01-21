//
//  MySubClass.m
//  PrioQueueProject
//
//  Created by Josh Smith on 1/20/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import "MySubClass.h"

@implementation MySubClass

+ (NSURL *) fileURL {
    return [NSURL fileURLWithPath:@"some/path/somewhere"];
}

- (NSString *) persistentStoreTypeForFileType:(NSString *)fileType {
    return NSSQLiteStoreType;
}

@end
