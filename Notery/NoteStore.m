//
//  NoteStore.m
//  Notery
//
//  Created by Eden Dolev on 10/8/14.
//  Copyright (c) 2014 Eden Dolev. All rights reserved.
//

#import "NoteStore.h"

@interface NoteStore()
@property NSMutableArray *store;
@end

@implementation NoteStore

-(id)initPrivate{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if(self=[super init]) {
        NSData *data;
        if((data = [ud objectForKey:@"store"])==nil)
            self.store = [NSMutableArray new];
        else{
            self.store = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        self.activeNoteIndex = -1;
        return self;
    }
    return nil;
}

//encoder methods
-(id)initWithCoder:(NSCoder *)decoder {
    if(self = [super init]) {
        self.store = [decoder decodeObjectForKey:@"store"];
        return self;
    }
    return nil;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.store forKey:@"store"];
}

//singleton returns the shared notes array
+(NoteStore *)sharedNotes{
    static NoteStore *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] initPrivate];
    });
    
    return sharedInstance;
}

//returns count of notes
-(NSUInteger)count {
    return self.store.count;
}

//returns note at index
-(Note *)noteAtIndex:(int)index {
    return self.store[index];
}

//add note to end of array
-(void)addNote:(Note *)note{
    [self.store addObject:note];
}

//add note at index
-(void)addNote:(Note *)note atIndex:(int)index {
    [self.store insertObject:note atIndex:index];
}

//removes note at index
-(void)removeNoteAtIndex:(int)index {
    [self.store removeObjectAtIndex:index];
}

//used for debugging
-(void)createTestNotes {
    for(int i = 0; i < 0; i++) {
        Note *n = [[Note alloc] initWithHeader:@"kaka" andBody:@"paiddafadffjadpijfaidpf"];
        [self addNote:n];
    }
}

//archive notes
-(void)archiveNoteStore{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.store];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"store"];
}

@end
