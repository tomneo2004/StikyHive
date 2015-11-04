//
//  UserAgreementViewController.m
//  StikyHive
//
//  Created by Koh Quee Boon on 18/8/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "UserAgreementViewController.h"
#import "ViewControllerUtil.h"

@interface UserAgreementViewController ()

@end

@implementation UserAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
//    self.navigationItem.rightBarButtonItem = doneButton;
//
//    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
//                                   initWithTitle:@"Close"
//                                   style:UIBarButtonItemStylePlain
//                                   target:self
//                                   action:@selector(flipView:)];
//    self.navigationItem.rightBarButtonItem = flipButton;
//    self.navigationItem.leftBarButtonItem.title = @"back";
    
    
//   self.navigationController.navigationBar.topItem.title = @"Back";
    
    
    
    NSString *htmlFile = @"terms_and_conditions";
    UIFont *font = [UIFont fontWithName:@"OpenSans" size:14];
    NSString *fontFormat = @"<span style=\"font-family: %@; font-size: %i\">%@</span>";
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:htmlFile ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    htmlString = [NSString stringWithFormat:fontFormat, font.fontName, (int) font.pointSize, htmlString];
    
    CGSize viewSize = self.view.frame.size;
    CGFloat margin = viewSize.width/18;
    CGRect webFrame = CGRectMake(0, 0, viewSize.width, viewSize.height + margin *3);
    UIWebView *webView = [[UIWebView alloc] initWithFrame:webFrame];
    [webView loadHTMLString:htmlString baseURL:nil];
    [self.view addSubview:webView];
    
//    UIBarButtonItem *agreeButton = [[UIBarButtonItem alloc] initWithTitle:@"I Agree" style:UIBarButtonItemStylePlain
//                                                                   target:self action:@selector(agreePressed)];
    UIBarButtonItem *disagreeButton = [[UIBarButtonItem alloc] initWithTitle:@"  Back" style:UIBarButtonItemStylePlain
                                                                      target:self action:@selector(dismiss)];
//    self.navigationItem.rightBarButtonItems = @[agreeButton];
    self.navigationItem.leftBarButtonItems = @[disagreeButton];
    self.navigationItem.title = @"Terms & Conditions";
    
}



- (void)dismiss {
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//- (void)agreePressed
//{
//    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"signup_view_controller"];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//- (void)disagreePressed
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
