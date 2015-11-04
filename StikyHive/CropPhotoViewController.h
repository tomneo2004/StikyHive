//
//  CropPhotoViewController.h
//  StikyHive
//
//  Created by Koh Quee Boon on 2/9/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "TextEditorViewController.h"
#import "TOCropViewController.h"

#define PHOTO_SOURCE_TYPE_CAMERA 1
#define PHOTO_SOURCE_TYPE_LIBRARY 2

@interface CropPhotoViewController : TextEditorViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, TOCropViewControllerDelegate>

- (void)showCropViewControllerWithOptions:(UIImageView *)imageView;

@end
