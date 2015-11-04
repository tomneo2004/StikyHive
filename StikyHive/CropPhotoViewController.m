//
//  CropPhotoViewController.m
//  StikyHive
//
//  Created by Koh Quee Boon on 2/9/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "CropPhotoViewController.h"
#import "ViewControllerUtil.h"

@interface CropPhotoViewController ()

@property (nonatomic, strong) UIImageView *imageViewProfile;
@property (nonatomic, strong) UIImage *image;

@end

@implementation CropPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)displayImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    imagePicker.sourceType = sourceType;
    imagePicker.allowsEditing = YES;
    
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == PHOTO_SOURCE_TYPE_CAMERA)
    {
        [self showCropViewController:UIImagePickerControllerSourceTypeCamera];
        //        NSString *msg = @"Please take your photo in landscape mode to ensure highest quality photo.";
        //        [ViewControllerUtil showAlertWithTitle:@"" andMessage:msg];
    }
    else if (buttonIndex == PHOTO_SOURCE_TYPE_LIBRARY)
    {
        [self showCropViewController:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

- (void)showCropViewControllerWithOptions:(UIImageView *)imageView;
{
    _imageViewProfile = imageView;
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        //        [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Existing", nil] showFromBarButtonItem:sender animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Select Photo Souce"
                                                       delegate:self cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Camera",@"Photo Library", nil];
        [alert show];
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        [self showCropViewController:UIImagePickerControllerSourceTypeCamera];
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        [self showCropViewController:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)showCropViewController:(UIImagePickerControllerSourceType) sourceType
{
    UIImagePickerController *photoPickerController = [[UIImagePickerController alloc] init];
    photoPickerController.sourceType = sourceType;
    photoPickerController.allowsEditing = NO;
    photoPickerController.delegate = self;
    [self presentViewController:photoPickerController animated:YES completion:nil];
}

//- (void)showCropViewController
//{
//    UIImagePickerController *photoPickerController = [[UIImagePickerController alloc] init];
//    photoPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    photoPickerController.allowsEditing = NO;
//    photoPickerController.delegate = self;
//    [self presentViewController:photoPickerController animated:YES completion:nil];
//}

#pragma mark - Cropper Delegate -
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    self.imageViewProfile.image = image;
    [self layoutImageView];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    CGRect viewFrame = [self.view convertRect:self.imageViewProfile.frame toView:self.navigationController.view];
    self.imageViewProfile.hidden = YES;
    [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:image toFrame:viewFrame completion:^{
        self.imageViewProfile.hidden = NO;
    }];
}

- (void)layoutImageView
{
    if (self.imageViewProfile.image == nil)
        return;
    
    CGFloat padding = 20.0f;
    
    CGRect viewFrame = self.view.frame;
    viewFrame.size.width -= (padding * 2.0f);
    viewFrame.size.height -= ((padding * 2.0f));
    
    CGRect imageFrame = CGRectZero;
    imageFrame.size = self.imageViewProfile.image.size;
    
    CGFloat scale = MIN(viewFrame.size.width / imageFrame.size.width, viewFrame.size.height / imageFrame.size.height);
    imageFrame.size.width *= scale;
    imageFrame.size.height *= scale;
    imageFrame.origin.x = (CGRectGetWidth(self.view.bounds) - imageFrame.size.width) * 0.5f;
    imageFrame.origin.y = (CGRectGetHeight(self.view.bounds) - imageFrame.size.height) * 0.5f;
    self.imageViewProfile.frame = imageFrame;
    
}

#pragma mark - Image Picker Delegate -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.image = image;
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:image];
        cropController.delegate = self;
        [self presentViewController:cropController animated:YES completion:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
