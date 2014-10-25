//
//  NoteMasterTableViewCell.h
//  Notery
//
//  ed2566
//  Created by Eden Dolev on 10/8/14.
//  Copyright (c) 2014 Eden Dolev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteMasterTableViewCell : UITableViewCell

@property IBOutlet UIImageView *noteImageView;
@property IBOutlet UILabel *noteHeaderLabel;
@property IBOutlet UILabel *notePreviewLabel;
@property IBOutlet UILabel *noteDateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;


@end
