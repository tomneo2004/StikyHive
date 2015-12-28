//
//  MyPostInfo.h
//  StikyHive
//
//  Created by User on 23/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPostInfo : NSObject

@property (copy, readonly, nonatomic) NSString *postId;
@property (copy, readonly, nonatomic) NSString *stkId;
@property (assign, readonly, nonatomic) NSInteger type;
@property (copy, readonly, nonatomic) NSString *name;
@property (copy, readonly, nonatomic) NSString *desc;
@property (copy, readonly, nonatomic) NSString *originalExpiredDate;
@property (readonly, nonatomic) NSDate *expiredDate;
@property (copy, readonly, nonatomic) NSString *originalUpdateDate;
@property (readonly, nonatomic) NSDate *updateDate;
@property (copy, readonly, nonatomic) NSString *originalIssuedDate;
@property (readonly, nonatomic) NSDate *issueDate;
@property (assign, readonly, nonatomic) NSInteger status;
@property (assign, readonly, nonatomic) NSInteger catId;
@property (assign, readonly, nonatomic) NSInteger personType;
@property (assign, readonly, nonatomic) NSInteger availability;
@property (assign, readonly, nonatomic) NSInteger active;
@property (assign, readonly, nonatomic) NSInteger jobType;
@property (copy, readonly, nonatomic) NSString *responsibilities;
@property (copy, readonly, nonatomic) NSString *originalStartTime;
@property (readonly, nonatomic) NSDate *startTime;
@property (copy, readonly, nonatomic) NSString *originalEndTime;
@property (readonly, nonatomic) NSDate *endTime;
@property (copy, readonly, nonatomic)  NSString *price;
@property (assign, readonly, nonatomic) NSInteger rateId;
@property (copy, readonly, nonatomic) NSString *rate;
@property (copy, readonly, nonatomic) NSString *location;
@property (copy, readonly, nonatomic) NSString *rateName;

+ (id)createMyPostInfoFromDictionary:(NSDictionary *)dic;


@end
