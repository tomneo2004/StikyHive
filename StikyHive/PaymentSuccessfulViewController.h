//
//  PaymentSuccessfulViewController.h
//  StikyHive
//
//  Created by User on 27/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PaymentSuccessfulViewController;

@protocol PaymentSuccessfulDelegate <NSObject>

@optional
- (void)onBackToCrossPollinateTap:(PaymentSuccessfulViewController *)controller;

@end

@interface PaymentSuccessfulViewController : UIViewController

@property (weak, nonatomic) id<PaymentSuccessfulDelegate> delegate;

@end
