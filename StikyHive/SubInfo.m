//
//  SubInfo.m
//  StikyHive
//
//  Created by User on 3/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "SubInfo.h"

@implementation SubInfo

@synthesize subId = _subId;
@synthesize subPlanId = _subPlanId;
@synthesize catId = _catId;
@synthesize skillName = _skillName;
@synthesize summary = _summary;
@synthesize skillDesc = _skillDesc;
@synthesize type = _type;
@synthesize status = _status;
@synthesize rateId = _rateId;
@synthesize rate = _rate;
@synthesize price = _price;
@synthesize duration = _duration;
@synthesize total = _total;
@synthesize originalIssueDate = _originalIssueDate;
@synthesize issueDate = _issueDate;
@synthesize originalExpireDate = _originalExpireDate;
@synthesize expireDate = _expireDate;

+ (id)createSubInfoFromDictionary:(NSDictionary *)dic{
    
    return [[SubInfo alloc] initWithDictionary:dic];
}

- (id)initWithDictionary:(NSDictionary *)dic{
    
    if(self = [super init]){
        
        _subId = [dic objectForKey:@"id"];
        _subPlanId = [[dic objectForKey:@"subscriptionplanId"] integerValue];
        _catId = [[dic objectForKey:@"catId"] integerValue];
        _skillName = [dic objectForKey:@"skillName"];
        _summary = [dic objectForKey:@"summary"];
        _skillDesc = [dic objectForKey:@"skillDescription"];
        _type = [[dic objectForKey:@"type"] integerValue];
        _status = [[dic objectForKey:@"status"] integerValue];
        _rateId = [[dic objectForKey:@"rateId"] integerValue];
        _rate = [dic objectForKey:@"rate"];
        _price = [[dic objectForKey:@"price"] doubleValue];
        _duration = [[dic objectForKey: @"duration"] integerValue];
        _total = [[dic objectForKey:@"total"] doubleValue];
        _originalIssueDate = [dic objectForKey:@"issuedDate"];
        _originalExpireDate = [dic objectForKey:@"expiredDate"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        
        _issueDate = [formatter dateFromString:_originalIssueDate];
        _expireDate = [formatter dateFromString:_originalExpireDate];
        
    }
    
    return self;
}

@end
