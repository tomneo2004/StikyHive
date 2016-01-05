//
//  EducationInfo.h
//  StikyHive
//
//  Created by User on 5/1/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EducationInfo : NSObject

@property (assign, readonly, nonatomic) NSInteger educationId;
@property (copy, readonly, nonatomic) NSString *stkId;
@property (copy, readonly, nonatomic) NSString *institute;
@property (copy, readonly, nonatomic) NSString *countryISO;
@property (copy, readonly, nonatomic) NSString *qualification;
@property (copy, readonly, nonatomic) NSString *originalFromDate;
@property (readonly, nonatomic) NSDate *fromDate;
@property (copy, readonly, nonatomic) NSString *originalToDate;
@property (readonly, nonatomic) NSDate *toDate;
@property (copy, readonly, nonatomic) NSString *originalCreateDate;
@property (readonly, nonatomic) NSDate *createDate;
@property (copy, readonly, nonatomic) NSString *originalUpdateDate;
@property (readonly, nonatomic) NSDate *updateDate;
@property (copy, readonly, nonatomic) NSString *otherInfo;
@property (assign, readonly, nonatomic) NSInteger status;
@property (copy, readonly, nonatomic) NSString *countryName;

+ (id)createEducationInfoFromDictionary:(NSDictionary *)dic;

@end
