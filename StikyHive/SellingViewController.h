//
//  SellingViewController.h
//  StikyHive
//
//  Created by THV1WP15S on 16/11/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellingViewController : UIViewController <UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate, UIWebViewDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;

@end
