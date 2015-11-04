//
//  SkillVideoPlayer.m
//  StikyHive
//
//  Created by Koh Quee Boon on 6/6/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "SkillVideoPlayer.h"

@implementation SkillVideoPlayer

- (void)startPlayingVideo:(NSString *)videoPath onView:(UIView *)view
{
    NSLog(@"%@", videoPath);
    
    NSURL *url = [NSURL URLWithString:videoPath];
    
    if (self.moviePlayer != nil)
        [self stopPlayingVideo:nil];
    
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];

    if (self.moviePlayer != nil)
    {
        NSNotificationCenter *nCenter = [NSNotificationCenter defaultCenter];
        NSString *nString = MPMoviePlayerPlaybackDidFinishNotification;
        SEL sel = @selector(videoHasFinishedPlaying:);
        [nCenter addObserver:self selector:sel name:nString object:self.moviePlayer];
        
        self.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
        [view addSubview:self.moviePlayer.view];
        [self.moviePlayer setFullscreen:YES animated:NO];
        [self.moviePlayer play];
    }
    else
    {
        NSLog(@"Failed to instantiate the movie player.");
    }
}

- (void)videoHasFinishedPlaying:(NSNotification *)paramNotification
{
    NSNumber *reason = paramNotification.userInfo [MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    if (reason != nil)
    {
        NSInteger reasonAsInteger = [reason integerValue];
        switch (reasonAsInteger)
        {
            case MPMovieFinishReasonPlaybackEnded:break;
            case MPMovieFinishReasonPlaybackError:break;
            case MPMovieFinishReasonUserExited:break;
        }
        [self stopPlayingVideo:nil];
    }
}

- (void)stopPlayingVideo:(id)paramSender
{
    if (self.moviePlayer != nil)
    {
        NSString *nString = MPMoviePlayerPlaybackDidFinishNotification;
        NSNotificationCenter *nCenter = [NSNotificationCenter defaultCenter];
        [nCenter removeObserver:self name:nString object:self.moviePlayer];
        [self.moviePlayer stop];
        [self.moviePlayer.view removeFromSuperview];
    }
}

+(void)generateThumbForImageView:(UIImageView *)imageView withVideoURLStr:(NSString *)videoURLStr
{
    NSURL *videoURL = [NSURL URLWithString:videoURLStr];
    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform=TRUE;
    
    CMTime thumbTime = CMTimeMakeWithSeconds(3,3);
    
    AVAssetImageGeneratorCompletionHandler handler =
    ^(CMTime requestedTime, CGImageRef img, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error)
    {
        if (result != AVAssetImageGeneratorSucceeded)
        {
            NSLog(@"couldn't generate thumbnail, error:%@", error);
        }
        else
        {
            imageView.image = [[UIImage alloc] initWithCGImage:img];
        }
    };
    
    NSArray *array = [NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]];
    generator.maximumSize = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
    [generator generateCGImagesAsynchronouslyForTimes:array completionHandler:handler];
}

@end
