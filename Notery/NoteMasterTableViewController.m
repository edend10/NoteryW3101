//
//  NoteMasterTableViewController.m
//  Notery
//
//  ed2566
//  Created by Eden Dolev on 10/8/14.
//  Copyright (c) 2014 Eden Dolev. All rights reserved.
//



#import "NoteMasterTableViewController.h"
#import "NoteMasterTableViewCell.h"


@implementation NoteMasterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.noteStore = [NoteStore sharedNotes];
    
    //for testing
    //    [self.noteStore createTestNotes];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.noteStore.count;
}

//return string representation from a date object
+(NSString *)dateToString:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    return [dateFormatter stringFromDate:date];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //current cell
    NoteMasterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoteCell" forIndexPath:indexPath];
    
    if(cell == nil) {
        cell = [[NoteMasterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoteCell"];
    }

    //current note
    Note *note = [self.noteStore noteAtIndex:(int)indexPath.row];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //change selection cell color
        UIView *customColorView = [[UIView alloc] init];
        customColorView.backgroundColor = [UIColor colorWithRed:40/255.0
                                                          green:150/255.0
                                                           blue:211/255.0
                                                          alpha:0.7];
        cell.selectedBackgroundView =  customColorView;
        
        // Configure the cell
        cell.noteHeaderLabel.text = note.header;
        if(note.body.length == 0) {
            cell.notePreviewLabel.text = @"No content...";
            cell.notePreviewLabel.textColor = [UIColor grayColor];
        }
        else if(note.body.length > 71) {
            cell.notePreviewLabel.text = [note.body substringToIndex:70];
            cell.notePreviewLabel.textColor = [UIColor whiteColor];
        }
        else {
            cell.notePreviewLabel.text = note.body;
            cell.notePreviewLabel.textColor = [UIColor whiteColor];
        }
        cell.noteDateLabel.text = [NoteMasterTableViewController dateToString:note.date];
        
        //spinner for images if necessary while loading
        UIActivityIndicatorView *spinner=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.center = cell.noteImageView.center;
        spinner.hidesWhenStopped = YES;
        [self.view addSubview:spinner];
        [spinner startAnimating];
    
        if(note.image != nil) {
            cell.noteImageView.image = note.image;
        }
        else {
            //placeholder if necessary
            cell.noteImageView.image = [UIImage imageNamed:@"noImagePlaceholder.png"];
        }
        [spinner stopAnimating];
        
        if(cell.noteImageView.image != nil) {
            //set cell imageView size constraints specifically for each image width:height ratio for proper bordering
            float imageHeight = cell.noteImageView.image.size.height;
            float imageWidth = cell.noteImageView.image.size.width;
            float widthConstraintConstant = cell.imageViewWidthConstraint.constant;
            float multiplier = imageHeight / imageWidth;
            float resizedHeight;
        
            resizedHeight = widthConstraintConstant * multiplier;
            
            //tweak height constraint
            [cell.imageViewHeightConstraint setConstant:resizedHeight];
        
            // Create a white border with defined width
            cell.noteImageView.layer.borderColor = [UIColor whiteColor].CGColor;
            cell.noteImageView.layer.borderWidth = 1.5;
        
            // Set image corner radius
            cell.noteImageView.layer.cornerRadius = 5.0;
        
            // To enable corners to be "clipped"
            [cell.noteImageView setClipsToBounds:YES];
        }
    });
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.noteStore removeNoteAtIndex:(int)indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {

    self.noteStore.activeNoteIndex = (int) indexPath.row; //update selected note index
    [self performSegueWithIdentifier:@"MasterToNoteSegue" sender:self]; //segue to single note view
    
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    Note *tempNote = [self.noteStore noteAtIndex:(int)fromIndexPath.row];
    [self.noteStore removeNoteAtIndex:(int)fromIndexPath.row];
    [self.noteStore addNote:tempNote atIndex:(int)toIndexPath.row];
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.

    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
