//
//  SkillVideoPlayer.h
//  StikyHive
//
//  Created by Koh Quee Boon on 6/6/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface SkillVideoPlayer : NSObject

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

- (void)startPlayingVideo:(NSString *)videoPath onView:(UIView *)view;
+(void)generateThumbForImageView:(UIImageView *)imageView withVideoURLStr:(NSString *)videoURLStr;

@end
