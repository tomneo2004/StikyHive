//
//  PushNotificationDataInterface.h
//  StikyHive
//
//  Created by Koh Quee Boon on 14/5/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSQMessages.h"

#define PUSH_NOTIFICATION_RECEIVED @"push_notification_received"
#define PUSH_DATA_KEY_APS @"aps"
#define PUSH_DATA_KEY_ALERT @"alert"
#define PUSH_DATA_KEY_SENDER @"sender"
#define PUSH_DATA_KEY_BADGE @"badge"

@interface PushNotificationDataInterface : NSObject

+ (void)addMessageObserver:(NSObject *)observer andSelector:(SEL)selector;
+ (void)notifyMessageObservers:(JSQMessage *)jsqMessage;
+ (void)processPendingNotificationForUser:(NSString *)userID;

@end
