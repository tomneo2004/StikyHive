//
//  UserInfoEditorViewController.h
//  StikyHive
//
//  Created by Koh Quee Boon on 2/9/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "CropPhotoViewController.h"


@interface UserInfoEditorViewController : CropPhotoViewController <UIAlertViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *dateTextField;
@property (strong, nonatomic) IBOutlet UITextField *givenNameTextField;

@property (strong, nonatomic) IBOutlet UITextField *surnameTextField;
@property (strong, nonatomic) IBOutlet UITextField *addressTextField;
@property (strong, nonatomic) IBOutlet UITextField *pstalCodeTextField;
@property (strong, nonatomic) IBOutlet UITextField *countryTextField;
@property (strong, nonatomic) IBOutlet UILabel *givenNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *surnameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dobLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *countryLabel;
@property (strong, nonatomic) IBOutlet UILabel *postalCodeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)nextButtonPressed:(id)sender;

@end
