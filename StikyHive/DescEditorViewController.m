//
//  DescEditorViewController.m
//  StikyHive
//
//  Created by User on 11/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "DescEditorViewController.h"

@interface DescEditorViewController ()

@end

@implementation DescEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)cancel:(id)sender{
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
    
        
    }];
}

- (IBAction)done:(id)sender{
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
        
    }];
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
