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

@end

@implementation AudioMediaItem

#pragma mark - Initialization

- (instancetype)initWithFileURL:(NSURL *)fileURL Duration:(NSNumber *)duration{
    
    self = [super init];
    if (self){
        
        _fileURL = [fileURL copy];
        _duration = duration;
        _cachedAudioImageView = nil;
    }
    return self;
}

- (void)dealloc{
    
    _fileURL = nil;
    _cachedAudioImageView = nil;
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

#pragma mark - JSQMessageMediaData protocol

- (UIView *)mediaView{
    
    if(self.cachedAudioImageView == nil){
        
        CGSize size = [self mediaViewDisplaySize];
        BOOL outgoing = self.appliesMediaViewMaskAsOutgoing;
        UIColor *colorBackground = outgoing ?  [UIColor cyanColor] : [UIColor lightGrayColor];
        UIColor *colorContent = outgoing ? [UIColor whiteColor] : [UIColor grayColor];
        
        UIImage *icon = [[UIImage jsq_defaultPlayImage] jsq_imageMaskedWithColor:colorContent];
        UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
        CGFloat ypos = (size.height - icon.size.height) / 2;
        CGFloat xpos = outgoing ? ypos : ypos + 6;
        iconView.frame = CGRectMake(xpos, ypos, icon.size.width, icon.size.height);
        
        CGRect frame = outgoing ? CGRectMake(45, 10, 60, 20) : CGRectMake(51, 10, 60, 20);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = colorContent;
        int minute	= [self.duration intValue] / 60;
        int second	= [self.duration intValue] % 60;
        label.text = [NSString stringWithFormat:@"%02d:%02d", minute, second];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
        imageView.backgroundColor = colorBackground;
        imageView.clipsToBounds = YES;
        [imageView addSubview:iconView];
        [imageView addSubview:label];
        
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
