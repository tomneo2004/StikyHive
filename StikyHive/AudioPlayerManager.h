//
//  AudioPlayerManager.h
//  StikyHive
//
//  Created by User on 25/2/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AFSoundManager.h"

@protocol AudioPlayerManagerDelegate <NSObject>

@optional
- (void)onBeginPlayAudio;
- (void)onPlayAudio;
- (void)onAudioTimeUpdate:(NSInteger)seconds;
- (void)onAudioStop;


@end

@interface AudioPlayerManager : NSObject

@property (weak, nonatomic) id sender;

+ (instancetype)sharedAudioPlayerManager;



- (void)playAudioWithItem:(AFSoundItem *)item withSender:(id)sender;

- (void)stopAudio;

@end
