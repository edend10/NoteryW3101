//
//  NoteMasterTableViewController.h
//  Notery
//
//  Note master view. Shows all the notes.
//
//  ed2566
//  Created by Eden Dolev on 10/8/14.
//  Copyright (c) 2014 Eden Dolev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteStore.h"

@interface NoteMasterTableViewController : UITableViewController

@property (strong, nonatomic) NoteStore *noteStore;

@end
