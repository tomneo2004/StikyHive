//
//  PaySummaryViewController.h
//  StikyHive
//
//  Created by THV1WP15S on 4/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"


@interface PaySummaryViewController : UIViewController <UIScrollViewDelegate,PayPalPaymentDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (strong, nonatomic) IBOutlet UILabel *basicLabel;

@property (strong, nonatomic) IBOutlet UILabel *defDurationLabel;

@property (strong, nonatomic) IBOutlet UILabel *defUnitLabel;




@end
