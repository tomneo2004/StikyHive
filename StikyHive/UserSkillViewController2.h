//
//  UserSkillViewController2.h
//  StikyHive
//
//  Created by Koh Quee Boon on 26/5/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define SKILL_VIDEO_SOURCE_CAMERA 1
#define SKILL_VIDEO_SOURCE_LIBRARY 2
#define MAX_VIDEO_DURATION_DEFAULT 100//30
#define MAX_VIDEO_DURATION_EXTENDED 90
#define VIDEO_THUMBNAIL_TIME_SEC 3
#define VIDEO_THUMBNAIL_WIDTH 298
#define VIDEO_THUMBNAIL_HEIGHT 166

// #define VIDEO_OUTPUT_QUALITY AVAssetExportPresetLowQuality
#define VIDEO_OUTPUT_QUALITY AVAssetExportPresetMediumQuality
// #define VIDEO_OUTPUT_QUALITY AVAssetExportPresetHighestQuality

@interface UserSkillViewController2 : UIViewController
<UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) MPMoviePlayerController *videoController;
@property (strong, nonatomic) IBOutlet UIImageView *skillVideoImageView;

- (IBAction)nextButtonPressed:(id)sender;

+ (UIViewController *) instantiateForInfo:(NSDictionary *)skillInfo;

@end
