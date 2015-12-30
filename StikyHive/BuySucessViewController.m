//
//  BuySucessViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 30/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "BuySucessViewController.h"

@interface BuySucessViewController ()

@end

@implementation BuySucessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)viewBtnPressed:(id)sender
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
