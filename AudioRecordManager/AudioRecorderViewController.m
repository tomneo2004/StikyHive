//
//  AudioRecorderViewController.m
//  AudioRecord
//
//  Created by User on 1/2/16.
//  Copyright © 2016 ArcTech. All rights reserved.
//

#import "AudioRecorderViewController.h"
#import "AudioRecordManager.h"

@interface AudioRecorderViewController ()

@end

@implementation AudioRecorderViewController


@synthesize delegate = _delegate;
@synthesize audioPlotGL = _audioPlotGL;
@synthesize timeLabel = _timeLabel;
@synthesize statusLabel = _statusLabel;
@synthesize recordButton = _recordButton;
@synthesize playButton = _playButton;

@synthesize recordingStatColor = _recordingStatColor;
@synthesize playingStatColor = _playingStatColor;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    _timeLabel.text = @"";
    _statusLabel.text = @"";
    
    [self setupAudioPlot];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupAudioPlot{
    
    _audioPlotGL.plotType        = EZPlotTypeRolling;
    _audioPlotGL.shouldFill      = YES;
    _audioPlotGL.shouldMirror    = YES;
}

- (void)startRecording{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _timeLabel.textColor = _recordingStatColor;
        _statusLabel.textColor = _recordingStatColor;
        
        _statusLabel.text = @"Recording";
        [_recordButton setTitle:@"Stop recording" forState:UIControlStateNormal];
        [_playButton setEnabled:NO];
    });
}

- (void)stopRecording{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _timeLabel.text = @"00:00";
        _statusLabel.text = @"";
        [_recordButton setTitle:@"Record" forState:UIControlStateNormal];
        [_playButton setEnabled:YES];
    });
}

- (void)startPlayingAudio{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _timeLabel.textColor = _playingStatColor;
        _statusLabel.textColor = _playingStatColor;
        
        _statusLabel.text = @"Playing";
        [_playButton setTitle:@"Stop playing" forState:UIControlStateNormal];
        [_recordButton setEnabled:NO];
    });
}

- (void)stopPlayingAudio{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _timeLabel.text = @"00:00";
        _statusLabel.text = @"";
        [_playButton setTitle:@"Play" forState:UIControlStateNormal];
        [_recordButton setEnabled:YES];
    });
}

- (IBAction)onRecord:(id)sender{
    
    if([AudioRecordManager sharedAudioRecordManager].isRecordingAudio){
        
        if([_delegate respondsToSelector:@selector(onStopRecordingClick)]){
            
            [_delegate onStopRecordingClick];
        }
    }
    else{
        
        if([_delegate respondsToSelector:@selector(onRecordingClick)]){
            
            [_delegate onRecordingClick];
        }
    }
    
}

- (IBAction)onPlay:(id)sender{
    
    if([AudioRecordManager sharedAudioRecordManager].isPlayingAudio){
        
        if([_delegate respondsToSelector:@selector(onStopPlayingClick)]){
            
            [_delegate onStopPlayingClick];
        }
    }
    else{
        
        if([_delegate respondsToSelector:@selector(onPlayClick)]){
            
            [_delegate onPlayClick];
        }
    }
    
}

- (IBAction)onDismiss:(id)sender{
    
    if([_delegate respondsToSelector:@selector(onDismiss)]){
        
        [_delegate onDismiss];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
