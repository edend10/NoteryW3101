//
//  Note.h
//  Notery
//
//  Represents a single note entry. Header, body, image and date created.
//
//  Created by Eden Dolev on 10/8/14.
//  Copyright (c) 2014 Eden Dolev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Note : NSObject <NSCoding>
@property NSString *header;
@property NSDate *date;
@property NSString *body;
@property UIImage *image;

-(id)initWithHeader:(NSString *)header andBody:(NSString *)body;
@end
