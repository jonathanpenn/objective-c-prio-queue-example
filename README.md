Core Data As Data Structure Service
===================================

On the first day at your new job your boss walks into your office and says the
project needs a priority queue. She tells you it shouldn't take to long to
write and then leaves you to get it done.

Just to make sure you understand fully what she asked for, you Google
`Objective-C` and `Priority Queue`.  The first thing you find out is that there
isn't a generic priority queue in Objective-C. Then you learn that a priority
queue is an abstract data type like a regular queue or a stack, but each
element has a priority and the order of the elements in a priority queue is
determined by this priority (hence the name). Additionally, Wikipedia notes
that a priority queue can be implemented using a list.

Now confident you understand the problem you start typing furiously, because we
all know there is no problem that cannot be solved by typing faster.

What you come up with is a decent, though naive, priority queue. You have
chosen to use a mutable list that you sort every time you add an element:

    @interface NaivePrioQueue : NSEnumerator
    - (instancetype) initWithComparator:(NSComparator) cmp;
    - (NSUInteger) count;
    - (id) pop;
    - (id) front;
    - (void) push:(id) obj;
    @end


It's not a lot of code, and it works. The code is testable and clean. So, you
show it to your boss and she says it's ok, but maybe it would be better to
implement it using a `CFBinaryHeap`. You had no idea such a thing existed. A
quick glance at [NSHipster][nsh] reveals that it does exists *and* you can
implement a priority queue in it. So you do.

  [nsh]: http://nshipster.com

The first thing you set up is a protocol for objects you add to this priority
queue to manage the comparators:

    @protocol RCWPrioCanCompare <NSObject>
    - (CFComparisonResult) compareWith:(id<RCWPrioCanCompare>) otherObj;
    - (NSString *) comparisonValue;
    @end


Then the interface looks like this:

    @interface RCWPrioQueue : NSEnumerator
    - (NSUInteger) count;
    - (void) push:(id<RCWPrioCanCompare>) obj;
    - (id) pop;
    - (id) front;
    @end

This version is pretty awesome you think. It's faster and cleaner than the
first version. You proudly show it to the tech lead and she sighs. You know
this is a bad sign.

The problem is, she tells you, the project requires that queue be persistent.
The queue has to be stored in a such a way that it can recover if the phone is
rebooted, the app is killed, or something else. You stop and check your shirt
to see if it's red because this seems impossible. Serializing can be done with
the array, sure, but only if it's smaller than memory. Serializing a
`CFBinaryHeap` sounds pretty hard. So What to do?

The tech lead nods her head toward an office you know you should not approach.
Opposity the door hangs a partially disassembled corpse of something called a
MicroVAX in the shape of a voodoo skull. You shudder and approach Sharon's
office. Her gray hair and insistent use of something called Emacs has made her
the terror of the intern pool.

You knock gently. She turns and stares as you as you stammer out the
requirements. She leans back for a minute, clearly thinking, and then says,
"Use Core Data. A UIManagedDocument subclass can encapsulate it all for you."
And then she turns back to her terminal and you are dismissed.

You go back to you desk and start typing again, this time entering a new domain
of Cocoa Development and wondering just how far down this rabbit hole can go.

You can use the `@import` syntax to pull Core Data into your project with one
line:

    @import CoreData;

Then the interface looks like this:

    @interface PrioQueueProject : UIManagedDocument

    + (instancetype) queue;
    + (NSURL *) fileURL;
    - (NSUInteger) count;
    - (id) front;
    - (id) pop;
    - (void) push:(id<NSCoding>) obj withPriority:(NSUInteger) prio;
    @end

A big change is the `fileURL` and `queue` class methods. The `queue` class is
an alloc/init combo similar to the `array` method on `NSArray`. The `fileURL`
is how you can change the location of the persistant store in subclasses.
Because this is a base class and we're not assuming that a model exists the
class creates a model in code. The model is pretty simple. It includes a
single entity that has two attributes. The priority attribute is used for
ordering, and the target attribute is a serialized version (via `NSCoding`) of
the object in the queue.

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

All of the hard work happens in using the fetch request.

    - (void) setupFetchRequest {
        self.fetch = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
        NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:PQP_PRIO_KEY
                                                               ascending:NO];
        self.fetch.fetchLimit = 1;

        self.fetch.sortDescriptors = @[ sortDesc ];
    }

Because we only care about the first element, we can set the `fetchLimit` to 1.
This fetch request is fired every time an element is added or removed from the
queue, and the result of the fetch request is cached for use in the `front`
method. The power of Core Data as a data structure service saves the day.

## Epilogue

The thing to remember is that Core Data isn't just some fancy-pants ORM. It is
really a data structure service that provides the ability to persist when you
need it. You don't have to persist anything, and if you use the in-memory
store, it won't. You don't need an existing model definition file to work with
since you can just create the `NSManagedObjectModel` in code. You don't even
have to manage the Core Data Stack because the UIManagedDocument class does
that for you.

The full code can be found at https://github.com/kognate/objective-c-prio-queue-example

