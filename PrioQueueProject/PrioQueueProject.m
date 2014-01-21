//
//  PrioQueueProject.m
//  PrioQueueProject
//
//  Created by Josh Smith on 1/20/14.
//  Copyright (c) 2014 Josh Smith. All rights reserved.
//

#import "PrioQueueProject.h"

@interface PrioQueueProject ()
@property (strong, nonatomic) NSManagedObjectModel *privateModel;
@property (strong, nonatomic) NSFetchRequest *fetch;
@property (strong, nonatomic) NSArray *fetchCache;
@property (nonatomic) NSUInteger countCache;
- (void) setupFetchRequest;
- (void) updateCacheInContext:(NSManagedObjectContext *) context;
@end

static NSString *PQP_PRIO_KEY = @"priority";
static NSString *PQP_OBJECT_KEY = @"target";

@implementation PrioQueueProject

+ (NSURL *) fileURL {
    NSURL *bogus = [NSURL URLWithString:@"file:///tmp.bogus"];
    return bogus;
}

+ (instancetype) queue {
    id ret = [[self alloc] initWithFileURL:[self fileURL]];
    [ret setupFetchRequest];
    return ret;
}

- (void) setupFetchRequest {
    self.fetch = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:PQP_PRIO_KEY
                                                               ascending:NO];
    self.fetch.fetchLimit = 1;

    self.fetch.sortDescriptors = @[ sortDesc ];
}

- (void) updateCacheInContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    self.fetchCache = [context executeFetchRequest:self.fetch error:&error];
    assert(error == nil);

    NSString *entity = NSStringFromClass([self class]);
    NSFetchRequest *_count = [NSFetchRequest fetchRequestWithEntityName:entity];
    _count.resultType = NSCountResultType;
    self.countCache = [context countForFetchRequest:_count error:&error];
    assert(error == nil);
}

- (id) front {
    NSManagedObject *obj = [self.fetchCache firstObject];
    return [obj valueForKey:PQP_OBJECT_KEY];
}

- (id) pop {
    id retval = nil;
    if ([self count] > 0) {
        NSManagedObject *obj = [self.fetchCache firstObject];
        retval = [obj valueForKey:PQP_OBJECT_KEY];
        NSManagedObjectContext *ctx = [self managedObjectContext];
        [ctx performBlockAndWait:^{
            [[self managedObjectContext] deleteObject:obj];
            NSError *error = nil;
            [[self managedObjectContext] save:&error];
            assert(error == nil);
            [self updateCacheInContext:ctx];
        }];
    }
    return retval;
}

- (void) push:(id<NSCoding>)obj withPriority:(NSUInteger)prio {
    NSManagedObjectContext *ctx = [self managedObjectContext];
    [ctx performBlockAndWait:^{

        NSString *entity_name = NSStringFromClass([self class]);
        NSManagedObject *toinsert = [NSEntityDescription insertNewObjectForEntityForName:entity_name
                                                              inManagedObjectContext:ctx];
        [toinsert setValue:@(prio) forKey:PQP_PRIO_KEY];
        [toinsert setValue:obj forKey:PQP_OBJECT_KEY];
        NSError *error = nil;
        [ctx save:&error];
        assert(error == nil);
        [self updateCacheInContext:ctx];
    }];
}

- (NSString *) persistentStoreTypeForFileType:(NSString *)fileType {
    return NSInMemoryStoreType;
}

- (NSManagedObjectModel *) managedObjectModel {
    if (self.privateModel == nil) {
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] init];
        NSEntityDescription *entity = [[NSEntityDescription alloc] init];
        entity.name = NSStringFromClass([self class]);
        
        NSAttributeDescription *prio_attr = [[NSAttributeDescription alloc] init];
        prio_attr.name = PQP_PRIO_KEY;
        prio_attr.attributeType = NSInteger64AttributeType;
        
        NSAttributeDescription *target_attr = [[NSAttributeDescription alloc] init];
        target_attr.name = PQP_OBJECT_KEY;
        target_attr.attributeType = NSTransformableAttributeType;
        
        entity.properties = @[ prio_attr, target_attr];
        [model setEntities:@[entity]];
        self.privateModel = model;
    }
    return self.privateModel;
}

- (NSUInteger)  count {
    return self.countCache;
}

@end
