//
//  PromotionViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 3/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "PromotionViewController.h"
#import "ViewControllerUtil.h"
#import "SellingManager.h"
#import "PaySummaryViewController.h"

@interface PromotionViewController ()

@end

@implementation PromotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)wantBtnPressed:(id)sender
{
    
    [SellingManager sharedSellingManager].promotionStatus = YES;
    
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"pay_summary_view_controller"];
    PaySummaryViewController *sv = (PaySummaryViewController *)vc;
    sv.mySkillInfo = _mySkillInfo;
    [self.navigationController pushViewController:vc animated:YES];

     NSLog(@"promotion status --- %d",[SellingManager sharedSellingManager].promotionStatus);
    
}

- (IBAction)laterBtnPressed:(id)sender
{
    
    [SellingManager sharedSellingManager].promotionStatus = NO;
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"pay_summary_view_controller"];
    PaySummaryViewController *sv = (PaySummaryViewController *)vc;
    sv.mySkillInfo = _mySkillInfo;
    [self.navigationController pushViewController:vc animated:YES];
    
    NSLog(@"promotion status --- %d",[SellingManager sharedSellingManager].promotionStatus);

}
@end
