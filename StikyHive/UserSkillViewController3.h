//
//  UserSkillViewController3.h
//  StikyHive
//
//  Created by Koh Quee Boon on 26/5/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoPickerViewController.h"

//#define SKILL_PHOTO_SOURCE_CAMERA 1
//#define SKILL_PHOTO_SOURCE_LIBRARY 2

@interface UserSkillViewController3 : PhotoPickerViewController
//<UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *skillPhotoImageView1;
@property (strong, nonatomic) IBOutlet UIImageView *skillPhotoImageView2;
@property (strong, nonatomic) IBOutlet UIImageView *skillPhotoImageView3;
@property (strong, nonatomic) IBOutlet UIImageView *skillPhotoImageView4;

- (IBAction)updateButtonPressed:(id)sender;

+ (UIViewController *) instantiateForInfo:(NSDictionary *)skillInfo
                               videoThumb:(UIImage *)thumbImage
                             andVideodata:(NSData *)videoData;

@end
