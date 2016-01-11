//
//  JobInfo.h
//  StikyHive
//
//  Created by THV1WP15S on 5/1/16.
//  Copyright (c) 2016 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobInfo : NSObject

@property (copy, readonly, nonatomic) NSString *companyName;
@property (copy, readonly, nonatomic) NSString *countryISO;
@property (copy, readonly, nonatomic) NSString *jobTitle;
@property (copy, readonly, nonatomic) NSString *originalFromDate;
@property (readonly, nonatomic) NSDate *fromDate;
@property (copy, readonly, nonatomic) NSString *originalToDate;
@property (readonly, nonatomic) NSDate *toDate;
@property (copy, readonly, nonatomic) NSString *otherInfo;
@property (copy, readonly, nonatomic) NSString *countryName;


+ (id)createJobInfoFromDictionary:(NSDictionary *)dic;

@end
