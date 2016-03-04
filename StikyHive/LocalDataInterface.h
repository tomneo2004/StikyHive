//
//  LocalDataInterface.h
//  StikyHive
//
//  Created by Koh Quee Boon on 7/5/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSQMessages.h"
#import "UserInfo.h"
#import "Document.h"
#import "Skill.h"

#define KEY_CREATED_SKILL @"created_skill"

#define KEY_PAYMENT_INFO @"payment_info"
#define PAYMENT_DETAIL_SUBSCRIPTION @"payment_detail_subscription"
#define PAYMENT_DETAIL_ADD_4_PHOTO @"payment_detail_add_4_photo"
#define PAYMENT_DETAIL_ADD_VIDEO @"payment_detail__add_video"
#define PAYMENT_DETAIL_EXTENDED_VIDEO @"payment_detail_extended_video"
#define PAYMENT_DETAIL_MORE_FOR_LESS @"payment_detail_more_for_less"
#define PAYMENT_DETAIL_PRIORITY_FEATURE @"payment_detail_priority_feature"

#define KEY_SUBSCRIPTION_ENABLED @"subscription_enabled"
#define KEY_ADD_4_PHOTO_ENABLED @"add_4_photo_enabled"
#define KEY_ADD_VIDEO_ENABLED @"add_video_enabled"
#define KEY_EXTENDED_VIDEO_ENABLED @"extended_video_enabled"
#define KEY_MORE_FOR_LESS_ENABLED @"more_for_less_enabled"
#define KEY_PRIORITY_FEATURE_ENABLED @"priority_feature_enabled"

#define KEY_ALL_COUNTRY @"all_country"
#define KEY_USER_ID @"user_id"
#define KEY_USERNAME @"username"
#define KEY_PASSWORD @"password"

#define KEY_VIDEO_1 @"skill_video_1"
#define KEY_VIDEO_2 @"skill_video_2"
#define KEY_VIDEO_THUMB_1 @"video_thumb_1"
#define KEY_VIDEO_THUMB_2 @"video_thumb_2"

#define KEY_IMAGE_1 @"image_1"
#define KEY_IMAGE_2 @"image_2"
#define KEY_IMAGE_3 @"image_3"
#define KEY_IMAGE_4 @"image_4"
#define KEY_IMAGE_5 @"image_5"
#define KEY_IMAGE_6 @"image_6"
#define KEY_IMAGE_7 @"image_7"
#define KEY_IMAGE_8 @"image_8"

#define KEY_USER_INFO @"user_info"
#define KEY_USER_DATA @"user_data"
#define KEY_USER_CONTACTS @"contacts"
#define KEY_DOCUMENTS @"received_documents"
#define KEY_APS_SENDERS @"aps_senders"
#define KEY_APS_MESSAGES @"aps_messages"
#define KEY_DEVICE_TOKEN @"device_token"
#define KEY_PROFESSIONAL_SKILL_CATEGORY @"professional_skill_category"
#define KEY_RAW_TALENT_CATEGORY @"raw_talent_category"

#define KEY_PHOTO_ALL_PROF_SKILL @"photo_all_pref_skill"
#define KEY_PHOTO_ALL_RAW_TALENT @"photo_all_raw_talent"

#define KEY_ALL_USER_PROFILE_PHOTO @"all_user_profile_photo"

#define KEY_NEW_NOTIFICATION_COUNT @"new_notification_count"
#define KEY_UNREAD_NOTIFICATION_COUNT_FOR_USER @"unread_notification_count_for_user"

///////
#define KEY_USER_STATUS @"status"
#define KEY_IMAGE  @"image"
#define KEY_STKID  @"stkid"
#define KEY_NAME   @"name"

#define KEY_URL    @"url"

@interface LocalDataInterface : NSObject

///////
//+ (void)storeUserStatus:(NSInteger *)status;
//+ (NSInteger *)retrieveUserStatus;

+ (void)storeUserInfo:(UserInfo *)userInfo;
+ (UserInfo *)retrieveUserInfo;

+ (void)storeProfileImage:(UIImage *)image;
+ (UIImage *)retrieveProfileImage;

+ (void)storeStkid:(NSString *)stkid;
+ (NSString *)retrieveStkid;

+ (void)storeNameOfUser:(NSString *)name;
+ (NSString *)retrieveNameOfUser;


+ (void)storeProfileUrl:(NSString *)url;
+ (NSString *)retrieveProfileUrl;

//////////


+ (void)removeAllKeys;

+ (void)storeCreatedSkill:(Skill *)skill;

+ (void)storePaymentInfo:(NSDictionary *)items;
+ (void)storeSubscriptionEnabled:(BOOL) boolean;
+ (void)storeAdd4PhotoEnabled:(BOOL) boolean;
+ (void)storeAddVideoEnabled:(BOOL) boolean;
+ (void)storeExtendedVideoEnabled:(BOOL) boolean;
+ (void)storeMoreForLessEnabled:(BOOL) boolean;
+ (void)storePriorityFeatureEnabled:(BOOL) boolean;

+ (void)storeAllCountry:(NSArray *)countries;
+ (void)storeUserID:(NSString *)userID;
+ (void)storeUsername:(NSString *)username;
+ (void)storePassword:(NSString *)password;
+ (void)storeDeviceToken:(NSString *)token;
+ (void)storeUserData:(NSDictionary *)userData;
//+ (void)storeUserInfo:(UserInfo *)userInfo;
+ (void)storeContacts:(NSArray *)contacts;
+ (void)storeProfessionalSkillCategories:(NSArray *)categories;
+ (void)storeRawTalentCategories:(NSArray *)categories;

+ (void)storeVideo1:(NSData *)data;
+ (void)storeVideo2:(NSData *)data;
+ (void)storeVideoThumb1:(NSData *)data;
+ (void)storeVideoThumb2:(NSData *)data;

+ (void)storeImage:(UIImage *)image atIndex:(NSInteger)index;

+ (void)storeMessage:(JSQMessage *)jsqMessage forChatStarter:(NSString *)contactID;

+ (void)storeDocument:(Document *)document;
+ (void)removeDocument:(Document *)document;
+ (NSDictionary *)retrieveDocuments;

+ (void)storeObject:(NSObject *)obj forKey:(NSString *)key;

+ (Skill *)retrieveCreatedSkill;

+ (NSDictionary *)retrievePaymentInfo;

+ (BOOL)retrieveSubscriptionEnabled;
+ (BOOL)retrieveAdd4PhotoEnabled;
+ (BOOL)retrieveAddVideoEnabled;
+ (BOOL)retrieveExtendedVideoEnabled;
+ (BOOL)retrieveMoreForLessEnabled;
+ (BOOL)retrievePriorityFeatureEnabled;

+ (NSArray *)retrieveAllCountry;
+ (NSString *)retrieveUserID;
+ (NSString *)retrieveUsername;
+ (NSString *)retrievePassword;
+ (NSString *)retrieveDeviceToken;
+ (NSDictionary *)retrieveUserData;
//+ (UserInfo *)retrieveUserInfo;
+ (NSDictionary *)retrieveContacts;
+ (NSArray *)retrieveProfessionalSkillCategories;
+ (NSArray *)retrieveRawTalentCategories;

+ (NSData *)retrieveVideo1;
+ (NSData *)retrieveVideo2;
+ (NSData *)retrieveVideoThumb1;
+ (NSData *)retrieveVideoThumb2;

+ (UIImage *)retrieveImageAtIndex:(NSInteger)index;

+ (NSObject *)retrieveObjectForKey:(NSString *)key;

+ (NSDictionary *)retrieveUnreadMessageCountDict;
+ (NSInteger)resetUnreadMessageCountForUser:(NSString *)userID;
+ (NSDictionary *)retrieveAllMessages;
+ (NSArray *)retrieveAllSenders;

+ (NSDictionary *)retrieveAllPhotoForProfSkill;     // Dynamic

+ (NSArray *)retrieveMessagesFromUser:(NSString *)userID;
+ (UserInfo *)getUserFromID:(NSString *)userID;

+ (void)incrementNewNotificationCount;
+ (void)decrementNewNotificationCount;
+ (void)resetNewNotificationCount;
+ (NSInteger)obtainNewNotificationCount;

@end
