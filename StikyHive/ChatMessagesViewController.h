//
//  ChatMessagesViewController.h
//  StikyHive
//
//  Created by THV1WP15S on 25/1/16.
//  Copyright (c) 2016 Stiky Hive. All rights reserved.
//

#import "JSQMessagesViewController.h"

#import "JSQMessages.h"
#import "ChatData.h"


@interface ChatMessagesViewController : JSQMessagesViewController


@property (strong, nonatomic) ChatData *chatData;


- (void)closePressed:(UIBarButtonItem *)sender;



+ (void)setToStikyBee:(NSString *)toStikyBee;


@end
