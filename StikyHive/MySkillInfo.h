//
//  MySkillInfo.h
//  StikyHive
//
//  Created by User on 17/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySkillInfo : NSObject

@property (copy, readonly, nonatomic) NSString *subId;
@property (assign, readonly, nonatomic) NSInteger status;
@property (assign, readonly, nonatomic) double price;
@property (copy, readonly, nonatomic) NSString *originalExpiredDate;
@property (readonly, nonatomic) NSDate *expiredDate;
@property (copy, readonly, nonatomic) NSString *originalIssuedDate;
@property (readonly, nonatomic) NSDate *issueDate;
@property (copy, readonly, nonatomic) NSString *skillId;
@property (copy, readonly, nonatomic) NSString *photoId;
@property (copy, readonly, nonatomic) NSString *location;
@property (copy, readonly, nonatomic) NSString *caption;
@property (copy, readonly, nonatomic) NSString *videoId;
@property (copy, readonly, nonatomic) NSString *videoLocation;
@property (copy, readonly, nonatomic) NSString *thumbnailLocation;
@property (copy, readonly, nonatomic) NSString *stkId;
@property (assign, readonly, nonatomic) NSInteger catId;
@property (copy, readonly, nonatomic) NSString *name;
@property (copy, readonly, nonatomic) NSString *skillDesc;
@property (copy, readonly, nonatomic) NSString *summary;
@property (assign, readonly, nonatomic) NSInteger type;
@property (copy, readonly, nonatomic) NSString *firstname;
@property (copy, readonly, nonatomic) NSString *lastname;
@property (copy, readonly, nonatomic) NSString *profilePicture;
@property (copy, readonly, nonatomic) NSString *email;
@property (copy, readonly, nonatomic) NSString *beeInfo;
@property (copy, readonly, nonatomic) NSString *ratename;
@property (assign, readonly, nonatomic) NSInteger likeCount;
@property (assign, readonly, nonatomic) NSInteger reviewCount;
@property (assign, readonly, nonatomic) NSInteger rating;
@property (assign, readonly, nonatomic) NSInteger likeId;
@property (assign, readonly, nonatomic) NSInteger countOfLikeId;

+ (id)createMySkillInfoFromDictionary:(NSDictionary *)dic;

@end
