//
//  SellingViewController4.m
//  StikyHive
//
//  Created by THV1WP15S on 30/11/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "SellingViewController4.h"

@interface SellingViewController4 ()

@end

@implementation SellingViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _contentScrollView.alwaysBounceVertical = YES;
    _contentScrollView.delegate = self;
    
    [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width, 800)];
    
    
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
