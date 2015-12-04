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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)wantBtnPressed:(id)sender
{
    
    [SellingManager sharedSellingManager].promotionStatus = YES;
    
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"pay_summary_view_controller"];
    [self.navigationController pushViewController:vc animated:YES];

    
    
}

- (IBAction)laterBtnPressed:(id)sender
{
    
    [SellingManager sharedSellingManager].promotionStatus = NO;
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"pay_summary_view_controller"];
    [self.navigationController pushViewController:vc animated:YES];

}
@end
