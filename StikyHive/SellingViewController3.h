//
//  SellingViewController3.h
//  StikyHive
//
//  Created by THV1WP15S on 24/11/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "CropPhotoViewController.h"

@interface SellingViewController3 : CropPhotoViewController <UIScrollViewDelegate>


@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;


+ (UIViewController *)instantiateForInfo:(NSDictionary *)skillInfo
                              videoThumb:(UIImage *)thumbImage
                            andVideodata:(NSData *)videoData;



@end
