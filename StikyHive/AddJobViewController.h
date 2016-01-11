//
//  AddJobViewController.h
//  StikyHive
//
//  Created by THV1WP15S on 5/1/16.
//  Copyright (c) 2016 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobInfo.h"
#import "ActionSheetPicker.h"
#import "OtherInfoViewController.h"

@interface AddJobViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, OtherInfoViewControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *jobScrollView;

@property (weak, nonatomic) IBOutlet UITextField *companyNameTextField;

@property (strong, nonatomic) IBOutlet UITextField *countryTextField;

@property (strong, nonatomic) IBOutlet UITextField *jobTitleTextField;

@property (strong, nonatomic) IBOutlet UITextField *fromMMTextField;

@property (strong, nonatomic) IBOutlet UITextField *fromYYTextField;

@property (strong, nonatomic) IBOutlet UITextField *toMMTextField;

@property (strong, nonatomic) IBOutlet UITextField *toYYTextField;

@property (strong, nonatomic) IBOutlet UIButton *checkBox;
@property (strong, nonatomic) IBOutlet UIWebView *infoWebView;

- (IBAction)checkBoxPressed:(id)sender;
@property (nonatomic, strong) JobInfo *jobInfo;

@end
