//
//  SellingViewController2.h
//  StikyHive
//
//  Created by THV1WP15S on 23/11/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define MAX_VIDEO_DURATION_DEFAULT 100//30



@interface SellingViewController2 : UIViewController <UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *uploadLabel;

@property (strong, nonatomic) IBOutlet UIImageView *videoImageView;

@property (strong, nonatomic) IBOutlet UILabel *recommLabel;



- (IBAction)nextButton:(id)sender;


+ (UIViewController *)instantiateForInfo:(NSDictionary *)skillInfo;


@end
