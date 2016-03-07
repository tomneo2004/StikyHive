//
//  FileMediaItem.m
//  StikyHive
//
//  Created by User on 7/3/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "FileMediaItem.h"
#import "WebDataInterface.h"
#import "JSQMessagesMediaPlaceholderView.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"

#import "UIImage+JSQMessages.h"
#import "AFNetworking.h"

typedef enum{
    
    FNotDownload,
    FDownload,
    FDownloading
}FileStatus;

@interface FileMediaItem ()

@property (nonatomic, strong) UIImageView *cacheImageView;
@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, assign) FileStatus fileStatus;
@property (strong, nonatomic) AFHTTPRequestOperation *downloadOp;
@property (copy, nonatomic) NSString *filePath;

@end

@implementation FileMediaItem

- (instancetype)initWithFileURLString:(NSString *)theFileURL{
    
    self = [super init];
    if(self){
        
        NSString *fullFilePath = [WebDataInterface getFullUrlPath:theFileURL];
        fullFilePath = [fullFilePath stringByReplacingOccurrencesOfString:@" " withString:@""];
        _fileURL = [NSURL URLWithString:fullFilePath];
        _fileStatus = FNotDownload;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    }
    
    return self;
}

- (void)downloadFile{
    
    
    
    if(_fileStatus == FDownload && _filePath != nil){
        
        if([[NSFileManager defaultManager] fileExistsAtPath:_filePath]){
            
            //open file
            
            [[NSNotificationCenter defaultCenter] postNotificationName:openFileRequired object:_filePath];
        }
        
    }
    else if(_fileStatus == FDownloading){
        
        return;
    }
    else if(_fileStatus == FNotDownload){
        
        [self startDownloadFile];
        
        [self updateStatusView];
    }
}

- (void)startDownloadFile{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:_fileURL];
    
    _downloadOp = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [[_fileURL absoluteString] stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    _downloadOp.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    
    __weak typeof(self) weakSelf = self;
    [_downloadOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully downloaded file to %@", path);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _fileStatus = FDownload;
            _filePath = path;
            [weakSelf updateStatusView];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Fail download file Error: %@", error);
        
        _fileStatus = FNotDownload;
        [weakSelf updateStatusView];
    }];
    
    [_downloadOp start];
    
    _fileStatus = FDownloading;
}

- (void)applicationWillTerminate:(NSNotification *)notification{
    
    [self cleanFile];
}

- (void)dealloc{
    
    [self cleanFile];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}

- (void)cleanFile{
    
    if(_filePath != nil && [[NSFileManager defaultManager] fileExistsAtPath:_filePath]){
        
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:_filePath error:&error];
    }
}

- (UIView *)mediaView{
    
    if(self.cacheImageView == nil){
        
        
        CGSize size = [self mediaViewDisplaySize];
        BOOL outgoing = self.appliesMediaViewMaskAsOutgoing;
        UIColor *colorBackground = [UIColor whiteColor];
        //UIColor *colorContent = [UIColor whiteColor];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
        imageView.backgroundColor = colorBackground;
        imageView.clipsToBounds = YES;
        
        UIImageView *fileIcon = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"keep_track"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        fileIcon.frame = CGRectMake(5, 5, size.width-5, size.height-5);
        fileIcon.contentMode = UIViewContentModeScaleAspectFit;
        [imageView addSubview:fileIcon];
        
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.frame = fileIcon.frame;
        [_indicator setHidden:YES];
        [imageView addSubview:_indicator];
        
        
        [self updateStatusView];
        
        [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:imageView isOutgoing:outgoing];
        self.cacheImageView = imageView;
    }
    
    //self.cacheImageView.userInteractionEnabled = YES;
    return self.cacheImageView;
}

- (void)updateStatusView{
    
    if(_fileStatus == FNotDownload){
        
        [_indicator setHidden:YES];
    }
    else if(_fileStatus == FDownloading){
        
        [_indicator setHidden:NO];
        [_indicator startAnimating];
    }
    else if(_fileStatus == FDownload){
        
        [_indicator setHidden:YES];
    }
}

- (CGSize)mediaViewDisplaySize{
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        return CGSizeMake(220.0f, 100.0f);
    }
    
    return CGSizeMake(220.0f, 100.0f);
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
    
    FileMediaItem *item = (FileMediaItem *)object;
    
    return [self.fileURL isEqual:item.fileURL];
}

- (NSUInteger)hash{
    
    return super.hash ^ self.fileURL.hash;
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"<%@: fileURL=%@, appliesMediaViewMaskAsOutgoing=%@>",
            [self class], self.fileURL, @(self.appliesMediaViewMaskAsOutgoing)];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _fileURL = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(fileURL))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.fileURL forKey:NSStringFromSelector(@selector(fileURL))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    FileMediaItem *copy = [[[self class] allocWithZone:zone] initWithFileURLString:self.fileURL.absoluteString];
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    return copy;
}

@end
