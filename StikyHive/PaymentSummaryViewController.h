//
//  PaymentSummaryViewController.h
//  StikyHive
//
//  Created by User on 27/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleViewController.h"
#import "PayPalMobile.h"
#import "PaymentSuccessfulViewController.h"

@interface PaymentSummaryViewController : TitleViewController<PayPalPaymentDelegate, PaymentSuccessfulDelegate>

@end
