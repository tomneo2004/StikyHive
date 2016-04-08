//
//  PromotionViewController.h
//  StikyHive
//
//  Created by THV1WP15S on 3/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySkillInfo.h"

@interface PromotionViewController : UIViewController
@property (weak, nonatomic) MySkillInfo *mySkillInfo;
- (IBAction)wantBtnPressed:(id)sender;
- (IBAction)laterBtnPressed:(id)sender;

@end
