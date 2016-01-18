//
//  EntryViewController.m
//  StikyHive
//
//  Created by Koh Quee Boon on 14/8/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "EntryViewController.h"
#import "ViewControllerUtil.h"
#import "LocalDataInterface.h"
#import "WebDataInterface.h"
#import <SendGrid/SendGrid.h>
#import <SendGrid/SendGridEmail.h>
#import <linkedin-sdk/LISDK.h>
#import "AppDelegate.h"
#import "UIView+RNActivityView.h"

@interface EntryViewController ()

@property (nonatomic, strong) NSString *socialMediaType;
@property (nonatomic, assign) NSInteger loginStatus;

@end

@implementation EntryViewController
//@synthesize emailTextField,passwordTextField;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"StikyHive"];
    
    _sloganLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:17];
    _sloganLabel.textAlignment = NSTextAlignmentCenter;
    [_sloganLabel setCenter:CGPointMake(self.view.center.x, self.sloganLabel.center.y)];
    
    _agreeLabel.hidden = YES;
    _termsLabel.hidden = YES;
    _checkBoxButton.hidden = YES;
    _bottomButton.hidden = YES;
    
    _loginButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:22];
    _joinButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:22];
    
    // prepare for check box
    [_checkBoxButton setImage:[UIImage imageNamed:@"uicheckbox_unchecked"] forState:UIControlStateNormal];
    [_checkBoxButton setImage:[UIImage imageNamed:@"uicheckbox_checked"] forState:UIControlStateSelected];
    
    
   //prepare for term_label
    _termsLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *termsTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(termsTapped)];
    [_termsLabel addGestureRecognizer:termsTapGesture];
    
    // add underline for termslabel
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"terms & conditions."];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    
    _termsLabel.attributedText = [attributeString copy];
    
    
    
   // set textfields animateDists
    [self setTextFields:@[_emailTextField,_passwordTextField]];
    NSDictionary *animateDists = @{_emailTextField:[NSNumber numberWithInteger:-100],
                                   _passwordTextField:[NSNumber numberWithInteger:-100]};
    [self setAnimateDistances:animateDists];
    
    //facebook
//    [self fetchUserInfo];
    
    // prepare for forgot password label
    _forgotPasswordLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *fogotPssGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgotPassTapped)];
    [_forgotPasswordLabel addGestureRecognizer:fogotPssGesture];
    
    
}



-(void)termsTapped
{
    
    
   /*
    
    UIAlertView *termsAlert = [[UIAlertView alloc] initWithTitle:@"Terms & Conditions" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    UIView *termView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 100, 300)];
    
    [termsAlert addSubview:termView];
    
    
    NSString *htmlFile = @"terms_and_conditions";
    UIFont *font = [UIFont fontWithName:@"OpenSans" size:14];
    NSString *fontFormat = @"<span style=\"font-family: %@; font-size: %i\">%@</span>";
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:htmlFile ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    htmlString = [NSString stringWithFormat:fontFormat, font.fontName, (int) font.pointSize, htmlString];
    
    CGSize viewSize = termView.frame.size;
    
    
    CGFloat margin = viewSize.width/18;
    CGRect webFrame = CGRectMake(margin, 0, viewSize.width - 2*margin, viewSize.height);
    
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 200, 400)];
    [webView loadHTMLString:htmlString baseURL:nil];
//    [self.view addSubview:webView];
//    [self.view addSubview:webView];
    
    
    
    
    [termView addSubview:webView];
    
    [termsAlert show];
    
*/    
    
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"user_agreement_view_controller"];
//    [self.navigationController pushViewController:vc animated:YES];
   
    [self showViewController:vc sender:self];
}

- (void)forgotPassTapped
{
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"forgot_pass_view_controller"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.hidesBackButton = YES;
}


- (IBAction)loginPressed:(id)sender
{
    _loginButton.backgroundColor = [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0];
    _joinButton.backgroundColor = [UIColor colorWithRed:231.0/255 green:229.0/255 blue:231.0/255 alpha:1.0];
    _agreeLabel.hidden = YES;
    _termsLabel.hidden = YES;
    _checkBoxButton.hidden = YES;
    _bottomButton.hidden = YES;
    _bottomLoginButton.hidden = NO;
}

- (IBAction)joinPressed:(id)sender
{
    _joinButton.backgroundColor = [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0];
    _loginButton.backgroundColor = [UIColor colorWithRed:231.0/255 green:229.0/255 blue:231.0/255 alpha:1.0];
    _agreeLabel.hidden = NO;
    _termsLabel.hidden = NO;
    _checkBoxButton.hidden = NO;
    _bottomButton.hidden = NO;
    _bottomLoginButton.hidden = YES;
  
    if (_checkBoxButton.state == _checkBoxButton.selected) {
        _bottomButton.backgroundColor = [UIColor lightGrayColor];
        _bottomButton.enabled = NO;
    }
}

- (IBAction)checkBoxPressed:(id)sender
{
    _checkBoxButton.selected = !_checkBoxButton.selected;
    
    if (_checkBoxButton.state == !_checkBoxButton.selected) {
        _bottomButton.enabled = NO;
        _bottomButton.backgroundColor = [UIColor lightGrayColor];
    }
    else {
        _bottomButton.enabled = YES;
        _bottomButton.backgroundColor = [UIColor colorWithRed:19.0/255 green:152.0/255 blue:139.0/255 alpha:1.0];
    }
    
    
}


- (IBAction)loginButtonPressed:(id)sender
{
    NSString *emailText = _emailTextField.text;
    NSString *passwordText = _passwordTextField.text;
    
    [self.view showActivityViewWithLabel:@"Login..."];
    
    [WebDataInterface loginWithEmail:emailText password:passwordText completion:^(NSObject *obj, NSError *err)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             
             [self dataReceivedLogin:(NSDictionary *)obj];
             
             [self.view hideActivityView];
         });
         
     }];
    
    _bottomLoginButton.userInteractionEnabled = NO;
}

- (void)dataReceivedLogin:(NSDictionary *)dict
{
    
    _bottomLoginButton.userInteractionEnabled = YES;
    
    NSLog(@"dict --- %@",dict);
    NSLog(@"email --- %@",_emailTextField.text);
    NSLog(@"pass --- %@",_passwordTextField.text);
    
    
    
    if (dict && dict[@"status"])
    {
        NSString *statusString = dict[@"status"];
        
        NSLog(@"login statuys --- %@", statusString);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([statusString isEqualToString:@"success"])
            {
                
                NSLog(@"login with email  ---------- %@", dict);
                
                /// TRY ---- store username and password to local data interface
                [LocalDataInterface storeUsername:_emailTextField.text];
                [LocalDataInterface storePassword:_passwordTextField.text];
                [LocalDataInterface storeStkid:dict[@"stikybee"][@"stkid"]];
                
                NSString *name = [NSString stringWithFormat:@"%@ %@",dict[@"stikybee"][@"firstname"],dict[@"stikybee"][@"lastname"]];
                
                [LocalDataInterface storeNameOfUser:name];
                
                
                // start GCM service ------------- //
                [(AppDelegate *)[UIApplication sharedApplication].delegate startGCMService];
                
                
                
                NSDictionary *stikybee = dict[@"stikybee"];
                NSString *statusStri = stikybee[@"status"];
//                NSInteger statusInt = [statusStri integerValue];
                _loginStatus = [statusStri integerValue];
                
                [self checkStatus:_loginStatus];
                
                
            }
            else
            {
                [ViewControllerUtil showAlertWithTitle:@"Error" andMessage:@"password or email error"];
            }
        });
    }
    else
    {
        [ViewControllerUtil showAlertWithTitle:@"Error" andMessage:@"please check network"];
    }
}


- (void)checkStatus:(NSInteger)status
{
    
    if (_loginStatus == 0) {
        UIViewController *vc = [ViewControllerUtil instantiateViewController:@"user_verification_view_controller"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (_loginStatus == 1)
    {
        UIViewController *vc = [ViewControllerUtil instantiateViewController:@"user_info_editor_view_controller_1"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (_loginStatus == 2 || _loginStatus == 12 || _loginStatus == 14)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (_loginStatus == 11 || _loginStatus == 13)
    {
        UIViewController *vc = [ViewControllerUtil instantiateViewController:@"user_info_editor_view_controller2"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (_loginStatus == 20)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

    
}



- (void)dataReceived:(NSDictionary *)dict
{
    
    _bottomButton.userInteractionEnabled = YES;
    
    [_joinButton setEnabled:YES];
    
    if (dict && dict[@"status"])
    {
        
        NSString *statusString = dict[@"status"];
        
//        [LocalDataInterface storeUsername:_emailTextField.text];
//        [LocalDataInterface storePassword:_passwordTextField.text];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([statusString isEqualToString:@"success"])
            {
                
                [LocalDataInterface storeUsername:_emailTextField.text];
                [LocalDataInterface storePassword:_passwordTextField.text];
                
                NSString *hashCode = dict[@"hashcode"];
                
                // send hashcode email
                [self sendHashCodeEmail:hashCode];
                
                UIViewController *vc = [ViewControllerUtil instantiateViewController:@"user_verification_view_controller"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else if ([statusString isEqualToString:@"exist"])
            {
                [ViewControllerUtil showAlertWithTitle:@"Email exist" andMessage:@"change another email"];
            }
            else
            {
                [ViewControllerUtil showAlertWithTitle:@"fail" andMessage:@"fail sign up"];
            }
        });
    }
    else
    {
        [ViewControllerUtil showAlertWithTitle:@"Error" andMessage:@"Please check network"];
    }
}


- (void)sendHashCodeEmail:(NSString *)hashCode
{
    
    // send varification email
    SendGrid *sendgrid = [SendGrid apiUser:@"StikyHive" apiKey:@"stikybee1234567"];
    
    NSString *toEmail = _emailTextField.text;
    NSString *getHashCode = hashCode;
    
    SendGridEmail *email = [[SendGridEmail alloc] init];
    email.from = @"stikybee@gmail.com";
    email.to = toEmail;
    email.subject = @"HASH CODE";
    email.html = [NSString stringWithFormat:@"<body style='margin: 0px;width:600px;margin:0 auto; background-color: #f9f9f9;'><div style=' padding-top: 40px; padding-bottom: 0px;'><div style='text-align: center; padding: 14px;'><img src='http://stikyhive.com/img/stikyhive_mail_logo.png' style='width:40&#37;'/></div><div style='background-image: url(http://stikyhive.com/img/background.png);padding-top:30px;'><div style='text-align: center; padding: 14px;'><img src='http://stikyhive.com/img/welcome-bee.png' style='width:40&#37;'/></div><p style='text-align: center; font-size: 21px; margin-top: 10px; font-family: sans-serif; color: #fff;'>Thank you for signing up.<br>To get started, kindly verify your email address.</p></br><div style='text-align: center;padding-top:20px;padding-bottom:30px;'><p style='text-align: center; font-size: 21px; margin-top: 10px; font-family: sans-serif; color: #fff;'>Your verification code is<br>'%@'</p></br></div></div></div><div style=' padding-top: 30px; padding-bottom: 25px;'><div style='text-align: center; font-size: 18px; font-family: sans-serif; color: rgb(92, 92, 92);'><a style='display: inline; margin-left: 10px; margin-right: 10px;'>How it works</a> | <a style='display: inline; margin-left: 10px; margin-right: 10px;'>Start buying & selling</a> | <a style='display: inline; margin-left: 10px; margin-right:10px;'>T&C</a></div><div style='font-family: sans-serif; font-size: 12px; font-weight: 600; padding-top: 26px;'><p style='text-align: center;'>You've received this email as a registered user of StikyHive.</p><p style='text-align: center;   margin-top: -6px;'>If you did not sign up and would like to unsubscribe, please click<a>here</a>.</p></div></div><div style='background-color: #f9f9f9; padding: 16px;'><footer style='text-align: right;  font-size: 13px;'><p><center>View Online</center></p><p><center>&copy;'2015' StikyHive Singapore Pte Ltd. All Rights Reserved.</center></p></footer></div></body>",getHashCode];
    email.text = @"hello world";
    
    [sendgrid sendWithWeb:email];
}


- (IBAction)signUpButtonPressed:(id)sender
{
    
    [_joinButton setEnabled:NO];
    
//    NSString *deviceToken = [LocalDataInterface retrieveDeviceToken];
    NSString *username = _emailTextField.text;
    NSString *password = _passwordTextField.text;
    
    // check if email is valid
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([emailTest evaluateWithObject:username] == NO) {
        [ViewControllerUtil showAlertWithTitle:@"Error" andMessage:@"Please Enter Valid Email Address."];
        return;
    }
    
    // check password
    if (password.length < 6 || password.length > 50) {
        [ViewControllerUtil showAlertWithTitle:@"Error" andMessage:@"Please Enter Valid Password."];
        return;
    }
    
    // request server data
    [self.view showActivityViewWithLabel:@"Loading..."];
    [WebDataInterface signupWithUsername:username password:password completion:^(NSObject *obj,NSError *err)
     {
         [self dataReceived:(NSDictionary *)obj];
         
         [self.view hideActivityView];
     }];
    
    _bottomButton.userInteractionEnabled = NO;
}

-(void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, picture.type(large), email, birthday, bio"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSLog(@"resultis:%@",result);
                 
                 
                 NSString *email = result[@"email"];
                 NSLog(@"email address ----- %@",email);
                 NSString *name = result[@"name"];
                 NSLog(@"name ------ %@",name);
                 
                 NSString *profilePicture = result[@"picture"][@"data"][@"url"];
                 NSLog(@"picture url ---- %@",profilePicture);
                 
                 NSLog(@"type ---- %@",_socialMediaType);
                 
                 
                 [WebDataInterface loginWithFB:email name:name profilePicture:profilePicture type:_socialMediaType completion:^(NSObject *obj, NSError *err)
                  {
                      [self dataReceivedFBLogin:(NSDictionary *)obj];
                  }];
                
             }
             else
             {
                 NSLog(@"Error %@",error);
             }
         }];
        
    }
    
}

- (void)dataReceivedFBLogin:(NSDictionary *)dict
{
    
    if (dict && dict[@"status"])
    {
        
        NSString *statusString = dict[@"status"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([statusString isEqualToString:@"success"])
            {
                NSLog( @"result ---- 00000 %@",dict);
                
                
                NSDictionary *stikybee = dict[@"stikybee"];
                NSString *statusStri = stikybee[@"status"];
                //                NSInteger statusInt = [statusStri integerValue];
                _loginStatus = [statusStri integerValue];
                
                [self checkStatus:_loginStatus];
  
                
            }
            
        });
        
    }
    
}


- (IBAction)fbLoginPressed:(id)sender
{
    _socialMediaType = @"facebook";
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in oooo");
             
             
             if ([result.grantedPermissions containsObject:@"email"])
             {
                 NSLog(@"result is----:%@",result);
                 [self fetchUserInfo];
             }
             
         }
     }];

}

- (IBAction)inLoginPressed:(id)sender
{
    
//    NSLog(@"%s","sync pressed2");
//    [LISDKSessionManager createSessionWithAuth:[NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION, nil]
//                                         state:@"some state"
//                        showGoToAppStoreDialog:YES
//                                  successBlock:^(NSString *returnState) {
//                                      
//                                      NSLog(@"%s","success called!");
//                                      LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
//                                      NSLog(@"value=%@ isvalid=%@",[session value],[session isValid] ? @"YES" : @"NO");
//                                      NSMutableString *text = [[NSMutableString alloc] initWithString:[session.accessToken description]];
//                                      [text appendString:[NSString stringWithFormat:@",state=\"%@\"",returnState]];
//                                      NSLog(@"Response label text %@",text);
////                                      _responseLabel.text = text;
////                                      self.lastError = nil;
////                                      // retain cycle here?
////                                      [self updateControlsWithResponseLabel:NO];
//                                      
//                                  }
//                                    errorBlock:^(NSError *error) {
//                                        NSLog(@"%s %@","error called! ", [error description]);
////                                        self.lastError = error;
////                                        //  _responseLabel.text = [error description];
////                                        [self updateControlsWithResponseLabel:YES];
//                                    }
//     ];
//    NSLog(@"%s","sync pressed3");
    
    
    
//    NSArray *permissions = [NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION, nil];
//    [LISDKSessionManager createSessionWithAuth:permissions
//                                         state:[NSString stringWithFormat:@"fgrgr"]
//                        showGoToAppStoreDialog:YES
//                                  successBlock:^(NSString *returnState) {
//                                      NSLog(@"returned state --------- %@",returnState);
//                                  }
//                                    errorBlock:^(NSError *error) {
//                                        NSLog(@"%s %@","error called!--------  ", [error description]);
//                                    }
//     ];

    
    
    
    
    NSArray *permissions = [NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION, nil];
    [LISDKSessionManager createSessionWithAuth:permissions
                                         state:nil
                        showGoToAppStoreDialog:YES
                                  successBlock:^(NSString *returnState) {
                                      NSLog(@"returned state ----- %@",returnState);
                                      
                                      LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
                                           
                                      
                                      [self fetchLiUserProfile];
                                  }
                                    errorBlock:^(NSError *error) {
                                        NSLog(@"%s %@","error called! ", [error description]);
                                    }
     ];
    
    
    
    
//     NSURL *urll = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,email-address,formatted-name,phonetic-last-name,location:(country:(code)),industry,distance,current-status,current-share,network,skills,phone-numbers,date-of-birth,main-address,positions:(title),educations:(school-name,field-of-study,start-date,end-date,degree,activities))"];
    
}




- (void)fetchLiUserProfile
{
    
//    NSString *url = @"https://api.linkedin.com/uas/oauth/requestToken?scope=r_basicprofile+r_emailaddress";
    
    //NSString *url = @"http://api.linkedin.com/v1/people/~:(id,first-name,last-name,picture-url,email-address)";
    
    NSString *url = @"http://api.linkedin.com/v1/people/~";
    
    NSLog(@"testing ----- %@",url);
    
    if ([LISDKSessionManager hasValidSession]) {
        [[LISDKAPIHelper sharedInstance] getRequest:url
                                            success:^(LISDKAPIResponse *response) {
                                                // do something with response
                                                
                                                NSLog(@"response ----- %@",response);
                                            }
                                              error:^(LISDKAPIError *apiError) {
                                                  // do something with error
                                                  
                                                  NSLog(@"responseError ---- %@",apiError);
                                                  
                                              }];
    }
    
    
    
    
    
//    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~:(id,first-name,last-name,industry,picture-url,location:(name),positions:(company:(name),title),specialties,date-of-birth,interests,languages)"];
//    
//    OAMutableURLRequest *request =
//    [[OAMutableURLRequest alloc] initWithURL:url
//                                    consumer:oAuthLoginView.consumer
//                                       token:oAuthLoginView.accessToken
//                                    callback:nil
//                           signatureProvider:nil];
//    
//    NSLog(@"the request is %@",request);
//    
//    
//    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
//    
//    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
//    [fetcher fetchDataWithRequest:request
//                         delegate:self
//                didFinishSelector:@selector(profileApiCallResult:didFinish:)
//                  didFailSelector:@selector(profileApiCallResult:didFail:)];
//   
    
    
}


//- (void)profileApiCall
//{
//    
//    // NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~"];
//    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~:(id,first-name,last-name,industry,picture-url,location:(name),positions:(company:(name),title),specialties,date-of-birth,interests,languages)"];
//    
//    NSMutableURLRequest *request =
//    [[OAMutableURLRequest alloc] initWithURL:url
//                                    consumer:oAuthLoginView.consumer
//                                       token:oAuthLoginView.accessToken
//                                    callback:nil
//                           signatureProvider:nil];
//    
//    NSLog(@"the request is %@",request);
//    
//    
//    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
//    
//    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
//    [fetcher fetchDataWithRequest:request
//                         delegate:self
//                didFinishSelector:@selector(profileApiCallResult:didFinish:)
//                  didFailSelector:@selector(profileApiCallResult:didFail:)];
//    
//    
//}


@end
