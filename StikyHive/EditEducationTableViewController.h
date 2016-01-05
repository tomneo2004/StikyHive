//
//  EditEducationTableViewController.h
//  StikyHive
//
//  Created by User on 5/1/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EducationInfo.h"
#import "ActionSheetPicker.h"
#import "OtherInfoViewController.h"

@protocol EditDeucationDelegate <NSObject>

@optional
- (void)onUpdateEducationSuccessful;
- (void)onAddNewEducationSuccessful;

@end

@interface EditEducationTableViewController : UITableViewController<UITextFieldDelegate, OtherInfoViewControllerDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate>

/**
 * If set controller become edit and update education mode
 * otherwise it create new empty education
 */
@property (weak, nonatomic) EducationInfo *eduInfo;

@property (weak, nonatomic) id<EditDeucationDelegate> delegate;

@end
