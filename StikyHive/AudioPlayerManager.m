//
//  AudioPlayerManager.m
//  StikyHive
//
//  Created by User on 25/2/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "AudioPlayerManager.h"

@interface AudioPlayerManager ()

@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) AFSoundPlayback *playback;

@end

@implementation AudioPlayerManager{
    

}

static AudioPlayerManager *_instance;

+ (instancetype)sharedAudioPlayerManager{
    
    if(_instance == nil){
        
        _instance = [[AudioPlayerManager alloc] init];
    }
    
    return _instance;
}


- (void)playAudioWithItem:(AFSoundItem *)item withSender:(id)sender{
    
    if(_playback != nil)
        [self stopAudio];
    
    _sender = sender;
    _delegate = sender;
    
    _playback = [[AFSoundPlayback alloc] initWithItem:item];
    
    [_playback listenFeedbackUpdatesWithBlock:^(AFSoundItem *item) {
        
        NSLog(@"Item duration: %ld - time elapsed: %ld", (long)item.duration, (long)item.timePlayed);
        
        if([_delegate respondsToSelector:@selector(onAudioTimeUpdate:)]){
            
            [_delegate onAudioTimeUpdate:item.duration - item.timePlayed];
        }
        
    } andFinishedBlock:^{
        
        NSLog(@"Track finished playing");
        
        [self stopAudio];
        
    }];
    
    [_playback play];
    
    if([_delegate respondsToSelector:@selector(onPlayAudio)]){
        
        [_delegate onPlayAudio];
    }
}

- (void)stopAudio{
    
    if(_playback != nil){
        
        [_playback pause];
        [_playback restart];
        
        if([_delegate respondsToSelector:@selector(onAudioStop)]){
            
            [_delegate onAudioStop];
        }
        
        _playback = nil;
    }
    
}

@end
