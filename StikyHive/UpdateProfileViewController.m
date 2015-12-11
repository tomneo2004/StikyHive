//
//  UpdateProfileViewController.m
//  StikyHive
//
//  Created by User on 10/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "UpdateProfileViewController.h"
#import "UIView+RNActivityView.h"

@interface UpdateProfileViewController ()


@end

@implementation UpdateProfileViewController{
    
    BOOL _shouldUpdate;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    EditProfileTableViewController *controller = [self.childViewControllers lastObject];
    
    controller.navigationController = self.navigationController;
    controller.delegate = self;
    
    _shouldUpdate = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.delegate =self;
    
    if(_shouldUpdate){
        
        EditProfileTableViewController *controller = [self.childViewControllers lastObject];
        [controller startPullingData];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    _shouldUpdate = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - EditProfileTableViewController delegate
- (void)didTapAvatarImage:(UIImageView *)imageView{
    
    [self showCropViewControllerWithOptions:imageView andType:1];
}

- (void)beginPullingData:(EditProfileTableViewController *)controller{
    
    [self.view showActivityViewWithLabel:@"Refreshing..." detailLabel:@"Fetching data"];
}

- (void)PullingDataSuccessful:(EditProfileTableViewController *)controller{
    
    [self.view hideActivityView];
}

- (void)PullingDataFail:(EditProfileTableViewController *)controller{
    
    [self.view hideActivityView];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to get data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)beginUpdateProfile:(EditProfileTableViewController *)controller{
    
    [self.view showActivityViewWithLabel:@"Updating profile..."];
}

- (void)updateProfileSuccessful:(EditProfileTableViewController *)controller{
    
    [self.view hideActivityView];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Successful" message:@"Update profile successful" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateProfileFail:(EditProfileTableViewController *)controller{
    
    [self.view hideActivityView];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Update profile Fail" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - UINavigationViewController delegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if([fromVC isKindOfClass:[DescEditorViewController class]])
        _shouldUpdate = NO;
    
    return nil;
}

#pragma mark - override
- (void)onImageCropSuccessfulWithImageView:(UIImageView *)imageView{
    
    _shouldUpdate = NO;
}

- (void)onCancel{
    
    _shouldUpdate = NO;
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
