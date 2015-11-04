 //
//  UserSkillViewController1.h
//  StikyHive
//
//  Created by Koh Quee Boon on 26/5/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextEditorViewController.h"

@interface UserSkillViewController1 : TextEditorViewController
<UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate, UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *skillTitleTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *skillSegmentedControl;
@property (strong, nonatomic) IBOutlet UIPickerView *skillCategoryPicker;
@property (strong, nonatomic) IBOutlet UIWebView *skillDescWebview;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

- (IBAction)skillTypeSelected:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;

+ (UIViewController *) instantiateForInfo:(NSDictionary *)skillInfo;

@end
