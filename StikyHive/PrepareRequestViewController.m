//
//  PrepareRequestViewController.m
//  StikyHive
//
//  Created by User on 25/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "PrepareRequestViewController.h"

@interface PrepareRequestViewController ()

@end

@implementation PrepareRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PrepareRequestTableViewController *controller = [self.childViewControllers lastObject];
    controller.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PrepareRequestDelegate
- (void)onTitleDoneEdit:(NSString *)title{
    
    NSLog(@"title:%@", title);
}

- (void)onDescriptionChange:(NSString *)description{
    
    NSLog(@"desc:%@", description);
}

- (void)onAttachementTapWithImageView:(UIImageView *)imageView{
    
    [self showCropViewControllerWithOptions:imageView andType:PHOTO_SOURCE_TYPE_CAMERA];
}

- (void)onPostRequestButtonTap{
    
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
