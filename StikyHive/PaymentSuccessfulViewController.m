//
//  PaymentSuccessfulViewController.m
//  StikyHive
//
//  Created by User on 27/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "PaymentSuccessfulViewController.h"

@interface PaymentSuccessfulViewController ()

@end

@implementation PaymentSuccessfulViewController

@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)backToCrossPollinate:(id)sender{
    
    if([_delegate respondsToSelector:@selector(onBackToCrossPollinateTap:)]){
        
        [_delegate onBackToCrossPollinateTap:self];
    }
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
