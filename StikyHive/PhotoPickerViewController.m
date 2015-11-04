//
//  PhotoSelectionViewController.m
//  StikyHive
//
//  Created by Koh Quee Boon on 10/6/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "PhotoPickerViewController.h"
#import "ViewControllerUtil.h"
#import "GKImagePicker.h"



@interface PhotoPickerViewController ()
<GKImagePickerDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *captureImageView;
@property (nonatomic, strong) GKImagePicker *imagePicker;

@end

@implementation PhotoPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showImagePickerForImageView:(UIImageView *)imageView;
{
    _captureImageView = imageView;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Select Photo Source"
                                                       delegate:self cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Camera", @"Photo Library", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == PHOTO_SOURCE_CAMERA)
    {
        [self presentPhotoLibraryImagePicker:UIImagePickerControllerSourceTypeCamera];
        NSString *msg = @"Please take your photo in landscape mode to ensure highest quality photo.";
        [ViewControllerUtil showAlertWithTitle:@"" andMessage:msg];
    }
    else if (buttonIndex == PHOTO_SOURCE_LIBRARY)
    {
        [self presentPhotoLibraryImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
}


- (void)presentPhotoLibraryImagePicker:(UIImagePickerControllerSourceType) sourceType
{
    CGFloat aspectRatio = _captureImageView.bounds.size.width/_captureImageView.bounds.size.height;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGSize cropSize = CGSizeMake(screenSize.width, screenSize.width/aspectRatio);
    self.imagePicker = [[GKImagePicker alloc] init];
    self.imagePicker.cropSize = cropSize;
    self.imagePicker.imagePickerController.sourceType = sourceType;
    self.imagePicker.delegate = self;
    self.imagePicker.captureImageView = _captureImageView;
    [self presentViewController:self.imagePicker.imagePickerController animated:YES completion:nil];
}

# pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image
{
    if (image)
    {
        CGSize imageSize = _captureImageView.frame.size;
        _captureImageView.image = [ViewControllerUtil imageWithImage:image scaledToSize:imageSize];
    }
    [self hideImagePicker];
}

- (void)hideImagePicker
{
    [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark -
# pragma mark UIImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image)
    {
        CGSize imageSize = _captureImageView.frame.size;
        _captureImageView.image = [ViewControllerUtil imageWithImage:image scaledToSize:imageSize];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
