//
//  PostBuyViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 18/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "PostBuyViewController.h"
#import "RadioButton.h"
#import "ViewControllerUtil.h"



@interface PostBuyViewController ()

@end

@implementation PostBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _contentScrollView.alwaysBounceVertical = YES;
    _contentScrollView.delegate = self;
    
    
    [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1200)];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    
}





- (IBAction)nextBtnPressed:(id)sender
{
    
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"buyer_photo_view_controller"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
