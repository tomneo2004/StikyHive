//
//  ResetPassViewController.m
//  StikyHive
//
//  Created by Koh Quee Boon on 10/9/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "ResetPassViewController.h"
#import "ViewControllerUtil.h"

@interface ResetPassViewController ()

@end

@implementation ResetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.hidesBackButton = YES;
}



- (IBAction)backLoginButtonPressed:(id)sender {
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"entry_view_controller"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
