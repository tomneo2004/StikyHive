//
//  CountryInfo.m
//  StikyHive
//
//  Created by User on 10/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "CountryInfo.h"

@implementation CountryInfo

@synthesize countryId = _countryId;
@synthesize countryISO = _countryISO;
@synthesize countryName = _countryName;

+ (id)createCountryInfoFromDictionary:(NSDictionary *)dic{
    
    return [[CountryInfo alloc] initWithDictionary:dic];
}

- (id)initWithDictionary:(NSDictionary *)dic{

    if(self = [super init]){
        
        _countryId = [[dic objectForKey:@"id"] integerValue];
        _countryISO = [dic objectForKey:@"iso"];
        _countryName = [dic objectForKey:@"name"];
    }
    
    return self;
}

@end
