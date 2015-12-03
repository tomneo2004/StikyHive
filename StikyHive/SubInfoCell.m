//
//  SubInfoCell.m
//  StikyHive
//
//  Created by User on 3/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "SubInfoCell.h"

@implementation SubInfoCell

@synthesize skillNameLabel = _skillNameLabel;
@synthesize datePostLabel = _datePostLabel;
@synthesize dateExpireLabel = _dateExpireLabel;
@synthesize monthsLeftLabel = _monthsLeftLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
