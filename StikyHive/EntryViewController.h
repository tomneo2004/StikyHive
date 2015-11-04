//
//  EntryViewController.h
//  StikyHive
//
//  Created by Koh Quee Boon on 14/8/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextEditorViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <linkedin-sdk/LISDK.h>


@interface EntryViewController : TextEditorViewController

@property (strong, nonatomic) IBOutlet UILabel *sloganLabel;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *joinButton;
@property (strong, nonatomic) IBOutlet UIButton *fbButton;
@property (strong, nonatomic) IBOutlet UIButton *inButton;
@property (strong, nonatomic) IBOutlet UILabel *agreeLabel;
@property (strong, nonatomic) IBOutlet UILabel *termsLabel;
@property (strong, nonatomic) IBOutlet UIButton *checkBoxButton;
@property (strong, nonatomic) IBOutlet UIButton *bottomButton;
@property (strong, nonatomic) IBOutlet UIButton *bottomLoginButton;
@property (strong, nonatomic) IBOutlet UILabel *forgotPasswordLabel;

@property (assign, nonatomic) FBSDKDefaultAudience defaultAudience;

- (IBAction)loginPressed:(id)sender;
- (IBAction)joinPressed:(id)sender;
- (IBAction)checkBoxPressed:(id)sender;

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)signUpButtonPressed:(id)sender;

- (IBAction)fbLoginPressed:(id)sender;
- (IBAction)inLoginPressed:(id)sender;


@end
