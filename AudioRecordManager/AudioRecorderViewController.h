//
//  AudioRecorderViewController.h
//  AudioRecord
//
//  Created by User on 1/2/16.
//  Copyright © 2016 ArcTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EZAudio.h"

@protocol AudioRecorderViewDelegate <NSObject>

@optional
- (void)onRecordingClick;
- (void)onStopRecordingClick;
- (void)onPlayClick;
- (void)onStopPlayingClick;
- (void)onDismiss;

@end

@interface AudioRecorderViewController : UIViewController

@property (weak, nonatomic) id<AudioRecorderViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet EZAudioPlotGL *audioPlotGL;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (nonatomic) IBInspectable UIColor *recordingStatColor;
@property (nonatomic) IBInspectable UIColor *playingStatColor;

- (void)startRecording;
- (void)stopRecording;
- (void)startPlayingAudio;
- (void)stopPlayingAudio;

@end
