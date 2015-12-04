//
//  PaySummaryViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 4/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "PaySummaryViewController.h"

@interface PaySummaryViewController ()

@end

@implementation PaySummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _contentScrollView.alwaysBounceVertical = YES;
    _contentScrollView.delegate = self;
    [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1000)];
    
    
    
    
    _basicLabel.layer.borderWidth = 2;
    _basicLabel.layer.borderColor = [UIColor colorWithRed:0/255 green:139.0/255 blue:123.0/255 alpha:1.0].CGColor;
    
    
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
