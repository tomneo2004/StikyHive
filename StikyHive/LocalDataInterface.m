//
//  LocalDataInterface.m
//  StikyHive
//
//  Created by Koh Quee Boon on 7/5/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "LocalDataInterface.h"
#import "JSQMessage.h"

@implementation LocalDataInterface

//////  ECHO ///////////////
//+ (void)storeUserStatus:(NSInteger *)status
//{
//    [self storeInteger:status forKey:KEY_USER_STATUS];
//}
//
//+ (NSInteger *)retrieveUserStatus
//{
//    return [self retrieveIntegerForKey:KEY_USER_STATUS];
//}

+ (void)storeUserInfo:(UserInfo *)userInfo
{
    [self storeObject:userInfo forKey:KEY_USER_INFO];
}


+ (UserInfo *)retrieveUserInfo
{
    return (UserInfo *)[self retrieveObjectForKey:KEY_USER_INFO];
}


+ (void)storeProfileImage:(UIImage *)image
{
    [self storeImage:image forKey:KEY_IMAGE];
}

+ (UIImage *)retrieveProfileImage {
    return [self retrieveImageForKey:KEY_IMAGE];
}

+ (void)storeStkid:(NSString *)stkid
{
    [self storeString:stkid forKey:KEY_STKID];
}

+ (NSString *)retrieveStkid
{
    return [self retrieveStringForKey:KEY_STKID];
}

+ (void)storeNameOfUser:(NSString *)name
{
    [self storeString:name forKey:KEY_NAME];
}
+ (NSString *)retrieveNameOfUser
{
    return [self retrieveStringForKey:KEY_NAME];
}

////////////////////////////////////

+ (void)removeAllKeys
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

+ (void)storeCreatedSkill:(Skill *)skill
{
    [self storeObject:skill forKey:KEY_CREATED_SKILL];
}

+ (void)storePaymentInfo:(NSDictionary *)info
{
    [self storeDictionary:info forKey:KEY_PAYMENT_INFO];
}

+ (void)storeSubscriptionEnabled:(BOOL) boolean
{
    [self storeBoolean:boolean forKey:KEY_SUBSCRIPTION_ENABLED];
}

+ (void)storeAdd4PhotoEnabled:(BOOL) boolean
{
    [self storeBoolean:boolean forKey:KEY_ADD_4_PHOTO_ENABLED];
}

+ (void)storeAddVideoEnabled:(BOOL) boolean
{
    [self storeBoolean:boolean forKey:KEY_ADD_VIDEO_ENABLED];
}

+ (void)storeExtendedVideoEnabled:(BOOL) boolean
{
    [self storeBoolean:boolean forKey:KEY_EXTENDED_VIDEO_ENABLED];
}

+ (void)storeMoreForLessEnabled:(BOOL) boolean
{
    [self storeBoolean:boolean forKey:KEY_MORE_FOR_LESS_ENABLED];
}

+ (void)storePriorityFeatureEnabled:(BOOL) boolean
{
    [self storeBoolean:boolean forKey:KEY_PRIORITY_FEATURE_ENABLED];
}

+ (void)storeAllCountry:(NSArray *)countries
{
    [self storeArray:countries forKey:KEY_ALL_COUNTRY];
}

+ (void)storeUserID:(NSString *)userID
{
    [self storeString:userID forKey:KEY_USER_ID];
}

+ (void)storeUsername:(NSString *)username
{
    [self storeString:username forKey:KEY_USERNAME];
}

+ (void)storePassword:(NSString *)password
{
    [self storeString:password forKey:KEY_PASSWORD];
}

+ (void)storeDeviceToken:(NSString *)token
{
    [self storeString:token forKey:KEY_DEVICE_TOKEN];
}

+ (void)storeUserData:(NSDictionary *)userData
{
    [self storeDictionary:userData forKey:KEY_USER_DATA];
}

//+ (void)storeUserInfo:(UserInfo *)userInfo
//{
//    [self storeObject:userInfo forKey:KEY_USER_INFO];
//}

+ (void)storeContacts:(NSArray *)contacts
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (NSDictionary *contact in contacts)
        dict[contact[@"stkid"]] = contact;
    [self storeObject:[dict copy] forKey:KEY_USER_CONTACTS];
}

+ (void)storeImage:(UIImage *)image atIndex:(NSInteger)index
{
    NSArray *keys = @[KEY_IMAGE_1,KEY_IMAGE_2,KEY_IMAGE_3,KEY_IMAGE_4,
                      KEY_IMAGE_5,KEY_IMAGE_6,KEY_IMAGE_7,KEY_IMAGE_8];
    [self storeImage:image forKey:keys[index]];
}

+ (void)storeVideo1:(NSData *)data
{
    [self storeData:data ForKey:KEY_VIDEO_1];
}

+ (void)storeVideo2:(NSData *)data
{
    [self storeData:data ForKey:KEY_VIDEO_2];
}

+ (void)storeVideoThumb1:(NSData *)data
{
    [self storeData:data ForKey:KEY_VIDEO_THUMB_1];
}

+ (void)storeVideoThumb2:(NSData *)data
{
    [self storeData:data ForKey:KEY_VIDEO_THUMB_2];
}

+ (void)storeProfessionalSkillCategories:(NSArray *)categories
{
    [self storeArray:categories forKey:KEY_PROFESSIONAL_SKILL_CATEGORY];
}

+ (void)storeRawTalentCategories:(NSArray *)categories
{
    [self storeArray:categories forKey:KEY_RAW_TALENT_CATEGORY];
}

+ (void)storeMessage:(JSQMessage *)jsqMessage forChatStarter:(NSString *)contactID
{
    NSDictionary *apsDict = (NSDictionary *)[self retrieveObjectForKey:KEY_APS_MESSAGES];
    NSArray *senderArray = (NSArray *)[self retrieveObjectForKey:KEY_APS_SENDERS];
    
    if (apsDict && senderArray)
    {
        NSMutableDictionary *tempDict = apsDict.mutableCopy;
        NSArray *messageArray = apsDict[contactID];
        
        if (messageArray)
        {
            NSMutableArray *tempArray = messageArray.mutableCopy;
            [tempArray addObject:jsqMessage];
            tempDict[contactID] = tempArray.copy;
        }
        else
        {
            tempDict[contactID] = @[jsqMessage];
        }
        apsDict = tempDict.copy;
        
        NSMutableArray *tempSenderArray = senderArray.mutableCopy;
        NSUInteger senderIndex = [senderArray indexOfObject:contactID];
        
        // Move the sender to the top, to keep track of latest message
        if (senderIndex != NSNotFound)
            [tempSenderArray removeObjectAtIndex:senderIndex];
        [tempSenderArray insertObject:contactID atIndex:0];
        
        senderArray = tempSenderArray.copy;
    }
    else
    {
        apsDict = @{contactID : @[jsqMessage]};
        senderArray = @[contactID];
    }
    
    [self storeObject:apsDict forKey:KEY_APS_MESSAGES];
    [self storeObject:senderArray forKey:KEY_APS_SENDERS];
    
    // Track the number of unread message so as to set the badge of chat button
    NSMutableDictionary *unreadDict = [self retrieveDictionaryForKey:KEY_UNREAD_NOTIFICATION_COUNT_FOR_USER].mutableCopy;
    unreadDict = unreadDict ? unreadDict : @{}.mutableCopy;
    NSNumber *unreadNum = unreadDict[contactID];
    NSInteger unreadInt = unreadNum ? unreadNum.integerValue + 1 : 1;
    unreadDict[contactID] = [NSNumber numberWithInteger:unreadInt];
    [self storeDictionary:unreadDict.copy forKey:KEY_UNREAD_NOTIFICATION_COUNT_FOR_USER];
}

+ (void)storeDocument:(Document *)document
{
    NSDictionary *docDict = (NSDictionary *)[self retrieveObjectForKey:KEY_DOCUMENTS];
    
    if (docDict)
    {
        NSMutableDictionary *tempDict = docDict.mutableCopy;
        tempDict[document.filePath] = document;
        docDict = tempDict.copy;
    }
    else
    {
        docDict = @{document.filePath:document};
    }
    [self storeObject:docDict forKey:KEY_DOCUMENTS];
}

+ (void)removeDocument:(NSString *)documentPath
{
    NSDictionary *docDict = (NSDictionary *)[self retrieveObjectForKey:KEY_DOCUMENTS];
    
    if (docDict)
    {
        NSMutableDictionary *tempDict = docDict.mutableCopy;
        [tempDict removeObjectForKey:documentPath];
        [self storeObject:tempDict.copy forKey:KEY_DOCUMENTS];
    }
}

+ (NSDictionary *)retrieveDocuments
{
    NSDictionary *files = (NSDictionary *)[self retrieveObjectForKey:KEY_DOCUMENTS];
    return files ? files : @{};
}

// Storage for professional skills only.
+ (void)storeAllPhotoForProfSkill:(NSArray *)result
{
    NSMutableDictionary *tempDict = [@{} mutableCopy];
    for (NSDictionary *dict in result)
    {        
        if (dict && !([dict[@"professionalId"] isKindOfClass:[NSNull class]]))
        {
            NSString *profIDStr = dict[@"professionalId"];
            profIDStr = [profIDStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            tempDict[profIDStr] = dict;
        }
    }
    [self storeDictionary:tempDict.copy forKey:KEY_PHOTO_ALL_PROF_SKILL];
}

+ (Skill *)retrieveCreatedSkill
{
    return (Skill *)[self retrieveObjectForKey:KEY_CREATED_SKILL];
}

+ (NSDictionary *)retrievePaymentInfo
{
    return [self retrieveDictionaryForKey:KEY_PAYMENT_INFO];
}

+ (BOOL)retrieveSubscriptionEnabled
{
    return [self retrieveBoolForKey:KEY_SUBSCRIPTION_ENABLED];
}

+ (BOOL)retrieveAdd4PhotoEnabled
{
    return [self retrieveBoolForKey:KEY_ADD_4_PHOTO_ENABLED];
}

+ (BOOL)retrieveAddVideoEnabled
{
    return [self retrieveBoolForKey:KEY_ADD_VIDEO_ENABLED];
}

+ (BOOL)retrieveExtendedVideoEnabled
{
    return [self retrieveBoolForKey:KEY_EXTENDED_VIDEO_ENABLED];
}

+ (BOOL)retrieveMoreForLessEnabled
{
    return [self retrieveBoolForKey:KEY_MORE_FOR_LESS_ENABLED];
}

+ (BOOL)retrievePriorityFeatureEnabled
{
    return [self retrieveBoolForKey:KEY_PRIORITY_FEATURE_ENABLED];
}

+ (NSArray *)retrieveAllCountry
{
    return [self retrieveArrayForKey:KEY_ALL_COUNTRY];
}

+ (NSString *)retrieveUserID
{
    return [self retrieveStringForKey:KEY_USER_ID];
}

+ (NSString *)retrieveUsername
{
    return [self retrieveStringForKey:KEY_USERNAME];
}

+ (NSString *)retrievePassword
{
    return [self retrieveStringForKey:KEY_PASSWORD];
}

+ (NSString *)retrieveDeviceToken
{
    return [self retrieveStringForKey:KEY_DEVICE_TOKEN];
}

+ (NSDictionary *)retrieveUserData
{
    return (NSDictionary *)[self retrieveDictionaryForKey:KEY_USER_DATA];
}

//+ (UserInfo *)retrieveUserInfo
//{
//    return (UserInfo *)[self retrieveObjectForKey:KEY_USER_INFO];
//}

+ (NSDictionary *)retrieveContacts
{
    return (NSDictionary *)[self retrieveObjectForKey:KEY_USER_CONTACTS];
}

+ (NSData *)retrieveVideo1
{
    return [self retrieveDataForKey:KEY_VIDEO_1];
}

+ (NSData *)retrieveVideo2
{
    return [self retrieveDataForKey:KEY_VIDEO_2];
}

+ (NSData *)retrieveVideoThumb1
{
    return [self retrieveDataForKey:KEY_VIDEO_THUMB_1];
}

+ (NSData *)retrieveVideoThumb2
{
    return [self retrieveDataForKey:KEY_VIDEO_THUMB_2];
}

+ (UIImage *)retrieveImageAtIndex:(NSInteger)index
{
    NSArray *keys = @[KEY_IMAGE_1,KEY_IMAGE_2,KEY_IMAGE_3,KEY_IMAGE_4,
                      KEY_IMAGE_5,KEY_IMAGE_6,KEY_IMAGE_7,KEY_IMAGE_8];
    return [self retrieveImageForKey:keys[index]];
}

+ (NSArray *)retrieveProfessionalSkillCategories
{
    return [self retrieveArrayForKey:KEY_PROFESSIONAL_SKILL_CATEGORY];
}

+ (NSArray *)retrieveRawTalentCategories
{
    return [self retrieveArrayForKey:KEY_RAW_TALENT_CATEGORY];
}

+ (NSDictionary *)retrieveAllMessages
{
    return (NSDictionary *)[self retrieveObjectForKey:KEY_APS_MESSAGES];
}

+ (NSArray *)retrieveAllSenders
{
    return (NSArray *)[self retrieveObjectForKey:KEY_APS_SENDERS];
}

+ (NSDictionary *)retrieveAllPhotoForProfSkill
{
    return [self retrieveDictionaryForKey:KEY_PHOTO_ALL_PROF_SKILL];
}

+ (NSDictionary *)retrieveUnreadMessageCountDict
{
   return [self retrieveDictionaryForKey:KEY_UNREAD_NOTIFICATION_COUNT_FOR_USER];
}

+ (NSInteger)resetUnreadMessageCountForUser:(NSString *)userID
{
    NSMutableDictionary *dict = [self retrieveDictionaryForKey:KEY_UNREAD_NOTIFICATION_COUNT_FOR_USER].mutableCopy;
    NSNumber *countNum = dict[userID];
    dict[userID] = [NSNumber numberWithInteger:0];
    [self storeDictionary:dict.copy forKey:KEY_UNREAD_NOTIFICATION_COUNT_FOR_USER];

    if (countNum)
        return countNum.integerValue;
    else
        return 0;
}

+ (NSArray *)retrieveMessagesFromUser:(NSString *)userID;
{
    NSDictionary *apsDict = (NSDictionary *)[self retrieveObjectForKey:KEY_APS_MESSAGES];
    return apsDict ? apsDict[userID] : @[];
}

+ (UserInfo *)getUserFromID:(NSString *)userID
{
    NSDictionary *contacts = [self retrieveContacts];    
    if (contacts && contacts[userID])
    {
        NSDictionary *dict = contacts[userID];
        UserInfo *info = [[UserInfo alloc] init];
        info.firstName = dict[@"firstname"];
        info.lastName = dict[@"lastname"];
        info.email = dict[@"email"];
        info.profilePicture = dict[@"profilePicture"];
        return info;
    }
    else
    {
        return nil;
    }
}

+ (void)incrementNewNotificationCount
{
    NSInteger count = [self obtainNewNotificationCount]+1;
    [self storeInteger:count forKey:KEY_NEW_NOTIFICATION_COUNT];
}

+ (void)decrementNewNotificationCount
{
    NSInteger count = [self obtainNewNotificationCount]-1;
    [self storeInteger:MAX(count,0) forKey:KEY_NEW_NOTIFICATION_COUNT];
}

+ (void)resetNewNotificationCount
{
    [self storeInteger:0 forKey:KEY_NEW_NOTIFICATION_COUNT];
}

+ (NSInteger)obtainNewNotificationCount
{
    return [self retrieveIntegerForKey:KEY_NEW_NOTIFICATION_COUNT];
}

+ (void)storeInteger:(NSInteger)integer forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:integer forKey:key];
    [defaults synchronize];
}

+ (NSInteger)retrieveIntegerForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:key];
}

+ (void)storeBoolean:(BOOL)boolean forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:boolean forKey:key];
    [defaults synchronize];
}

+ (BOOL)retrieveBoolForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
}

+ (void)storeString:(NSString *)value forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

+ (NSString *)retrieveStringForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

+ (void)storeArray:(NSArray *)array forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:array forKey:key];
    [defaults synchronize];
}

+ (NSArray *)retrieveArrayForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return (NSArray *)[defaults objectForKey:key];
}

+ (void)storeDictionary:(NSDictionary *)dict forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dict forKey:key];
    [defaults synchronize];
}

+ (NSDictionary *)retrieveDictionaryForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return (NSDictionary *)[defaults objectForKey:key];
}

+ (void)storeObject:(NSObject *)obj forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:obj] forKey:key];
    [defaults synchronize];
}

+ (void)storeData:(NSData *)data ForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:key];
    [defaults synchronize];
}

+ (NSObject *)retrieveObjectForKey:(NSString *)key
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return data ? [NSKeyedUnarchiver unarchiveObjectWithData:data] : nil;
}

+ (void)storeImage:(UIImage *)image forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:UIImagePNGRepresentation(image) forKey:key];
}

+ (UIImage *)retrieveImageForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:key];
    return data ? [UIImage imageWithData:data] : nil;
}

+ (NSData *)retrieveDataForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:key];
    return data;
}

@end
