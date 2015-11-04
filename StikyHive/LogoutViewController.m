//
//  LogoutViewController.m
//  StikyHive
//
//  Created by Koh Quee Boon on 31/8/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "LogoutViewController.h"
#import "LocalDataInterface.h"

@interface LogoutViewController ()

@end

@implementation LogoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Logout"];
}

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

- (IBAction)yesButtonPressed:(id)sender {
    [LocalDataInterface removeAllKeys];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)noButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
