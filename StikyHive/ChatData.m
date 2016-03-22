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

- (void)processEarlyIncommingMessage:(NSDictionary *)dic{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    
    if([dic[@"fileName"] isEqual:[NSNull null]] && ![dic[@"message"] isEqual:[NSNull null]] && [dic[@"name"] isEqual:[NSNull null]] && ![dic[@"message"] isEqual:[NSNull null]] && [dic[@"message"] rangeOfString:@"<span"].location==NSNotFound){//text
        
        NSDate *date  = [dic[@"createDate"] isEqual:[NSNull null]]? [NSDate date] : [dateFormatter dateFromString:dic[@"createDate"]];
        JSQMessage *textMsg = [[JSQMessage alloc] initWithSenderId:_incomingUserId senderDisplayName:_incomingDisplayName date:date text:dic[@"message"]];
        
        [self.messages insertObject:textMsg atIndex:0];
    }
    else if([dic[@"fileName"] isEqual:[NSNull null]] && [dic[@"message"] isEqual:[NSNull null]] && ![dic[@"name"] isEqual:[NSNull null]]){//make offer
        
        OfferMediaItem *item = [[OfferMediaItem alloc] initWithOfferId:[dic[@"offerId"] integerValue] withOfferStatus:[dic[@"offerStatus"] integerValue] withPrice:[dic[@"price"] doubleValue] withOfferName:dic[@"name"] withOfferRate:dic[@"rate"]];
        [item setAppliesMediaViewMaskAsOutgoing:NO];
        
        NSDate *date  = [dic[@"createDate"] isEqual:[NSNull null]]? [NSDate date] : [dateFormatter dateFromString:dic[@"createDate"]];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:_incomingUserId senderDisplayName:_incomingDisplayName date:date media:item];
        //JSQMessage *message = [JSQMessage messageWithSenderId:_incomingUserId displayName:_incomingDisplayName media:item];
        [self.messages insertObject:message atIndex:0];
    }
    else if([dic[@"fileName"] isEqual:[NSNull null]] && [dic[@"name"] isEqual:[NSNull null]] && ![dic[@"message"] isEqual:[NSNull null]] && [dic[@"message"] rangeOfString:@"Accepted offer."].location!=NSNotFound){//accept offer
        
        AcceptOfferMediaItem *item = [[AcceptOfferMediaItem alloc] initWithHtmlString:dic[@"message"]];
        [item setAppliesMediaViewMaskAsOutgoing:NO];
        
        NSDate *date  = [dic[@"createDate"] isEqual:[NSNull null]]? [NSDate date] : [dateFormatter dateFromString:dic[@"createDate"]];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:_incomingUserId senderDisplayName:_incomingDisplayName date:date media:item];
        //JSQMessage *message = [JSQMessage messageWithSenderId:_incomingUserId displayName:_incomingDisplayName media:item];
        [self.messages insertObject:message atIndex:0];
    }
    else if([dic[@"fileName"] isEqual:[NSNull null]] && [dic[@"name"] isEqual:[NSNull null]] && ![dic[@"message"] isEqual:[NSNull null]] && [dic[@"message"] rangeOfString:@"Rejected offer."].location!=NSNotFound){//reject offer
        
        NSDate *date  = [dic[@"createDate"] isEqual:[NSNull null]]? [NSDate date] : [dateFormatter dateFromString:dic[@"createDate"]];
        JSQMessage *rejectMsg = [[JSQMessage alloc] initWithSenderId:_incomingUserId senderDisplayName:_incomingDisplayName date:date text:dic[@"message"]];
        
        [self.messages insertObject:rejectMsg atIndex:0];
    }
    else if(![dic[@"fileName"] isEqual:[NSNull null]] && [dic[@"fileName"] rangeOfString:@"fileTransfer"].location!=NSNotFound){//file transfer
        
        FileMediaItem *item = [[FileMediaItem alloc] initWithFileURLString:dic[@"fileName"]];
        [item setAppliesMediaViewMaskAsOutgoing:NO];
        
        NSDate *date  = [dic[@"createDate"] isEqual:[NSNull null]]? [NSDate date] : [dateFormatter dateFromString:dic[@"createDate"]];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:_incomingUserId senderDisplayName:_incomingDisplayName date:date media:item];
        //JSQMessage *message = [JSQMessage messageWithSenderId:_incomingUserId displayName:_incomingDisplayName media:item];
        [self.messages insertObject:message atIndex:0];
    }
    else if(![dic[@"fileName"] isEqual:[NSNull null]] && [dic[@"fileName"] rangeOfString:@"imageTransfer"].location!=NSNotFound){//file image
        
        JSQPhotoMediaItem *photo = [[JSQPhotoMediaItem alloc] initWithImage:nil];
        [photo setAppliesMediaViewMaskAsOutgoing:NO];
        
        NSDate *date  = [dic[@"createDate"] isEqual:[NSNull null]]? [NSDate date] : [dateFormatter dateFromString:dic[@"createDate"]];
        JSQMessage *photoMessage = [[JSQMessage alloc] initWithSenderId:_incomingUserId senderDisplayName:_incomingDisplayName date:date media:photo];
        //JSQMessage *photoMessage = [JSQMessage messageWithSenderId:_incomingUserId displayName:_incomingDisplayName media:photo];
        [self.messages insertObject:photoMessage atIndex:0];
        
        [self startDownloadImageWithPhotoItem:photo WithURL:[WebDataInterface getFullUrlPath:dic[@"fileName"]]];
    }
    else if(![dic[@"fileName"] isEqual:[NSNull null]] && [dic[@"fileName"] rangeOfString:@"voiceTransfer"].location!=NSNotFound){//audio
        
        AudioMediaItem *item = [[AudioMediaItem alloc] initWithFileURL:[NSURL URLWithString:[WebDataInterface getFullUrlPath:dic[@"fileName"]]] Duration:[NSNumber numberWithInteger:0]];
        [item setAppliesMediaViewMaskAsOutgoing:NO];
        
        NSDate *date  = [dic[@"createDate"] isEqual:[NSNull null]]? [NSDate date] : [dateFormatter dateFromString:dic[@"createDate"]];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:_incomingUserId senderDisplayName:_incomingDisplayName date:date media:item];
        //JSQMessage *message = [JSQMessage messageWithSenderId:_incomingUserId displayName:_incomingDisplayName media:item];
        [self.messages insertObject:message atIndex:0];
    }

}

- (void)processEarlyOutgoingMessage:(NSDictionary *)dic{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    
    if([dic[@"fileName"] isEqual:[NSNull null]] && ![dic[@"message"] isEqual:[NSNull null]] && [dic[@"name"] isEqual:[NSNull null]] && ![dic[@"message"] isEqual:[NSNull null]] && [dic[@"message"] rangeOfString:@"<span"].location==NSNotFound){//text
        
        NSDate *date  = [dic[@"createDate"] isEqual:[NSNull null]]? [NSDate date] : [dateFormatter dateFromString:dic[@"createDate"]];
        JSQMessage *textMsg = [[JSQMessage alloc] initWithSenderId:_outgoingUserId senderDisplayName:_outgoingDisplayName date:date text:dic[@"message"]];
        
        [self.messages insertObject:textMsg atIndex:0];
    }
    else if([dic[@"fileName"] isEqual:[NSNull null]] && [dic[@"name"] isEqual:[NSNull null]] && ![dic[@"message"] isEqual:[NSNull null]] && [dic[@"message"] rangeOfString:@"Accepted offer."].location!=NSNotFound){//accept offer
        
        AcceptOfferMediaItem *item = [[AcceptOfferMediaItem alloc] initWithHtmlString:dic[@"message"]];
        [item setAppliesMediaViewMaskAsOutgoing:YES];
        
        NSDate *date  = [dic[@"createDate"] isEqual:[NSNull null]]? [NSDate date] : [dateFormatter dateFromString:dic[@"createDate"]];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:_outgoingUserId senderDisplayName:_outgoingDisplayName date:date media:item];
        //JSQMessage *message = [JSQMessage messageWithSenderId:_outgoingUserId displayName:_outgoingDisplayName media:item];
        [self.messages insertObject:message atIndex:0];
    }
    else if([dic[@"fileName"] isEqual:[NSNull null]] && [dic[@"name"] isEqual:[NSNull null]] && ![dic[@"message"] isEqual:[NSNull null]] && [dic[@"message"] rangeOfString:@"Rejected offer."].location!=NSNotFound){//reject offer
        
        NSDate *date  = [dic[@"createDate"] isEqual:[NSNull null]]? [NSDate date] : [dateFormatter dateFromString:dic[@"createDate"]];
        JSQMessage *rejectMsg = [[JSQMessage alloc] initWithSenderId:_outgoingUserId senderDisplayName:_outgoingDisplayName date:date text:dic[@"message"]];
        
        [self.messages insertObject:rejectMsg atIndex:0];
    }
    else if(![dic[@"fileName"] isEqual:[NSNull null]] && [dic[@"fileName"] rangeOfString:@"fileTransfer"].location!=NSNotFound){//file transfer
        
        FileMediaItem *item = [[FileMediaItem alloc] initWithFileURLString:dic[@"fileName"]];
        [item setAppliesMediaViewMaskAsOutgoing:YES];
        
        NSDate *date  = [dic[@"createDate"] isEqual:[NSNull null]]? [NSDate date] : [dateFormatter dateFromString:dic[@"createDate"]];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:_outgoingUserId senderDisplayName:_outgoingDisplayName date:date media:item];
        //JSQMessage *message = [JSQMessage messageWithSenderId:_outgoingUserId displayName:_outgoingDisplayName media:item];
        [self.messages insertObject:message atIndex:0];
    }
    else if(![dic[@"fileName"] isEqual:[NSNull null]] && [dic[@"fileName"] rangeOfString:@"imageTransfer"].location!=NSNotFound){//file image
        
        JSQPhotoMediaItem *photo = [[JSQPhotoMediaItem alloc] initWithImage:nil];
        [photo setAppliesMediaViewMaskAsOutgoing:YES];
        
        NSDate *date  = [dic[@"createDate"] isEqual:[NSNull null]]? [NSDate date] : [dateFormatter dateFromString:dic[@"createDate"]];
        JSQMessage *photoMessage = [[JSQMessage alloc] initWithSenderId:_outgoingUserId senderDisplayName:_outgoingDisplayName date:date media:photo];
        //JSQMessage *photoMessage = [JSQMessage messageWithSenderId:_outgoingUserId displayName:_outgoingDisplayName media:photo];
        [self.messages insertObject:photoMessage atIndex:0];
        
        [self startDownloadImageWithPhotoItem:photo WithURL:[WebDataInterface getFullUrlPath:dic[@"fileName"]]];
    }
    else if(![dic[@"fileName"] isEqual:[NSNull null]] && [dic[@"fileName"] rangeOfString:@"voiceTransfer"].location!=NSNotFound){//audio
        
        AudioMediaItem *item = [[AudioMediaItem alloc] initWithFileURL:[NSURL URLWithString:[WebDataInterface getFullUrlPath:dic[@"fileName"]]] Duration:[NSNumber numberWithInteger:0]];
        [item setAppliesMediaViewMaskAsOutgoing:YES];
        
        NSDate *date  = [dic[@"createDate"] isEqual:[NSNull null]]? [NSDate date] : [dateFormatter dateFromString:dic[@"createDate"]];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:_outgoingUserId senderDisplayName:_outgoingDisplayName date:date media:item];
        //JSQMessage *message = [JSQMessage messageWithSenderId:_outgoingUserId displayName:_outgoingDisplayName media:item];
        [self.messages insertObject:message atIndex:0];
    }
}

@end
