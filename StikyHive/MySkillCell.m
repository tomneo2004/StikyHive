//
//  MySkillCell.m
//  StikyHive
//
//  Created by User on 17/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "MySkillCell.h"

@implementation MySkillCell

@synthesize titleLabel = _titleLabel;
@synthesize issueDateLabel = _issueDateLabel;
@synthesize expiredDateLabel = _expiredDateLabel;
@synthesize delegate = _delegate;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - IBAction
- (IBAction)edit:(id)sender{
    
    if([_delegate respondsToSelector:@selector(onEditTap:)]){
        
        [_delegate onEditTap:self];
    }
}

- (IBAction)view:(id)sender{
    
    if([_delegate respondsToSelector:@selector(onViewTap:)]){
        
        [_delegate onViewTap:self];
    }
}

- (IBAction)delete:(id)sender{
    
    if([_delegate respondsToSelector:@selector(onDeleteTap:)]){
        
        [_delegate onDeleteTap:self];
    }
}

@end
