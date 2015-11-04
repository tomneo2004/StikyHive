//
//  BuyerPageViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 21/9/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "BuyerPageViewController.h"
#import "ViewControllerUtil.h"

@interface BuyerPageViewController ()

@end

@implementation BuyerPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"Buyer Post"];
    
    UIBarButtonItem *chatButton = [ViewControllerUtil createBarButton:@"button_chat_header" onTarget:self withSelector:@selector(chatPressed)];
    UIBarButtonItem *callButton = [ViewControllerUtil createBarButton:@"button_call_header" onTarget:self withSelector:@selector(callPressed)];
    
    chatButton.imageInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    callButton.imageInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    self.navigationItem.rightBarButtonItems = @[callButton, chatButton];
    
    CGFloat width = self.view.frame.size.width - 40;
    
    
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

@end
