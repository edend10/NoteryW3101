//
//  NoteStore.h
//  Notery
//
// The store of notes. Contains an array with all note entries. This is a singleton class, only one instance is possible. Capable of adding/removing notes by index and archive itself on the device.
//
//  ed2566
//  Created by Eden Dolev on 10/8/14.
//  Copyright (c) 2014 Eden Dolev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

@interface NoteStore : NSObject <NSCoding>

@property int activeNoteIndex;

+(NoteStore *)sharedNotes;
-(NSUInteger)count;
-(Note *)noteAtIndex:(int)index;
-(void)addNote:(Note *)note;
-(void)addNote:(Note *)note atIndex: (int)index;
-(void)removeNoteAtIndex:(int)index;
-(void)createTestNotes;
-(void)archiveNoteStore;


@end
