//
//  ChatData.m
//  StikyHive
//
//  Created by THV1WP15S on 25/1/16.
//  Copyright (c) 2016 Stiky Hive. All rights reserved.
//

#import "ChatData.h"

@implementation ChatData




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
