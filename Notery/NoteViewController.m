//
//  NoteViewController.m
//  Notery
//
//  Created by Eden Dolev on 10/9/14.
//  Copyright (c) 2014 Eden Dolev. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "NoteViewController.h"
#import "ImageViewController.h"

@interface NoteViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;

@end

@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.noteStore = [NoteStore sharedNotes];
    if(self.noteStore.activeNoteIndex >= 0) {
        self.activeNote = [self.noteStore noteAtIndex:self.noteStore.activeNoteIndex];
    }
    
    [self fillFields];
    
}


//--textView place holer methods--

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([self.noteBodyTextView.textColor isEqual:[UIColor grayColor]]) {
        if([text isEqualToString:@""]) {
            return NO;
        }
        self.noteBodyTextView.text = @"";
        self.noteBodyTextView.textColor = [UIColor whiteColor];
    }
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if([self.noteBodyTextView.textColor isEqual:[UIColor grayColor]]) {
        [self performSelector:@selector(setCursorToBeginning:) withObject:self.noteBodyTextView afterDelay:0.01]; //set
    }
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(self.noteBodyTextView.text.length == 0){
        self.noteBodyTextView.textColor = [UIColor grayColor];
        self.noteBodyTextView.text = @"Write your note here...";
        [self performSelector:@selector(setCursorToBeginning:) withObject:self.noteBodyTextView afterDelay:0.01]; //set cursor to beginning
        //[self.noteBodyTextView resignFirstResponder];
    }
}

//textView has focus
- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView
{
    if([self.noteBodyTextView.textColor isEqual:[UIColor grayColor]]) {
        [self performSelector:@selector(setCursorToBeginning:) withObject:self.noteBodyTextView afterDelay:0.01]; //set
    }
    return YES;
}

//set cursor to beginning for textview placeholder
- (void)setCursorToBeginning:(UITextView *)inView
{
    inView.selectedRange = NSMakeRange(0, 0);
}

-(void)didMoveToParentViewController:(UIViewController *)parent {
    self.noteStore.activeNoteIndex = -1;
}

-(void)fillFields {
    if(self.activeNote != nil) { //edit existing note
        self.noteHeaderTextField.text = self.activeNote.header;
        self.noteBodyTextView.text = self.activeNote.body;
        //self.navigationItem.titleView = [self.noteImageImageView initWithImage: [UIImage imageNamed:@"photo (2).JPG"]];
        //self.noteImageImageView
        if(self.activeNote.image != nil) {
            //[self.imageButton setBackgroundImage:self.activeNote.image forState:UIControlStateNormal]; //set top image]
            [self.image setImage:self.activeNote.image];
            [self.imageButton setEnabled:YES];
            
            [self setImageBorder];
        }
        
    }
    else { //add new note
        self.noteHeaderTextField.text = @"";
        self.noteBodyTextView.text = @"";
        self.noteBodyTextView.text = @"Write your note here...";
        self.noteBodyTextView.textColor = [UIColor grayColor];
    }

}

//--end of textView placeholder methods--

//set imageView size constraints specifically for each image width:height ratio for proper bordering
//unlike master view, due to nav bar height here the height constraint is fixed and the width constraint is adjusted
-(void)setImageBorder {
    float imageHeight = self.image.image.size.height;
    float imageWidth = self.image.image.size.width;
    float heightConstraintConstant = self.imageViewHeightConstraint.constant;
    float multiplier = imageWidth / imageHeight;
    float resizedWidth;
    
    resizedWidth = heightConstraintConstant * multiplier;
    
    //tweak height constraint
    [self.imageViewWidthConstraint setConstant:resizedWidth];
    
    // Create tint border with defined width
    self.image.layer.borderColor = self.view.tintColor.CGColor;
    self.image.layer.borderWidth = 1.0;
    
    // Set image corner radius
    self.image.layer.cornerRadius = 5.0;
    
    // To enable corners to be "clipped"
    [self.image setClipsToBounds:YES];
}


- (IBAction)doneButtonPressed:(id)sender {
    if([self checkFields]) {
        NSString *tempHeader = self.noteHeaderTextField.text;
        NSString *tempBody;
        //if body is with placeholder, save empty string
        if([self.noteBodyTextView.textColor isEqual:[UIColor grayColor]]) {
                tempBody = @"";
        }
        else {
                tempBody = self.noteBodyTextView.text;
        }
        UIImage *tempImage = self.image.image;
    
        if(self.activeNote != nil) { //edit note
            [self.activeNote setValue:tempHeader forKey:@"header"];
            [self.activeNote setValue:tempBody forKey:@"body"];
            [self.activeNote setValue:tempImage forKey:@"image"];
        }
        else { //add new note
            Note *currentNote = [[Note alloc] initWithHeader:tempHeader andBody:tempBody];
            currentNote.image = tempImage;
            [self.noteStore addNote:currentNote];
        }
    
    [self.navigationController popViewControllerAnimated:YES];
    }
    
    //save all notes. ONLY NECESSARY FOR SIMULATOR. APP DELEGATE SAVES ON iOS DEVICE
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.noteStore archiveNoteStore];
    });
}

//--cancel button methods:--

- (IBAction)cancelButtonPressed:(id)sender {
    
    if([self madeChanges]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Dismiss Changes"
                                                      message:@"Are you sure you want to dismiss the changes you have made to the document?" delegate:self cancelButtonTitle:@"No" otherButtonTitles: @"Yes", nil];
        
        [alert show];
    }
}

//cancel changes
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//cancel button prompt "abort changes" method
-(BOOL)madeChanges {
    if(self.activeNote != nil) { //edit note
        if([self.noteHeaderTextField.text isEqualToString:self.activeNote.header]){
            if([self.noteBodyTextView.text isEqualToString:self.activeNote.body]) {
                if(self.image.image == self.activeNote.image) {
                    return YES;
                }
            }
        }
        return NO;
    }
    else { //new note
        if([self.noteHeaderTextField.text isEqualToString:@""]) {
            if([self.noteBodyTextView.text isEqualToString:@""]) {
                if(self.image.image == nil) {
                    return YES;
                }
            }
        }
        return NO;
    }
    
    return YES; //new note
}

//note must have at least a header
-(BOOL) checkFields {
    if(![self.noteHeaderTextField.text  isEqual: @""]) {
        return YES;
    }
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Missing Fields"
                                                    message:@"Please provide a header for your note." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
    [alert show];
    
    return NO;
}

//--end of cancel button methods--

-(void)selectPhoto:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

//--send email methods:--

- (IBAction)showEmail:(id)sender {
    NSString *title = [NSString stringWithFormat:@"Notery: %@", self.noteHeaderTextField.text];
    NSString *body = [NSString stringWithFormat:@"A note with Notery:\n\n%@", self.noteBodyTextView.text];
    
    MFMailComposeViewController *mcvc = [[MFMailComposeViewController alloc] init];
    mcvc.mailComposeDelegate = self;
    [mcvc setSubject:title];
    [mcvc setMessageBody:body isHTML:NO];
    //set to recipients? no need
    
    if(self.image.image != nil) {
        NSData *data = UIImagePNGRepresentation(self.image.image);
        [mcvc addAttachmentData:data mimeType:@"image/png" fileName:@"ImagenFinal"];
    }
    [self presentViewController:mcvc animated:YES completion:nil];
    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail Cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail Saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail Sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail Failed: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//--end of send email methods--

//--pick image methods:--

-(void)imagePickerController:(UIImagePickerController *)imagePicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];

    [self.imageButton setEnabled:YES]; //enable image button
    
    //test
    //[self.imageButton setBackgroundImage:chosenImage forState:UIControlStateNormal]; //set top image
    [self.image setImage:chosenImage];
    [self setImageBorder];
    
    [imagePicker dismissViewControllerAnimated:YES completion: nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePicker {
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//--end of pick image methods--

#pragma mark - Navigation

//if user presses top image, segues to ImageViewController to view larger image
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"viewImageSegue"]) {
        ImageViewController *imageViewController = (ImageViewController *)segue.destinationViewController;
        
        
        imageViewController.image = self.image.image;
    }
}


@end
