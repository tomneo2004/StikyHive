//
//  SellingViewController4.h
//  StikyHive
//
//  Created by THV1WP15S on 30/11/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySkillInfo.h"

@interface SellingViewController4 : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate>


@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) IBOutlet UISwitch *switchBtn1;
@property (strong, nonatomic) IBOutlet UISwitch *switchBtn2;
@property (strong, nonatomic) IBOutlet UISwitch *switchBtn3;
@property (strong, nonatomic) IBOutlet UISwitch *switchBtn4;
@property (weak, nonatomic) MySkillInfo *mySkillInfo;
- (IBAction)switchBtn2Pressed:(id)sender;
- (IBAction)switchBtn3Pressed:(id)sender;
- (IBAction)switchBtn4Pressed:(id)sender;
- (IBAction)nextBtn:(id)sender;

@end
