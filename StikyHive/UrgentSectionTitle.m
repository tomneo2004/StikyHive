//
//  UrgentSectionTitle.m
//  StikyHive
//
//  Created by User on 16/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "UrgentSectionTitle.h"

@implementation UrgentSectionTitle

@synthesize delegate = _delegate;

#pragma mark - IBAction
- (IBAction)seeAll:(id)sender{
    
    if([_delegate respondsToSelector:@selector(urgentSectionSeeAll)]){
        
        [_delegate urgentSectionSeeAll];
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
