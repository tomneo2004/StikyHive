//
//  CountryInfo.h
//  StikyHive
//
//  Created by User on 10/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountryInfo : NSObject

@property (assign, readonly, nonatomic) NSInteger countryId;
@property (copy, readonly, nonatomic) NSString *countryISO;
@property (copy, readonly, nonatomic) NSString *countryName;

+ (id)createCountryInfoFromDictionary:(NSDictionary *)dic;

@end
