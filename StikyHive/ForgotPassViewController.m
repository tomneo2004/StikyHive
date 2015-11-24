//
//  ForgotPassViewController.m
//  StikyHive
//
//  Created by Koh Quee Boon on 10/9/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "ForgotPassViewController.h"
#import <SendGrid/SendGrid.h>
#import <SendGrid/SendGridEmail.h>
#import "ViewControllerUtil.h"
#import "WebDataInterface.h"

@interface ForgotPassViewController ()

@end

@implementation ForgotPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        [self setTextFields:@[_emailTextField]];
        NSDictionary *animateDists = @{_emailTextField:[NSNumber numberWithInteger:-100]};
        [self setAnimateDistances:animateDists];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)resetPassButtonPressed:(id)sender {
    
    NSString *email = _emailTextField.text;
    
    [WebDataInterface forgotPassword:email completion:^(NSObject *obj, NSError *err)
     {
         
         [self dataReceived:(NSDictionary *)obj];
         
     }];
    
    
    
    _resetPassButton.userInteractionEnabled = NO;
    
    
}



- (void)dataReceived:(NSDictionary *)dict {
    
    _resetPassButton.userInteractionEnabled = YES;
    
    if (dict && dict[@"status"]) {
        NSLog(@"forgot pass status ----- %@",dict);
        
        NSString *statusString = dict[@"status"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([statusString isEqualToString:@"success"]) {
                
                NSString *hashCode = dict[@"hashcode"];
                NSString *name = dict[@"name"];
                
                [self sendResetPassEmail:hashCode name:name];
                
                UIViewController *vc = [ViewControllerUtil instantiateViewController:@"reset_pass_view_controller"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else {
                [ViewControllerUtil showAlertWithTitle:@"" andMessage:@"No email found"];
            }
        });
    }
}




- (void)sendResetPassEmail:(NSString *)hashCode name:(NSString *)name {
    
    // send varification email
    SendGrid *sendgrid = [SendGrid apiUser:SENDGRID_API_USER apiKey:SENDGRID_API_KEY];
    
    NSString *toEmail = _emailTextField.text;
    NSString *getHashCode = hashCode;
//    NSString *getName = name;
    
    SendGridEmail *email = [[SendGridEmail alloc] init];
    email.from = SENDGRID_EMAIL_ADDRESS;
    email.to = toEmail;
    email.subject = @"Reset Password";
    email.html = [NSString stringWithFormat:@"<body style='margin: 0px;width:600px;margin:0 auto; background-color: #f9f9f9;'><div style='padding-top: 40px; padding-bottom: 0px;'><div style='text-align: center; padding: 14px;'><img src='http://stikyhive.com/img/stikyhive_mail_logo.png' style='width:40&#37;'/></div><div style='background-image: url(http://stikyhive.com/img/background.png);padding-top:30px;'><div style='text-align: center; padding: 14px;'><span style='text-align: center; color: #fff; font-size: 20px; font-family: sans-serif; text-shadow: 0px 0px 19px #ddd;'>Hi %@!</span></div><div style='text-align: center; padding: 14px;'><img src='http://stikyhive.com/img/passwordreset.png' style='width:40&#37;'/></div><p style='text-align: center; font-size: 20px; margin-top: -3px; font-family: sans-serif; color: #fff;'>Kindly login with your new password:</p><p style='text-align: center; font-size: 17px; margin-top: -3px; font-family: sans-serif; color: #fff;'> '%@' </p></div></div><div style=' padding-top: 30px; padding-bottom: 25px;'><div style='text-align: center; font-size: 18px; font-family: sans-serif; color: rgb(92, 92, 92);'><a style='display: inline; margin-left: 10px; margin-right: 10px;'>How it works</a> | <a style='display: inline; margin-left: 10px; margin-right: 10px;'>Start buying & selling</a> | <a style='display: inline; margin-left: 10px; margin-right: 10px;'>T&C</a></div><div style='font-family: sans-serif; font-size: 12px; font-weight: 600; padding-top: 26px;'><p style='text-align: center;'>You've received this email as a registered user of StikyHive.</p><p style='text-align: center;   margin-top: -6px;'>If you did not sign up and would like to unsubscribe, please click <a>here</a>.</p></div></div><div style='background-color: #f9f9f9; padding: 16px;'><footer style='text-align: right;  font-size: 13px;'><p><center>View Online</center></p><p><center>&copy; 2015 StikyHive Singapore Pte Ltd. All Rights Reserved.</center></p></footer></div></body>",name,getHashCode];
    email.text = @"hello world";
    
    [sendgrid sendWithWeb:email];
}

@end
