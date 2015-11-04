//
//  PhotoPickerViewController.h
//  StikyHive
//
//  Created by Koh Quee Boon on 20/6/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TextEditorViewController.h"


#define PHOTO_SOURCE_CAMERA 1
#define PHOTO_SOURCE_LIBRARY 2

@interface PhotoPickerViewController : TextEditorViewController

- (void)showImagePickerForImageView:(UIImageView *)imageView;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)presentPhotoLibraryImagePicker:(UIImagePickerControllerSourceType) sourceType;
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;

@end