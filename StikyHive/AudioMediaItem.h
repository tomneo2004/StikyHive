//
//  AudioMediaItem.h
//  StikyHive
//
//  Created by User on 15/2/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "JSQMediaItem.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioPlayerManager.h"
#import "AFNetworking.h"




@interface AudioMediaItem : JSQMediaItem<JSQMessageMediaData, NSCoding, NSCopying, AudioPlayerManagerDelegate>

@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, strong) NSNumber *duration;

- (instancetype)initWithFileURL:(NSURL *)fileURL Duration:(NSNumber *)duration;
- (void)playAudio;
- (void)stopAudio;

@end
