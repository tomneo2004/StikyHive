//
//  SellingViewController33.h
//  StikyHive
//
//  Created by THV1WP15S on 27/11/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "CropPhotoViewController.h"

@interface SellingViewController33 : CropPhotoViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *contentViewController;

@property (strong, nonatomic) IBOutlet UIImageView *imageView1;

@property (strong, nonatomic) IBOutlet UIImageView *imageView2;

@property (strong, nonatomic) IBOutlet UIImageView *imageView3;

@property (strong, nonatomic) IBOutlet UIImageView *imageView4;

@property (strong, nonatomic) IBOutlet UITextField *textField1;

@property (strong, nonatomic) IBOutlet UITextField *textField2;

@property (strong, nonatomic) IBOutlet UITextField *textField3;

@property (strong, nonatomic) IBOutlet UITextField *textField4;



- (IBAction)nextButtonPressed:(id)sender;

+ (UIViewController *)instantiateForInfo:(NSDictionary *)skillInfo
                              videoThumb:(UIImage *)thumbImage
                            andVideodata:(NSData *)videoData;


@end
