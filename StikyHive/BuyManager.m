//
//  BuyManager.m
//  StikyHive
//
//  Created by THV1WP15S on 28/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "BuyManager.h"

@interface BuyManager ()

@end

@implementation BuyManager {
  
    NSInteger _personType;
    NSInteger _jobType;
    NSInteger _availability;
    NSDecimalNumber *_price;
    NSInteger _rateId;
    NSString *_fromHH;
    NSString *_fromMM;
    NSString *_toHH;
    NSString *_toMM;
    NSInteger _type;
    NSInteger _catId;
    NSString *_name;
    NSString *_desc;
    NSString *_resp;
    
    
    
}

static BuyManager *_instance;

+ (BuyManager *)sharedBuyManager
{
    if (_instance == nil) {
        _instance = [[BuyManager alloc] init];
    }
    
    return _instance;
}


#pragma mark - Setter
- (void)setPersonType:(NSInteger)personType
{
    _personType = personType;
}

- (void)setJobType:(NSInteger)jobType
{
    _jobType = jobType;
}

- (void)setAvailability:(NSInteger)availability
{
    _availability = availability;
}

- (void)setPrice:(NSDecimalNumber *)price
{
    _price = price;
}

- (void)setRateId:(NSInteger)rateId
{
    _rateId = rateId;
}

- (void)setFromHH:(NSString *)fromHH
{
    _fromHH = fromHH;
}

- (void)setFromMM:(NSString *)fromMM
{
    _fromMM = fromMM;
}

- (void)setToHH:(NSString *)toHH
{
    _toHH = toHH;
}

- (void)setToMM:(NSString *)toMM
{
    _toMM = toMM;
}

- (void)setType:(NSInteger)type
{
    _type = type;
}

- (void)setCatId:(NSInteger)catId
{
    _catId = catId;
}

- (void)setName:(NSString *)name
{
    _name = name;
}

- (void)setDesc:(NSString *)desc
{
    _desc = desc;
}

- (void)setResp:(NSString *)resp
{
    _resp = resp;
}




#pragma mark - Getter

- (NSInteger)getPersonType
{
    return _personType;
}

- (NSInteger)getJobType
{
    return _jobType;
}

- (NSInteger)getAvailability
{
    return _availability;
}

- (NSDecimalNumber *)getPrice
{
    return _price;
}

- (NSInteger)getRateId
{
    return _rateId;
}

- (NSString *)getFromHH
{
    return _fromHH;
}

- (NSString *)getFromMM
{
    return _fromMM;
}

- (NSString *)getToHH
{
    return _toHH;
}

- (NSString *)getToMM
{
    return _toMM;
}

- (NSInteger)getType
{
    return _type;
}

- (NSInteger)getCatId
{
    return _catId;
}

- (NSString *)getName
{
    return _name;
}

- (NSString *)getDesc
{
    return _desc;
}

- (NSString *)getResp
{
    return _resp;
}





- (void)clearCurrentBuy
{
    
}

@end
