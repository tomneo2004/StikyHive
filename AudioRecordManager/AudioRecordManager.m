//
//  AudioRecordManager.m
//  AudioRecord
//
//  Created by User on 1/2/16.
//  Copyright © 2016 ArcTech. All rights reserved.
//

#import "AudioRecordManager.h"

@interface AudioRecordManager ()

@property (strong, nonatomic) EZMicrophone *microphone;
@property (strong, nonatomic) EZRecorder *recorder;
@property (strong, nonatomic) EZAudioPlayer *player;

@end

@implementation AudioRecordManager{
    
    BOOL _isPlayingAudio;
    BOOL _isRecording;
    NSTimeInterval _totalRecordTime;
    AudioRecorderViewController *_audioRecorderController;
    //NSTimer *_recordingTimer;
    NSDate *_startRecordingDate;
    NSDate *_startPlayingDate;
    NSCalendar *_calendar;
}

static AudioRecordManager *_instance;

@synthesize delegate = _delegate;

@synthesize microphone = _microphone;
@synthesize recorder = _recorder;
@synthesize player = _player;

#pragma mark - setter
- (void)setTotalRecordTime:(NSTimeInterval)totalRecordTime{
    
    if(totalRecordTime < 1){
        _totalRecordTime = kDefaultTotalRecodingTime;
        return;
    }
    _totalRecordTime = totalRecordTime;
}

#pragma mark - getter
- (NSTimeInterval)totalRecordTime{
    
    return _totalRecordTime;
}

- (BOOL)isRecordingAudio{
    
    return _isRecording;
}

- (BOOL)isPlayingAudio{
    
    return _isPlayingAudio;
}

#pragma mark - override
- (id)init{
    
    if(self = [super init]){
        
        _isPlayingAudio = NO;
        _isRecording = NO;
        
        //set default record time
        _totalRecordTime = kDefaultTotalRecodingTime;
        
        _calendar = [NSCalendar currentCalendar];
        
        //setup audio session, EZMicrophone need audio session to work!
        AVAudioSession *session = [AVAudioSession sharedInstance];
        
        NSError *error;
        
        [session setInputGain:1.0f error:&error];
        if(error){
            
            NSLog(@"Error setting up audio session input gain: %@", error.localizedDescription);
            
            return nil;
        }
        
        [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
        if (error)
        {
            NSLog(@"Error setting up audio session: %@. EZMicrophone can't be initialized", error.localizedDescription);
            
            return nil;
        }
        
        [session setActive:YES error:&error];
        if (error)
        {
            NSLog(@"Error setting up audio session active: %@. EZMicrophone can't be initialized", error.localizedDescription);
            
            return nil;
        }
    }
    
    _microphone = [EZMicrophone microphoneWithDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppTerminate) name:UIApplicationWillTerminateNotification object:nil];
    
    return self;
}

#pragma mark - internal
- (BOOL)isRecordAudioExist{
    
    return [[NSFileManager defaultManager] fileExistsAtPath:[self recordAudioOutputPath]];
}

- (NSString *)recordAudioOutputPath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:kAudioFileName];
}

- (UIViewController *)rootViewController{
    
    return [[UIApplication sharedApplication] keyWindow].rootViewController;
}

- (void)onAppEnterBackground{
    
    if(_isPlayingAudio){
        
        [self stopPlayingAudio];
        
        if([_delegate respondsToSelector:@selector(endPlayingAudio)]){
            
            [_delegate endPlayingAudio];
        }
    }
    
    if(_isRecording){
        
        [self stopRecording];
        
        if([_delegate respondsToSelector:@selector(endRecordingAudioWithFilePath:)]){
            
            [_delegate endRecordingAudioWithFilePath:[self recordAudioOutputPath]];
        }
    }
}

- (void)onAppTerminate{
    
    if(_isRecording){
        
        [self stopRecording];
        
        if([_delegate respondsToSelector:@selector(endRecordingAudioWithFilePath:)]){
            
            [_delegate endRecordingAudioWithFilePath:[self recordAudioOutputPath]];
        }
    }
}

- (void)playAudioWithPath:(NSString *)filePath{
    
    if(_audioRecorderController)
        [_audioRecorderController.audioPlotGL clear];
    
    _player = [EZAudioPlayer audioPlayer];
    _player.volume = 1.0f;
    _player.delegate = self;
    
    EZAudioFile *afile = [EZAudioFile audioFileWithURL:[NSURL URLWithString:filePath]];
    [_player playAudioFile:afile];
    
    if(_audioRecorderController){
        
        [_audioRecorderController startPlayingAudio];
    }
    
    _startPlayingDate = [NSDate date];
    
    _isPlayingAudio = YES;
}

- (void)stopPlayingAudio{
    
    [_player pause];
    
    if(_audioRecorderController){
        
        [_audioRecorderController stopPlayingAudio];
    }
    
    _isPlayingAudio = NO;
}

- (void)startRecording{
    
    
    if(_audioRecorderController)
        [_audioRecorderController.audioPlotGL clear];
    
    [_microphone startFetchingAudio];
    
    _recorder = [EZRecorder recorderWithURL:[NSURL URLWithString:[self recordAudioOutputPath]] clientFormat:[_microphone audioStreamBasicDescription] fileType:EZRecorderFileTypeM4A delegate:self];
    
    if(_audioRecorderController)
        [_audioRecorderController startRecording];
    
    _startRecordingDate = [NSDate date];
    
    _isRecording = YES;
}

- (void)stopRecording{
    
    [_recorder closeAudioFile];
    
    [_microphone stopFetchingAudio];
    
    if(_audioRecorderController)
        [_audioRecorderController stopRecording];
    
    _isRecording = NO;
}

#pragma mark - public interface
//return the current instance of manager, create one if needed
+ (AudioRecordManager *)sharedAudioRecordManager{
    
    if(_instance == nil){
        
        _instance = [[AudioRecordManager alloc] init];
    }
    
    return _instance;
}

+ (AudioRecordManager *)sharedAudioRecordManagerWithDelegate:(id<AudioRecordManagerDelegate>)del{
    
    AudioRecordManager * ret = [AudioRecordManager sharedAudioRecordManager];
    
    ret.delegate = del;
    
    return ret;
}

- (NSString *)recordAudioFilePath{
    
    if([self isRecordAudioExist]){
        
        return [self recordAudioOutputPath];
    }
    
    return nil;
}

- (void)presentAudioRecorder{
    
    _audioRecorderController = [[AudioRecorderViewController alloc] initWithNibName:@"AudioRecorderViewController" bundle:nil];
    
    if(_audioRecorderController == nil){
        
        NSLog(@"Unable to initialized AudioRecorderViewController");
        
        return;
    }
    
    _audioRecorderController.delegate = self;
    
    [[self rootViewController] presentViewController:_audioRecorderController animated:YES completion:nil];
    
}

#pragma mark - EZMicrophoneDelegate
- (void)microphone:(EZMicrophone *)microphone changedPlayingState:(BOOL)isPlaying{
    
}

- (void)microphone:(EZMicrophone *)microphone hasAudioReceived:(float **)buffer withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // All the audio plot needs is the buffer data (float*) and the size. Internally the audio plot will handle all the drawing related code, history management, and freeing its own resources. Hence, one badass line of code gets you a pretty plot :)
        [_audioRecorderController.audioPlotGL updateBuffer:buffer[0] withBufferSize:bufferSize];
    
    });
}

- (void)microphone:(EZMicrophone *)microphone hasBufferList:(AudioBufferList *)bufferList withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels{
    
    if (_isRecording)
    {
        [_recorder appendDataFromBufferList:bufferList withBufferSize:bufferSize];
    }
}

#pragma mark - EZAudioRecorderDelegate
- (void)recorderUpdatedCurrentTime:(EZRecorder *)recorder{
    
    
    if(recorder.currentTime <= _totalRecordTime){
        
        NSDate *now = [NSDate date];
        
        NSDate *endDate = [_startRecordingDate dateByAddingTimeInterval:_totalRecordTime];
        
        NSDateComponents *comp = [_calendar components:NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:now toDate:endDate options:0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _audioRecorderController.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)[comp minute], (long)[comp second]];
        });
    }
    else{
        
        [self stopRecording];
        
        if([_delegate respondsToSelector:@selector(endRecordingAudioWithFilePath:)]){
            
            [_delegate endRecordingAudioWithFilePath:[self recordAudioOutputPath]];
        }
    }
}

- (void)recorderDidClose:(EZRecorder *)recorder{
    
    
}

#pragma mark - EZAudioPlayerDelegate
- (void)audioPlayer:(EZAudioPlayer *)audioPlayer reachedEndOfAudioFile:(EZAudioFile *)audioFile{
    
    if(_isPlayingAudio){
        
        [self stopPlayingAudio];
        
        if([_delegate respondsToSelector:@selector(endPlayingAudio)]){
            
            [_delegate endPlayingAudio];
        }
    }
}

- (void)audioPlayer:(EZAudioPlayer *)audioPlayer updatedPosition:(SInt64)framePosition inAudioFile:(EZAudioFile *)audioFile{
    
    if(audioPlayer.currentTime <= audioPlayer.duration){
        
        NSDate *now = [NSDate date];
        
        NSDate *endDate = [_startPlayingDate dateByAddingTimeInterval:audioPlayer.duration];
        
        NSDateComponents *comp = [_calendar components:NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:now toDate:endDate options:0];
        

        
        dispatch_async(dispatch_get_main_queue(), ^{
            _audioRecorderController.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)[comp minute], (long)[comp second]];
        });

    }
    else{
        
        [self stopPlayingAudio];
        
        if([_delegate respondsToSelector:@selector(endPlayingAudio)]){
            
            [_delegate endPlayingAudio];
        }
    }
}

- (void)audioPlayer:(EZAudioPlayer *)audioPlayer playedAudio:(float **)buffer withBufferSize:(UInt32)bufferSize withNumberOfChannels:(UInt32)numberOfChannels inAudioFile:(EZAudioFile *)audioFile{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // All the audio plot needs is the buffer data (float*) and the size. Internally the audio plot will handle all the drawing related code, history management, and freeing its own resources. Hence, one badass line of code gets you a pretty plot :)
        [_audioRecorderController.audioPlotGL updateBuffer:buffer[0] withBufferSize:bufferSize];
        
    });
}

#pragma mark - AudioRecorderViewDelegate
- (void)onPlayClick{
    
    if(_isRecording){
        
        [self stopRecording];
        
        if([_delegate respondsToSelector:@selector(endRecordingAudioWithFilePath:)]){
            
            [_delegate endRecordingAudioWithFilePath:[self recordAudioOutputPath]];
        }
    }
    
    if(_isPlayingAudio){
        
        [self stopPlayingAudio];
    }
    
    if([self isRecordAudioExist]){
        
        if([_delegate respondsToSelector:@selector(beginPlayingAudio)]){
            
            [_delegate beginPlayingAudio];
        }
        
        [self playAudioWithPath:[self recordAudioOutputPath]];
    }
    else{
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"No record audio" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:defaultAction];
        
        [_audioRecorderController presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)onStopPlayingClick{
    
    if(_isPlayingAudio){
        
        [self stopPlayingAudio];
        
        if([_delegate respondsToSelector:@selector(endPlayingAudio)]){
            
            [_delegate endPlayingAudio];
        }
    }
}

- (void)onRecordingClick{
    
    if(_isPlayingAudio){
        
        [self stopPlayingAudio];
    }
    
    if(_isRecording){
        
        [self stopRecording];
    }
    
    if([_delegate respondsToSelector:@selector(beginRecordingAudio)]){
        
        [_delegate beginRecordingAudio];
    }
    
    [self startRecording];
}

- (void)onStopRecordingClick{
    
    if(_isRecording){
        
        [self stopRecording];
        
        if([_delegate respondsToSelector:@selector(endRecordingAudioWithFilePath:)]){
            
            [_delegate endRecordingAudioWithFilePath:[self recordAudioOutputPath]];
        }
    }
}

- (void)onDismiss{
    
    if(_isRecording){
        
        [self stopRecording];
        
        if([_delegate respondsToSelector:@selector(endRecordingAudioWithFilePath:)]){
            
            [_delegate endRecordingAudioWithFilePath:[self recordAudioOutputPath]];
        }
    }
    
    if(_isPlayingAudio){
        
        [self stopPlayingAudio];
        
        if([_delegate respondsToSelector:@selector(endRecordingAudioWithFilePath:)]){
            
            [_delegate endRecordingAudioWithFilePath:[self recordAudioOutputPath]];
        }
    }
    
    if([_delegate respondsToSelector:@selector(recordingViewDismiss)]){
        
        [_delegate recordingViewDismiss];
    }
    
    if(_audioRecorderController)
    {
        [_audioRecorderController.audioPlotGL clear];
        
        _audioRecorderController = nil;
    }
    
    [[self rootViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
