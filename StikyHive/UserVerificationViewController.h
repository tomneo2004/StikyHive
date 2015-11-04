//
//  UserVerificationViewController.h
//  StikyHive
//
//  Created by Koh Quee Boon on 20/8/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "TextEditorViewController.h"

@interface UserVerificationViewController : TextEditorViewController

@property (strong, nonatomic) IBOutlet UITextField *confirmCodeTextfield;

- (IBAction)confirmButtonPressed:(id)sender;

@end
