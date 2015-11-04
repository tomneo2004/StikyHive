//
//  PushNotificationDataInterface.m
//  StikyHive
//
//  Created by Koh Quee Boon on 14/5/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "PushNotificationDataInterface.h"
#import "ViewControllerUtil.h"
#import "LocalDataInterface.h"
#import "WebDataInterface.h"
#import "Document.h"

@implementation PushNotificationDataInterface

static NSInteger New_Notification_Count = 0;

+ (void)addMessageObserver:(NSObject *)observer andSelector:(SEL)selector
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:observer selector:selector name:PUSH_NOTIFICATION_RECEIVED object:nil];
}

+ (void)notifyMessageObservers:(JSQMessage *)jsqMessage;
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:PUSH_NOTIFICATION_RECEIVED object:jsqMessage userInfo:nil];
}

+ (void)processPendingNotificationForUser:(NSString *)userID
{
    if (userID)
    {
        [WebDataInterface getPendingNotificationForUser:userID completion:^(NSObject *obj, NSError *err)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSArray *notifications = (NSArray *)obj;
                 for (NSDictionary *dict in notifications)
                 {
                     NSString *sender = dict[@"sender"];
                     NSString *message = dict[@"message"];
                     NSNumber *type = dict[@"type"];
                     
                     // For file transfer
                     if (type.integerValue == 4)
                     {
                         [WebDataInterface getDocumentWithID:message.integerValue completion:^(NSObject *obj, NSError *err)
                         {
                             if (obj && [obj isKindOfClass:[NSDictionary class]])
                             {
                                 NSDictionary *docDict = (NSDictionary *)obj;
                                 Document *doc = [[Document alloc] initWithID:message.integerValue ownerID:docDict[@"stkid"]
                                                                     fileName:docDict[@"name"] filePath:docDict[@"location"]];
                                 [LocalDataInterface storeDocument:doc];
                                 [PushNotificationDataInterface notifyMessageObservers:nil];
                             }
                         }];
                         
                     } // For StikyChat with image
                     else if (type.integerValue == 2)
                     {
                         
                         NSString *imagePath = [WebDataInterface getFullStoragePath:message];
                         UIImage *image = [ViewControllerUtil getImageForPath:imagePath];
                         if (!image || image.size.width == 0)
                             [ViewControllerUtil cacheImageForPath:imagePath completion:^(NSObject *obj, NSError *err)
                              {
                              }];
                         
                         image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
                         JSQPhotoMediaItem *photo = [[JSQPhotoMediaItem alloc] initWithImage:image];
                         JSQMessage *photoMessage = [JSQMessage messageWithSenderId:sender displayName:sender media:photo];
                         [LocalDataInterface storeMessage:photoMessage forChatStarter:sender];
                         [PushNotificationDataInterface notifyMessageObservers:photoMessage];
                         
                     } // For StikyChat message and StikyChat voice
                     else if (type.integerValue == 1 || type.integerValue == 3)
                     {
                         JSQMessage *jsqMessage = [JSQMessage messageWithSenderId:sender displayName:sender text:message];
                         [LocalDataInterface storeMessage:jsqMessage forChatStarter:sender];
                         [PushNotificationDataInterface notifyMessageObservers:jsqMessage];
                         
                     }
                 }
             });
         }];
    }
}


@end
