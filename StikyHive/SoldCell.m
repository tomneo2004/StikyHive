//
//  SoldCell.m
//  StikyHive
//
//  Created by User on 4/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "SoldCell.h"

@implementation SoldCell

@synthesize titleLabel = _titleLabel;
@synthesize soldToLabel = _soldToLabel;
@synthesize onLabel = _onLabel;
@synthesize forLabel = _forLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
