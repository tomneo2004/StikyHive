//
//  UpdateProfileViewController.h
//  StikyHive
//
//  Created by User on 10/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditProfileTableViewController.h"
#import "CropPhotoViewController.h"

@interface UpdateProfileViewController : CropPhotoViewController<EditProfileTableViewControllerDelegate, UINavigationControllerDelegate>

@end
