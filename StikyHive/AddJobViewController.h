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

@protocol AddJobDelegate <NSObject>

@optional
- (void)onUpdateJobSuccessful;
- (void)onAddNewJobSuccessful;

@end

@interface AddJobViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, OtherInfoViewControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *jobScrollView;

@property (weak, nonatomic) IBOutlet UITextField *companyNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *countryTextField;

@property (weak, nonatomic) IBOutlet UITextField *jobTitleTextField;

@property (weak, nonatomic) IBOutlet UITextField *fromMMTextField;

@property (weak, nonatomic) IBOutlet UITextField *fromYYTextField;

@property (weak, nonatomic) IBOutlet UITextField *toMMTextField;

@property (weak, nonatomic) IBOutlet UITextField *toYYTextField;

@property (weak, nonatomic) IBOutlet UIButton *checkBox;
@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;

@property (weak, nonatomic) id<AddJobDelegate> delegate;

- (IBAction)checkBoxPressed:(id)sender;
@property (nonatomic, strong) JobInfo *jobInfo;
- (IBAction)saveBtnPressed:(id)sender;



@end
