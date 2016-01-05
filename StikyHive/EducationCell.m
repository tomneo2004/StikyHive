//
//  EducationCell.m
//  StikyHive
//
//  Created by User on 5/1/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "EducationCell.h"

@implementation EducationCell

@synthesize instituteLabel = _instituteLabel;
@synthesize qualificationLabel = _qualificationLabel;
@synthesize dateLabel = _dateLabel;
@synthesize delegate = _delegate;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onEdit:(id)sender{
    
    if([_delegate respondsToSelector:@selector(onEdit:)]){
        
        [_delegate onEdit:self];
    }
}

- (IBAction)onDelete:(id)sender{
    
    if([_delegate respondsToSelector:@selector(onDelete:)]){
        
        [_delegate onDelete:self];
    }
}

@end
