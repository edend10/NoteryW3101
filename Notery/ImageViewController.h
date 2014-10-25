//
//  ImageViewController.h
//  Notery
//
// ViewController for note image display
//
//  Created by Eden Dolev on 10/10/14.
//  Copyright (c) 2014 Eden Dolev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController

@property (strong, nonatomic) UIImage *image;
@property IBOutlet UIImageView *imageView;

@end
