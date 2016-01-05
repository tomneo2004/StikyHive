//
//  JobHistoryCell.m
//  StikyHive
//
//  Created by THV1WP15S on 5/1/16.
//  Copyright (c) 2016 Stiky Hive. All rights reserved.
//

#import "JobHistoryCell.h"

@implementation JobHistoryCell

@synthesize timeLable = _timeLable;
@synthesize titleLabel = _titleLabel;
@synthesize countryLabel = _countryLabel;
@synthesize delegate = _delegate;


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapEdit:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(onEdit:)]) {
        [_delegate onEdit:self];
    }
    
}

- (IBAction)didTapDelete:(id)sender {
    if ([_delegate respondsToSelector:@selector(onDelete:)]) {
        [_delegate onDelete:self];
    }
}



@end
