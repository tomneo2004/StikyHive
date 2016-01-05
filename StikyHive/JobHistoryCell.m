//
//  JobHistoryCell.m
//  StikyHive
//
//  Created by THV1WP15S on 5/1/16.
//  Copyright (c) 2016 Stiky Hive. All rights reserved.
//

#import "JobHistoryCell.h"

@implementation JobHistoryCell{
    BOOL _isInit;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapEdit:(id)sender {
    
    
    
}

- (IBAction)didTapDelete:(id)sender {
}

#pragma mark - override
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    if (_isInit) {
        
        
        
        
        
        _isInit = YES;
        
    }
}

#pragma mark - override
- (void)prepareForReuse
{
    _titleLabel = nil;
    _timeLable = nil;
    _countryLabel = nil;
    
    
}


@end
