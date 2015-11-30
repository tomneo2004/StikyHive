//
//  MyRequestSectionTitle.m
//  StikyHive
//
//  Created by User on 16/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "MyRequestSectionTitle.h"

@implementation MyRequestSectionTitle

@synthesize delegate = _delegate;

#pragma mark - IBAction
- (IBAction)seeAll:(id)sender{
    
    if([_delegate respondsToSelector:@selector(myRequestSectionSeeAll)]){
        
        [_delegate myRequestSectionSeeAll];
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
