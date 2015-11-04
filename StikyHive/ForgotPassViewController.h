//
//  ForgotPassViewController.h
//  StikyHive
//
//  Created by Koh Quee Boon on 10/9/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "TextEditorViewController.h"

@interface ForgotPassViewController : TextEditorViewController



@property (strong, nonatomic) IBOutlet UILabel *forgotPassLabel;

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UIButton *resetPassButton;

- (IBAction)resetPassButtonPressed:(id)sender;

@end
