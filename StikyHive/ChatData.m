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
        
        
        UserInfo *userInfo = [LocalDataInterface getUserFromID:outID];
        NSString *imagePath = [WebDataInterface getFullUrlPath:userInfo.profilePicture];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
        UIImage *myImage = [UIImage imageWithData:imageData];
        myImage = myImage ? myImage : [UIImage imageNamed:@"Default_profile_small@2x"];
        _outgoingAvatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:myImage diameter:diameter];

        
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        _outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        
        UIColor *yellow = [UIColor colorWithRed:1.0 green:0.9 blue:0.0 alpha:1.0];
        _incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:yellow];
        
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


- (void)addVideoMediaMessage
{
    NSURL *videoURL = [NSURL URLWithString:@"file://"];
    JSQVideoMediaItem *item = [[JSQVideoMediaItem alloc] initWithFileURL:videoURL isReadyToPlay:YES];
    [self.messages addObject:[JSQMessage messageWithSenderId:_outgoingUserId displayName:_outgoingDisplayName media:item]];
}
                                
                                
                                

@end
