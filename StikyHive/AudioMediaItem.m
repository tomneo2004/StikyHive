//
//  AudioMediaItem.m
//  StikyHive
//
//  Created by User on 15/2/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "AudioMediaItem.h"

#import "JSQMessagesMediaPlaceholderView.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"

#import "UIImage+JSQMessages.h"

@interface AudioMediaItem()

@property (strong, nonatomic) UIImageView *cachedAudioImageView;
@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) AFHTTPRequestOperation *downloadOp;
@property (copy, nonatomic) NSString *filePath;
@end

typedef enum{
    
    APrepare,
    APlaying,
    AReady
}playerStatus;

@implementation AudioMediaItem{
    
    AFSoundItem *_playerItem;
    playerStatus _cStatus;
}

#pragma mark - Initialization

- (instancetype)initWithFileURL:(NSURL *)fileURL Duration:(NSNumber *)duration{
    
    self = [super init];
    if (self){
        
        _cStatus = APrepare;
        
        _fileURL = [fileURL copy];
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"Zedd-Stay-The-Night-ft.-Hayley-Williams" ofType:@"3gp"];
        
        /*
        int r = arc4random_uniform(3);
        if(r==0)
            _fileURL = [NSURL URLWithString:@"http://download.wavetlan.com/SVV/Media/HTTP/3GP/HelixMobileProducer/HelixMobileProducer_test5_3GPv5_MPEG4SP_24bit_176x144_AR1.22_30fps_KFx_320kbps_AAC-LC_Mono_11025Hz_24kbps.3gp"];
        else
            _fileURL = [NSURL URLWithString:@"http://download.wavetlan.com/SVV/Media/HTTP/3GP/Variable/3GP_AAC_48kbps_H263_208kbps_25fps_QCIF.3gp"];
        */
        
        _duration = duration;
        _cachedAudioImageView = nil;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
        
        [self loadAudio];
        
    }
    return self;
}

- (void)dealloc{
    
    _fileURL = nil;
    _cachedAudioImageView = nil;
    
    [self removeSaveFile];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}

- (void)removeSaveFile{
    
    
    if([[NSFileManager defaultManager] fileExistsAtPath:_filePath]){
        
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:_filePath error:&error];
        
        NSLog(@"remove file fail %@", error);
    }
}

- (void)applicationWillTerminate:(NSNotification *)notification{
    
    [self removeSaveFile];
}

- (void)loadAudio{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:_fileURL];
    
    _downloadOp = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [[_fileURL absoluteString] stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    _filePath = path;
    _downloadOp.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    
    __weak typeof(self) weakSelf = self;
    __block typeof (AFSoundItem *) playerItem;
    [_downloadOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully downloaded audio file to %@", path);
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            _cStatus = AReady;
            _playerItem = [[AFSoundItem alloc] initWithDocFile:_filePath];
            playerItem = _playerItem;
            [weakSelf updateIndicator];
            __attribute__((unused)) AFSoundPlayback *playback = [[AFSoundPlayback alloc] initWithItem:playerItem];
            [weakSelf updateTimeLabelWithDuration:[NSNumber numberWithInteger:playerItem.duration]];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [_downloadOp start];
}

#pragma mark - Setters

- (void)setFileURL:(NSURL *)fileURL{
    
    _fileURL = [fileURL copy];
    _cachedAudioImageView = nil;
}


- (void)setDuration:(NSNumber *)duration{
    
    _duration = duration;
    _cachedAudioImageView = nil;
}


- (void)setAppliesMediaViewMaskAsOutgoing:(BOOL)appliesMediaViewMaskAsOutgoing{
    
    [super setAppliesMediaViewMaskAsOutgoing:appliesMediaViewMaskAsOutgoing];
    _cachedAudioImageView = nil;
}

#pragma mark - public interface
- (void)playAudio{
    
    if(_cStatus == APlaying){
        
        [self stopAudio];
        
        return;
    }
     
    
    if(_cStatus == AReady){
        
        NSLog(@"playing audio");
        
        [[AudioPlayerManager sharedAudioPlayerManager] playAudioWithItem:_playerItem withSender:self];
        
    }
    
}

- (void)stopAudio{
    
    NSLog(@"stop audio");
    
    [[AudioPlayerManager sharedAudioPlayerManager] stopAudio];
    
    _cStatus = AReady;
    [self updateIndicator];
    
    [_iconView setImage:[UIImage imageNamed:@"ic_play_arrow_black_24dp"]];
}


#pragma mark - AudioPlayerManager delegate
- (void)onBeginPlayAudio{
    
    _cStatus = APrepare;
    [self updateIndicator];
}

- (void)onPlayAudio{
    
    _cStatus = APlaying;
    [self updateIndicator];
    
    [_iconView setImage:[UIImage imageNamed:@"ic_stop_black_24dp"]];
}

- (void)onAudioTimeUpdate:(NSInteger)seconds{
    
    [self updateTimeLabelWithDuration:[NSNumber numberWithInteger:seconds]];
}

- (void)onAudioStop{
    
    _cStatus = AReady;
    [self updateIndicator];
    
    [self updateTimeLabelWithDuration:[NSNumber numberWithInteger:_playerItem.duration]];
    
    [_iconView setImage:[UIImage imageNamed:@"ic_play_arrow_black_24dp"]];
}

#pragma mark - Update
- (void)updateTimeLabelWithDuration:(NSNumber *)duration{
    
    if(_cStatus == APrepare){
        _timeLabel.text = @"";
        return;
    }
    
    if([duration integerValue] <= 0){
        
        _timeLabel.text = @"Audio";
    }
    
    int minute	= [duration intValue] / 60;
    int second	= [duration intValue] % 60;
    _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minute, second];
}

- (void)updateIndicator{
    
    if(_cStatus == APrepare){
        
        [_iconView setHidden:YES];
        [_indicator setHidden:NO];
    }
    else if(_cStatus == APlaying){
        
        [_iconView setHidden:NO];
        [_indicator setHidden:YES];
        [_indicator stopAnimating];
    }
    else if(_cStatus == AReady){
        
        [_iconView setHidden:NO];
        [_indicator setHidden:YES];
        [_indicator stopAnimating];
    }
}

#pragma mark - JSQMessageMediaData protocol

- (UIView *)mediaView{
    
    if(self.cachedAudioImageView == nil){
        
        CGSize size = [self mediaViewDisplaySize];
        BOOL outgoing = self.appliesMediaViewMaskAsOutgoing;
        UIColor *colorBackground = outgoing ?  [UIColor cyanColor] : [UIColor lightGrayColor];
        UIColor *colorContent = outgoing ? [UIColor whiteColor] : [UIColor whiteColor];
        
        //UIImage *icon = [[UIImage imageNamed:@"ic_play_arrow_black_24dp"] jsq_imageMaskedWithColor:colorContent];
        UIImage *icon = [UIImage imageNamed:@"ic_play_arrow_black_24dp"];
        _iconView = [[UIImageView alloc] initWithImage:icon];
        CGFloat ypos = (size.height - icon.size.height) / 2;
        CGFloat xpos = outgoing ? ypos : ypos + 6;
        _iconView.frame = CGRectMake(xpos, ypos, icon.size.width, icon.size.height);
        
        _indicator = [[UIActivityIndicatorView alloc] initWithFrame:_iconView.frame];
        [_indicator startAnimating];
        
        CGRect frame = outgoing ? CGRectMake(45, 10, 60, 20) : CGRectMake(51, 10, 60, 20);
        _timeLabel = [[UILabel alloc] initWithFrame:frame];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = colorContent;
        
        /*
        int minute	= [self.duration intValue] / 60;
        int second	= [self.duration intValue] % 60;
        _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minute, second];
        */
        //[self updateTimeLabelWithDuration:[NSNumber numberWithInteger:_playerItem.duration]];
        
        _timeLabel.text = @"Audio";
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
        imageView.backgroundColor = colorBackground;
        imageView.clipsToBounds = YES;
        [imageView addSubview:_iconView];
        [imageView addSubview:_timeLabel];
        [imageView addSubview:_indicator];
        
        [self updateIndicator];
        
        [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:imageView isOutgoing:outgoing];
        self.cachedAudioImageView = imageView;
    }
    
    return self.cachedAudioImageView;
}

- (CGSize)mediaViewDisplaySize{
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        return CGSizeMake(120.0f, 40.0f);
    }
    
    return CGSizeMake(120.0f, 40.0f);
}

- (NSUInteger)mediaHash{
    
    return self.hash;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object{
    
    if (![super isEqual:object])
    {
        return NO;
    }
    
    AudioMediaItem *audioItem = (AudioMediaItem *)object;
    
    return [self.fileURL isEqual:audioItem.fileURL] && [self.duration isEqualToNumber:audioItem.duration];
}

- (NSUInteger)hash{
    
    return super.hash ^ self.fileURL.hash;
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"<%@: fileURL=%@, duration=%@, appliesMediaViewMaskAsOutgoing=%@>",
            [self class], self.fileURL, self.duration, @(self.appliesMediaViewMaskAsOutgoing)];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _fileURL = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(fileURL))];
        _duration = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(duration))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.fileURL forKey:NSStringFromSelector(@selector(fileURL))];
    [aCoder encodeObject:self.duration forKey:NSStringFromSelector(@selector(duration))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    AudioMediaItem *copy = [[[self class] allocWithZone:zone] initWithFileURL:self.fileURL Duration:self.duration];
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    return copy;
}

@end
