//
//  NoteViewController.h
//  Notery
//
//  Single note view. For editing an existing note or adding a new note. Supports adding/editing an image for the note as well as sending the note via email.
//
//  Created by Eden Dolev on 10/9/14.
//  Copyright (c) 2014 Eden Dolev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteStore.h"

@interface NoteViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate>

//notestore
@property (strong, nonatomic) NoteStore *noteStore;

//outlets
@property IBOutlet UITextField *noteHeaderTextField;
@property IBOutlet UITextView *noteBodyTextView;
@property IBOutlet UIButton *imageButton; //button that covers top image for segue to ImageViewController
@property IBOutlet UIImageView *image;

@property (weak, nonatomic) NSDate *noteDate;
@property (weak, nonatomic) Note *activeNote; //if in editing mode this is the current note being worked on

//actions
- (IBAction)selectPhoto:(id)sender;
- (IBAction)showEmail:(id)sender;



@end
