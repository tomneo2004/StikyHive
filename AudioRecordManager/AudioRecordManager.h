//
//  AudioRecordManager.h
//  AudioRecord
//
//  Created by User on 1/2/16.
//  Copyright © 2016 ArcTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EZAudio.h"
#import "AudioRecorderViewController.h"

#define kAudioFileName @"AudioFile-Output.m4a"
#define kDefaultTotalRecodingTime 10

@class AudioRecordManager;

@protocol AudioRecordManagerDelegate <NSObject>

@optional

/**
 * Call when manager start recording
 */
- (void)beginRecordingAudio;

/**
 * Call when recording end
 */
- (void)endRecordingAudioWithFilePath:(NSString *)audioFilePath;

/**
 * Call when manager start playing audio
 */
- (void)beginPlayingAudio;

/**
 * Call when playing audio is end
 */
- (void)endPlayingAudio;

/**
 * Call when recording view is about to dismiss
 */
- (void)recordingViewDismiss;

@end

@interface AudioRecordManager : NSObject<EZRecorderDelegate, EZMicrophoneDelegate, AudioRecorderViewDelegate, EZAudioPlayerDelegate>

@property (weak, nonatomic) id<AudioRecordManagerDelegate> delegate;

/**
 * Total time audio can record in second.
 * At least give value more or equal than 1, given less than 1 will be reset to default 10 second
 * Default is 10 second
 */
@property (assign, nonatomic) NSTimeInterval totalRecordTime;

/**
 * Is current recording audio
 */
@property (assign, readonly, nonatomic) BOOL isRecordingAudio;

/**
 * Is current playing audio
 */
@property (assign, readonly, nonatomic) BOOL isPlayingAudio;

/**
 * Return instace of AudioRecordManager.
 * Return nil if there is an error occured when intitalizing
 */
+ (AudioRecordManager *)sharedAudioRecordManager;

/**
 * Return instace of AudioRecordManager with given delegate.
 * Return nil if there is an error occured when intitalizing
 */
+ (AudioRecordManager *)sharedAudioRecordManagerWithDelegate:(id<AudioRecordManagerDelegate>)del;

/**
 * Return last record audio file path.
 * Return nil if no last record audio file
 */
- (NSString *)recordAudioFilePath;

/**
 * Present audio recorder view
 */
- (void)presentAudioRecorder;

@end
