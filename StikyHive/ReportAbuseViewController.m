//
//  ReportAbuseViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 23/10/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "ReportAbuseViewController.h"
#import "LocalDataInterface.h"
#import <SendGrid/SendGrid.h>
#import <SendGrid/SendGridEmail.h>
#import "WebDataInterface.h"

@interface ReportAbuseViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation ReportAbuseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self displayContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)displayContent
{
    
    CGFloat x = 20;
    CGFloat y = 20;
    
    UIColor *greenColor = [UIColor colorWithRed:18.0/255 green:148.0/255 blue:133.0/255 alpha:1.0];
    
    self.view.backgroundColor = [UIColor colorWithRed:242.0/255 green:235.0/255 blue:184.0/255 alpha:1.0];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 150, 30)];
    titleLabel.text = @"Report Abuse";
    CGPoint center = titleLabel.center;
    center.x = self.view.center.x;
    titleLabel.center = center;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, titleLabel.frame.origin.y+titleLabel.frame.size.height +15, self.view.frame.size.width-40, 30)];
    
    NSString *name = [LocalDataInterface retrieveNameOfUser];
    messageLabel.text = [NSString stringWithFormat:@"Hi %@, What Happens?",name];
    
    
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(20, messageLabel.frame.origin.y+messageLabel.frame.size.height + 15, self.view.frame.size.width-40, 150)];
    
    
    
    
    UIButton *reportButton = [[UIButton alloc] initWithFrame:CGRectMake(20, _textView.frame.size.height+_textView.frame.origin.y+15, _textView.frame.size.width, 45)];
    [reportButton setTitle:@"Report" forState:UIControlStateNormal];
    [reportButton setBackgroundColor:greenColor];
    [reportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    reportButton.layer.borderColor = greenColor.CGColor;
    reportButton.layer.borderWidth = 1.5;
    reportButton.layer.cornerRadius = 5;
    reportButton.layer.masksToBounds = YES;
    [reportButton addTarget:self action:@selector(submitBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:titleLabel];
    [self.view addSubview:messageLabel];
    [self.view addSubview:_textView];
    [self.view addSubview:reportButton];
    
}


// touch anywhere to dismiss keyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];// this will do the trick
}


- (void)submitBtnTapped:(UITapGestureRecognizer *)sender
{
   
//    NSString *email = [LocalDataInterface retrieveUsername];
//    NSLog(@"name of user ---- %@",email);

    [self sendUserEmail];
    
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
    
}


- (void)sendUserEmail
{
    SendGrid *sendgrid = [SendGrid apiUser:SENDGRID_API_USER apiKey:SENDGRID_API_KEY];
    
    NSString *email = [LocalDataInterface retrieveUsername];
    NSString *name = [LocalDataInterface retrieveNameOfUser];
    NSString *text = _textView.text;
    
    SendGridEmail *gridEmail = [[SendGridEmail alloc] init];
    gridEmail.from = SENDGRID_EMAIL_ADDRESS;
    gridEmail.to = @"shweyihnin011@gmail.com";
    gridEmail.subject = @"Report Abuse";
    gridEmail.html = [NSString stringWithFormat:@"<body style='margin: 0px;width:600px;margin:0 auto; background-color: #f9f9f9;'><div style= 'padding-top: 40px; padding-bottom: 0px;'><div style='text-align: center; padding: 14px;'><img src='http://www.stikyhive.com/img/stikyhive_mail_logo.png' style='width:40&#37;'/></div><div style='background-image: url(http://www.stikyhive.com/img/background.png);padding-top:30px;'><h2 style='text-align: center; color: #f9f9f9; font-size: 22px; font-family: sans-serif; text-shadow: 0px 0px 19px #ddd;'>Hi Customer Service Department,</h2><div style='text-align: center; padding: 14px;'><img src='http://www.stikyhive.com/img/contactus-department.png' style='width:40&#37;'/></div><div style='text-align: center; padding: 14px;'><span style='text-align: center; font-size: 18px;color:#ead61c;marign-bottom:5px;margin-bottom:10px;'>%@ sent you a report abuse:<span></div><div style='text-align: center; padding: 14px;'><span style=' text-align:justify;font-size: 15px;color:#fff;padding:3px;'> %@ </span></div><div style='text-align: center; padding: 14px;'></div><center><span style=' text-align:justify;font-size: 15px;color:#fff;padding:3px;'>Respond to him/her via <br><a href='mailto:%@ target=_blank'>%@</a> </span></center><div style='text-align: center;padding-bottom:20px;padding-top:25px;'><a href='mailto:' . %@ . '' style='text-decoration: none;  color: #fff; background-color: #00B9B9;  border: none; border-radius: 3px; box-shadow: 0px 0px 10px #aaa; font-size: 18px; padding: 9px 60px 9px 60px;'>Respond</a></div></div></div><div style= 'padding-top: 30px; padding-bottom: 25px;'><div style='text-align: center; font-size: 18px; font-family: sans-serif; color: rgb(92, 92, 92);'><a style='display: inline; margin-left: 10px; margin-right: 10px;'>How it works</a> | <a style='display: inline; margin-left: 10px; margin-right: 10px;'>Start buying & selling</a> | <a style='display: inline; margin-left: 10px; margin-right: 10px;'>T&C</a></div><div style='font-family: sans-serif; font-size: 12px; font-weight: 600; padding-top: 26px;'><p style='text-align: center;'>You\'ve received this email as a registered user of StikyHive.</p><p style='text-align: center;   margin-top: -6px;'>If you did not sign up and would like to unsubscribe, please click <a>here</a>.</p></div></div><div style='background-color: #f9f9f9; padding: 16px;'><footer style='text-align: right;  font-size: 13px;'><p><center>View Online</center></p><p><center>&copy;' . date ( 'Y' ) . ' StikyHive Singapore Pte Ltd. All Rights Reserved.</center></p></footer></div></body>",name,text,email,email,email];
    
    gridEmail.text = @"Report Abuse";
    
    [sendgrid sendWithWeb:gridEmail];
}



@end
