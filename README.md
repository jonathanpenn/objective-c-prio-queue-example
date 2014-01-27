Core Data As Data Structure Service
===================================

Your first day at your new job your boss walks into your office and
says the project needs a priority queue. She tells you it shouldn't
take to long to write and then leaves you to get it done. Just to make
sure you understand fully what she asked you to do, you Google
`Objective C` and `Priority Queue`. The first thing you find out is
that there isn't a generic priority queue in Objective C. The other
thing you learn is that a priority queue is an abstract data type like
a regular queue or a stack. Unlike a regular queue, each element has a
priority and the order of the elements in a priority queue is
determined by this priority (hence the name). Additionally, Wikipedia
notes that a priority queue can be implemented using a list. Now
confident you understand the problem you start typing furiously ,
because we all know there is no problem that cannot be solved by
typing faster.

What you come up with is a decent, though naive, priority queue. You
have chosen to use a mutable list that you sort every time you add an
element.  

    @interface NaivePrioQueue : NSEnumerator
    - (instancetype) initWithComparator:(NSComparator) cmp;
    - (NSUInteger) count;
    - (id) pop;
    - (id) front;
    - (void) push:(id) obj;
    @end


It's not a lot of code, and it works.  The code is testable and clean.  So, you show it to your boss and she says it's ok,  but maybe it would be better to implement it using a CFBinaryHeap.    You had no idea such a thing existed.  A quick glance at NSHipster reveals that it does exists AND you can implement a priority queue in it.  So you do.  

[ insert code]

This version is pretty awesome you think.  It's faster and cleaner than the first version.  You proudly show it to the tech lead and she sighs.  You know this is a bad sign.  The problem is, she tells you,  the project has a requirement that queue be persistent.  Meaning the queue has to be stored in a such a way as to be recovered if the phone is rebooted,  or the app is killed, or something else.  You stop and check your shirt to see if it's red and then continue because this seems impossible.  Serializing can be done with the array, sure, but only if it's smaller than memory.  Serializing a CFBinaryHeap sounds pretty hard.  So What to do?  The tech lead nods her head toward an office you know you should not approach.  Facing the door like some sort of voodoo skull is the partially disassembled corpse of something called a MicroVAX.  You shudder and approach Sharon's office.  Her gray hair and persistent use of something called Emacs has made her the terror of the intern pool.  

You knock gently and she turns and stares as you as you stammer out the requirements.  She leans back for a minute, clearly thinking, and then says "Use Core Data.  A UIManagedDocument subclass can encapsulate it all for you."
And then she turns back to her terminal and you are dismissed.  

You go back to you desk and start typing again,  this time entering a new part of Cocoa Development and wondering just how far down this rabbit hole can go.

The thing to remember is that Core Data isn't just some fancy-pants ORM.  It's really a data structure service that provides the ability to persist when you need it.  You don't have to persist anything,  and if you use the in-memory store you can't really persist anything.    Since you don't have an existing model to work with you can just create one in code.  You don't even have to manage the Core Data Stack because the UIManagedDocument class does that for you. 
