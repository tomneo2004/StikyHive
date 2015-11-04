//
//  UserSkillViewController2.m
//  StikyHive
//
//  Created by Koh Quee Boon on 26/5/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "UserSkillViewController2.h"
#import "UserSkillViewController3.h"
#import "ViewControllerUtil.h"
#import "LocalDataInterface.h"
#import "WebDataInterface.h"

@interface UserSkillViewController2 ()

@property (nonatomic, strong) NSData *videoData;

@end

@implementation UserSkillViewController2

static NSMutableDictionary *Skill_Info;

+ (UIViewController *) instantiateForInfo:(NSDictionary *)skillInfo
{
    Skill_Info = skillInfo.mutableCopy;
    return [ViewControllerUtil instantiateViewController:@"user_skill_view_controller_2"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [_skillVideoImageView setUserInteractionEnabled:YES];
    [_skillVideoImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(tappedVideoImage:)]];

     // Editing existing skill
    if (Skill_Info && Skill_Info[@"video"] && ((NSArray *)Skill_Info[@"video"]).count > 0)
    {
        NSString *thumbLoc = Skill_Info[@"video"][0][@"thumbnailLocation"];
        NSString *thumbPath = [WebDataInterface getFullStoragePath:thumbLoc];
        _skillVideoImageView.image = [ViewControllerUtil getImageForPath:thumbPath];
    }
    else // Creating new skill
    {
        NSData *videoThumbData = [LocalDataInterface retrieveVideoThumb1];
        if (videoThumbData)
        {
            _skillVideoImageView.image = [UIImage imageWithData:videoThumbData];
        }
    }
}

- (void)tappedVideoImage:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self showVideoPicker];
}

- (void)tappedVideoImage2:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self showVideoPicker];
}

- (void)showVideoPicker
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        picker.videoMaximumDuration = MAX_VIDEO_DURATION_DEFAULT;
    //    picker.videoQuality = UIImagePickerControllerQualityTypeIFrame960x540;
        picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        
        [self presentViewController:picker animated:YES completion:NULL];
        NSString *msg = @"Please record in landscape mode to ensure your video is not distorted.";
        [ViewControllerUtil showAlertWithTitle:@"" andMessage:msg];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (buttonIndex == SKILL_VIDEO_SOURCE_CAMERA)
//        [self presentPhotoLibraryImagePicker:UIImagePickerControllerSourceTypeCamera];
//    else if (buttonIndex == SKILL_VIDEO_SOURCE_LIBRARY)
//        [self presentPhotoLibraryImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.videoURL = info[UIImagePickerControllerMediaURL];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    self.videoController = [[MPMoviePlayerController alloc] init];
    [self.videoController setContentURL:self.videoURL];
    
/*
    [self.videoController.view setFrame:CGRectMake (40, 40, 160, 90)];
    [self.view addSubview:self.videoController.view];

 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoPlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.videoController];
    [self.videoController play];
*/

    if (self.videoController.contentURL)
    {
        NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.mov"];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        NSURL *tempUrl = [NSURL fileURLWithPath:filePath];
        [self convertVideoToLowQuailtyWithInputURL:self.videoController.contentURL outputURL:tempUrl
                                           handler:^(AVAssetExportSession *session)
        {
            NSData *reducedData = [NSData dataWithContentsOfURL:tempUrl];
            if (!Skill_Info)
                [LocalDataInterface storeVideo1:reducedData];
            else
                _videoData = reducedData;
            
            [self storeAndShowThumbnailFromVideoURL:tempUrl];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)videoPlayBackDidFinish:(NSNotification *)notification
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    // Stop the video player and remove it from view
    [self.videoController stop];
    [self.videoController.view removeFromSuperview];
    self.videoController = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)nextButtonPressed:(id)sender
{
    UIImage *img = _skillVideoImageView.image;
    UIViewController *vc = [UserSkillViewController3 instantiateForInfo:Skill_Info videoThumb:img andVideodata:_videoData];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL outputURL:(NSURL*)outputURL
                                     handler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]
                                           initWithAsset:asset presetName:VIDEO_OUTPUT_QUALITY];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.shouldOptimizeForNetworkUse = YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {handler(exportSession);}];
}

- (void)storeAndShowThumbnailFromVideoURL:(NSURL *)url
{
    CMTime thumbTime = CMTimeMakeWithSeconds(VIDEO_THUMBNAIL_TIME_SEC,VIDEO_THUMBNAIL_TIME_SEC);
    NSArray *array = [NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]];
    CGSize thumbSize = _skillVideoImageView.frame.size;

    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform=TRUE;
    generator.maximumSize = CGSizeMake(thumbSize.width, thumbSize.height);
    
    AVAssetImageGeneratorCompletionHandler handler =
    ^(CMTime requestedTime, CGImageRef img, CMTime actualTime,
      AVAssetImageGeneratorResult result, NSError *error)
    {
        if (result != AVAssetImageGeneratorSucceeded)
        {
            NSLog(@"couldn't generate thumbnail, error:%@", error);
        }
        else
        {
            CGSize thumbSize = CGSizeMake(VIDEO_THUMBNAIL_WIDTH, VIDEO_THUMBNAIL_HEIGHT);
            UIImage *image = [[UIImage alloc] initWithCGImage:img];
            image = [ViewControllerUtil imageWithImage:image scaledToSize:thumbSize];
            NSData *data = UIImageJPEGRepresentation (image,1.0);
            [LocalDataInterface storeVideoThumb1:data];
            dispatch_async(dispatch_get_main_queue(),^{
                _skillVideoImageView.image = nil;
                _skillVideoImageView.image = image;
            });
        }
    };
    [generator generateCGImagesAsynchronouslyForTimes:array completionHandler:handler];
}

@end
