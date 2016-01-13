//
//  NoExperienceView.m
//  StikyHive
//
//  Created by THV1WP15S on 13/1/16.
//  Copyright (c) 2016 Stiky Hive. All rights reserved.
//

#import "NoExperienceView.h"

@implementation NoExperienceView

@synthesize delegate = _delegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)addInfoTapped:(id)sender {
    if ([_delegate respondsToSelector:@selector(onAddJobTapped)]) {
        [_delegate onAddJobTapped];
    }
}
@end
