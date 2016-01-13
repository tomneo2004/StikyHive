//
//  EmptyEducationView.m
//  StikyHive
//
//  Created by User on 12/1/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "EmptyEducationView.h"

@implementation EmptyEducationView

@synthesize delegate = _delegate;

- (IBAction)addInfo:(id)sender{
    
    if([_delegate respondsToSelector:@selector(onAddInfoTap)]){
        
        [_delegate onAddInfoTap];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
