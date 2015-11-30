//
//  TitleViewController.m
//  StikyHive
//
//  Created by User on 17/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "TitleViewController.h"

@interface TitleViewController ()

@end

@implementation TitleViewController

@synthesize viewControllerTitle = _viewControllerTitle;
@synthesize backButtonTitle  = _backButtonTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //deal with back button title
    if(_backButtonTitle.length > 0 && self.navigationController != nil){
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
        barButton.title = _backButtonTitle;
        self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    }
    
    
    //deal controller's title
    if(_viewControllerTitle.length > 0 && self.navigationController != nil){
        
        [self setTitle:_viewControllerTitle];
    }
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
