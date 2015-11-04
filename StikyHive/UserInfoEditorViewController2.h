//
//  UserInfoEditorViewController2.h
//  StikyHive
//
//  Created by Koh Quee Boon on 19/8/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "TextEditorViewController.h"
#import "TextEditorViewController.h"

#define DATA_HOST_2       @"http://202.150.214.50/"

@interface UserInfoEditorViewController2 : TextEditorViewController <UIPickerViewDataSource, UIPickerViewDelegate> //{
//    UIPickerView *industryPickerView;
//    UIPickerView *categoryPickerView;
//}
@property (strong, nonatomic) IBOutlet UILabel *skillLabel;
@property (strong, nonatomic) IBOutlet UITextField *skillTextField;
@property (strong, nonatomic) IBOutlet UILabel *industryLabel;
@property (strong, nonatomic) IBOutlet UITextField *industryTextField;
@property (strong, nonatomic) IBOutlet UILabel *hobbyLabel;
@property (strong, nonatomic) IBOutlet UITextField *hobbyTextField;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UITextField *categoryTextField;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

- (IBAction)doneButtonPressed:(id)sender;

@end
