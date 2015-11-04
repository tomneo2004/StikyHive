//
//  PhotoViewController.m
//  StikyHive
//
//  Created by Koh Quee Boon on 2/6/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "PhotoViewController.h"
#import "ViewControllerUtil.h"

@interface PhotoViewController ()

@property (strong, nonatomic) UIColor *navigationBarColor;

@property (strong, nonatomic) UIImage *image;

@end

@implementation PhotoViewController

static NSString *Photo_Path;
static UIImage *Photo_Image;

+ (void)setPhotoPath:(NSString *) photoPath
{
    Photo_Path = photoPath;
    Photo_Image = nil;
}

+ (void)setImage:(UIImage *) image
{
    Photo_Image = image;
    Photo_Path = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _navigationBarColor = self.navigationController.navigationBar.barTintColor;
//    _navigationBarColor = [UIColor colorWithRed:63.0/255 green:46.0/255 blue:31.0/255 alpha:1.0];
    

    if (Photo_Path)
    {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:Photo_Path]];
        _image = [[UIImage alloc] initWithData:data];
        _image = _image ? _image : [UIImage imageNamed:@"Default_skill_photo@2x"];
        [self displayImage:_image];
    }
    else if (Photo_Image)
    {
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save to Photo Library"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self action:@selector(saveToPhotoAlbum)];
        self.navigationItem.rightBarButtonItems = @[saveButton];
        _image = Photo_Image;
        [self displayImage:Photo_Image];
    }
}

- (void)displayImage :(UIImage *)image
{
    CGRect originFrame = CGRectMake(0,0, image.size.width, image.size.height);
    CGRect windowFrame = self.view.frame;
    CGFloat scaleRatio = windowFrame.size.width/originFrame.size.width;
    CGRect scaledFrame = CGRectMake(0,0, image.size.width*scaleRatio, image.size.height*scaleRatio);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:scaledFrame];
    CGFloat navBarHeight = self.navigationController.navigationBar.bounds.size.height;
    imageView.center = CGPointMake(self.view.center.x, self.view.center.y - navBarHeight - 20);
    imageView.image = image;
    [self.view addSubview:imageView];
    
}

- (IBAction)saveToPhotoAlbum
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (_image)
        {
            UIImageWriteToSavedPhotosAlbum(_image, nil, nil, nil);
        }
    });
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Image Saved to Photo Library"
                                                   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _navigationBarColor = self.navigationController.navigationBar.barTintColor;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:63.0/255 green:46.0/255 blue:31.0/255 alpha:1.0];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = _navigationBarColor;
    self.tabBarController.tabBar.hidden = NO;
}

@end
