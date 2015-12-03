//
//  DocumentTableViewCell.m
//  StikyHive
//
//  Created by User on 1/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "DocumentTableViewCell.h"

@implementation DocumentTableViewCell

@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
