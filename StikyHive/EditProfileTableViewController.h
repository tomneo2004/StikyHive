//
//  EditProfileTableViewController.h
//  StikyHive
//
//  Created by User on 10/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheetPicker.h"
#import "DescEditorViewController.h"

@class EditProfileTableViewController;

@protocol EditProfileTableViewControllerDelegate <NSObject>

@optional
- (void)didTapAvatarImage:(UIImageView *)imageView;
- (void)beginPullingData:(EditProfileTableViewController *)controller;
- (void)PullingDataSuccessful:(EditProfileTableViewController *)controller;
- (void)PullingDataFail:(EditProfileTableViewController *)controller;
- (void)beginUpdateProfile:(EditProfileTableViewController *)controller;
- (void)updateProfileSuccessful:(EditProfileTableViewController *)controller;
- (void)updateProfileFail:(EditProfileTableViewController *)controller;

@end

@interface EditProfileTableViewController : UITableViewController<UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, DescEditorViewControllerDelegate>

@property (weak, nonatomic) UINavigationController *navigationController;
@property (weak, nonatomic) id<EditProfileTableViewControllerDelegate> delegate;

- (void)startPullingData;
@end
