//
//  SubInfo.h
//  StikyHive
//
//  Created by User on 3/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubInfo : NSObject

@property (copy, readonly, nonatomic) NSString *subId;
@property (assign, readonly, nonatomic) NSInteger subPlanId;
@property (assign, readonly, nonatomic) NSInteger catId;
@property (copy, readonly, nonatomic) NSString *skillName;
@property (copy, readonly, nonatomic) NSString *summary;
@property (copy, readonly, nonatomic) NSString *skillDesc;
@property (assign, readonly, nonatomic) NSInteger type;
@property (assign, readonly, nonatomic) NSInteger status;
@property (assign, readonly, nonatomic) NSInteger rateId;
@property (copy, readonly, nonatomic) NSString *rate;
@property (assign, readonly, nonatomic) double price;
@property (assign, readonly, nonatomic) NSInteger duration;
@property (assign, readonly, nonatomic) double total;
@property (copy, readonly, nonatomic) NSString *originalIssueDate;
@property (readonly, nonatomic) NSDate *issueDate;
@property (copy, readonly, nonatomic) NSString *originalExpireDate;
@property (readonly, nonatomic) NSDate *expireDate;

+ (id)createSubInfoFromDictionary:(NSDictionary *)dic;

@end
