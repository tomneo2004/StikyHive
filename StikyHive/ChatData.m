//
//  ChatData.m
//  StikyHive
//
//  Created by THV1WP15S on 25/1/16.
//  Copyright (c) 2016 Stiky Hive. All rights reserved.
//

#import "ChatData.h"
#import "UserInfo.h"
#import "LocalDataInterface.h"
#import "WebDataInterface.h"
#import "AudioMediaItem.h"
#import "OfferMediaItem.h"
#import "FileMediaItem.h"
#import "AcceptOfferMediaItem.h"
#import "AFNetworking.h"
#import "ViewControllerUtil.h"

@interface ChatData ()

@property (strong, nonatomic) NSMutableArray *imgDownloadQueue;

@end

@implementation ChatData

- (instancetype)initWithIncomingAvatarImage:(UIImage *)avatarImage
                                 incomingID:(NSString *)inID incomingDisplayName:(NSString *)inName
                                 outgoingID:(NSString *)outID outgoingDisplayName:(NSString *)outName
{
    self = [super init];
    
    if (self) {
        self.messages = [NSMutableArray new];
        
        _incomingUserId = inID;
        _outgoingUserId = outID;
        _incomingDisplayName = inName;
        _outgoingDisplayName = outName;
        
        UIImage *image = avatarImage ? avatarImage : [UIImage imageNamed:@"Default_profile_small@2x"];
        CGFloat diameter = kJSQMessagesCollectionViewAvatarSizeDefault;
        _incomingAvatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:image diameter:diameter];
        
        

        NSString *imagePath = [WebDataInterface getFullUrlPath:[LocalDataInterface retrieveProfileUrl]];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
        UIImage *myImage = [UIImage imageWithData:imageData];
        myImage = myImage ? myImage : [UIImage imageNamed:@"Default_profile_small@2x"];

        
        _outgoingAvatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:myImage diameter:diameter];

        
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        UIColor *blue = [UIColor colorWithRed:164.0/255 green:214.0/255 blue:208.0/255 alpha:1.0];
        
        _outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:blue];
        _incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor whiteColor]];
        
        _imgDownloadQueue = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (JSQMessage *)addPhotoMessage:(UIImage *)image
{
    JSQPhotoMediaItem *photo = [[JSQPhotoMediaItem alloc] initWithImage:image];
    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:_outgoingUserId displayName:_outgoingDisplayName media:photo];
    [self.messages addObject:photoMessage];
    
    return photoMessage;
}

- (void)addPhotoMsg:(UIImage *)image
{
    JSQPhotoMediaItem *photo = [[JSQPhotoMediaItem alloc] initWithImage:image];
    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:_outgoingUserId displayName:_outgoingDisplayName media:photo];
    [self.messages addObject:photoMessage];
    
}


- (JSQMessage *)addIncomingPhotoMessage:(NSString *)imageURL{
    
    /*
    JSQPhotoMediaItem *photo = [[JSQPhotoMediaItem alloc] initWithImage:image];
    [photo setAppliesMediaViewMaskAsOutgoing:NO];
    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:_incomingUserId displayName:_incomingDisplayName media:photo];
    [self.messages addObject:photoMessage];
    
    return photoMessage;
     */
    
    JSQPhotoMediaItem *photo = [[JSQPhotoMediaItem alloc] initWithImage:nil];
    [photo setAppliesMediaViewMaskAsOutgoing:NO];
    JSQMessage *photoMessage = [JSQMessage messageWithSenderId:_incomingUserId displayName:_incomingDisplayName media:photo];
    [self.messages addObject:photoMessage];
    
    [self startDownloadImageWithPhotoItem:photo WithURL:imageURL];
    
    return photoMessage;
}

- (void)startDownloadImageWithPhotoItem:(JSQPhotoMediaItem *)item WithURL:(NSString *)url{
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    op.responseSerializer = [AFImageResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [item setImage:responseObject];
        
        if([_delegate respondsToSelector:@selector(onReceivePhotoReadyToPresent)]){
            
            [_delegate onReceivePhotoReadyToPresent];
        }
        
        [_imgDownloadQueue removeObject:operation];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError * error) {
        
        [_imgDownloadQueue removeObject:operation];
    }];
    
    [_imgDownloadQueue addObject:op];
    [op start];
}

- (void)addIncomingOfferWithOfferId:(NSInteger)offerId withOfferStatus:(NSInteger)offerStatus withPrice:(double)price withOfferName:(NSString *)offerName withOfferRate:(NSString *)offerRate{
    
    OfferMediaItem *item = [[OfferMediaItem alloc] initWithOfferId:offerId withOfferStatus:offerStatus withPrice:price withOfferName:offerName withOfferRate:offerRate];
    [item setAppliesMediaViewMaskAsOutgoing:NO];
    JSQMessage *message = [JSQMessage messageWithSenderId:_incomingUserId displayName:_incomingDisplayName media:item];
    [self.messages addObject:message];
}


- (void)addVideoMediaMessage
{
    NSURL *videoURL = [NSURL URLWithString:@"file://"];
    JSQVideoMediaItem *item = [[JSQVideoMediaItem alloc] initWithFileURL:videoURL isReadyToPlay:YES];
    [self.messages addObject:[JSQMessage messageWithSenderId:_outgoingUserId displayName:_outgoingDisplayName media:item]];
}
                                
- (void)addAudioMediaMessageWithURL:(NSString *)audioURL withAudioDuration:(NSInteger)duration{
    
    NSURL *audioUrl = [NSURL URLWithString:audioURL];
    AudioMediaItem *item = [[AudioMediaItem alloc] initWithFileURL:audioUrl Duration:[NSNumber numberWithInteger:duration]];
    JSQMessage *message = [JSQMessage messageWithSenderId:_outgoingUserId displayName:_outgoingDisplayName media:item];
    [self.messages addObject:message];
}

- (void)addIncomingAudioMediaMessage:(NSString *)audioURL{
    
    NSURL *audioUrl = [NSURL URLWithString:audioURL];
    
    AudioMediaItem *item = [[AudioMediaItem alloc] initWithFileURL:audioUrl Duration:[NSNumber numberWithInteger:0]];
    [item setAppliesMediaViewMaskAsOutgoing:NO];
    JSQMessage *message = [JSQMessage messageWithSenderId:_incomingUserId displayName:_incomingDisplayName media:item];
    [self.messages addObject:message];
    
}
                                
- (void)addincomingAcceptOffer:(NSString *)htmlString{

    AcceptOfferMediaItem *item = [[AcceptOfferMediaItem alloc] initWithHtmlString:htmlString];
    [item setAppliesMediaViewMaskAsOutgoing:NO];
    JSQMessage *message = [JSQMessage messageWithSenderId:_incomingUserId displayName:_incomingDisplayName media:item];
    [self.messages addObject:message];
}

- (void)addincomingFile:(NSString *)fileURL{
    
    FileMediaItem *item = [[FileMediaItem alloc] initWithFileURLString:fileURL];
    [item setAppliesMediaViewMaskAsOutgoing:NO];
    JSQMessage *message = [JSQMessage messageWithSenderId:_incomingUserId displayName:_incomingDisplayName media:item];
    [self.messages addObject:message];
}

@end
