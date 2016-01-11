//
//  SubInfoCell.h
//  StikyHive
//
//  Created by User on 3/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *skillNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *datePostLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateExpireLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthsLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *subPlanLabel;

@end
