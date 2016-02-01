//
//  ChatData.h
//  StikyHive
//
//  Created by THV1WP15S on 25/1/16.
//  Copyright (c) 2016 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JSQMessages.h"

@interface ChatData : NSObject


@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingAvatar;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingAvatar;

@property (strong, nonatomic) NSString *incomingUserId;
@property (strong, nonatomic) NSString *outgoingUserId;

@property (strong, nonatomic) NSString *incomingDisplayName;
@property (strong, nonatomic) NSString *outgoingDisplayName;




- (JSQMessage *)addPhotoMessage:(UIImage *)image;

- (void)addVideoMediaMessage;

@end
