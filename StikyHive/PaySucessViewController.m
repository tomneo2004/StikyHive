//
//  PaySucessViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 9/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "PaySucessViewController.h"
#import "ViewControllerUtil.h"
#import "SellingManager.h"

@interface PaySucessViewController ()

@end

@implementation PaySucessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Start Selling Successful";
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
}


- (IBAction)viewMySkillBtnPressed:(id)sender
{
//    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"my_profile_view_controller"];
////    [self.navigationController presentationController:vc animated:YES];
//    [self.navigationController presentViewController:vc animated:YES completion:nil];
    
//    self.tabBarController.selectedIndex = 3;
    
//    UITabBarController *tabc = [[UITabBarController alloc] init];
//    tabc.selectedViewController = [tabc.viewControllers objectAtIndex:3];
    
//    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    NSLog(@"root %@", [self.navigationController viewControllers]);
    
    [SellingManager sharedSellingManager].profileTap = YES;
    
    
//    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
