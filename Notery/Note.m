//
//  Note.m
//  Notery
//
//  ed2566
//  Created by Eden Dolev on 10/8/14.
//  Copyright (c) 2014 Eden Dolev. All rights reserved.
//

#import "Note.h"

@implementation Note
-(id)initWithHeader:(NSString *)header andBody:(NSString *)body {
    if(self = [super init]) {
        self.header = header;
        self.body = body;
        self.date = [NSDate date];
        self.image = nil;
        
        return self;
    }
    return nil;
}

//coder methods
-(id)initWithCoder:(NSCoder *)decoder {
    if(self = [super init]) {
        self.header = [decoder decodeObjectForKey:@"header"];
        self.body = [decoder decodeObjectForKey:@"body"];
        self.date = [decoder decodeObjectForKey:@"date"];
        self.image = [decoder decodeObjectForKey:@"image"];
        
        return self;
    }
    return nil;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.header forKey:@"header"];
    [encoder encodeObject:self.body forKey:@"body"];
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeObject:self.image forKey:@"image"];
}

@end
