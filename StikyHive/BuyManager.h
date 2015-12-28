//
//  BuyManager.h
//  StikyHive
//
//  Created by THV1WP15S on 28/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyManager : NSObject

@property (setter=setPersonType:, getter=getPersonType, nonatomic) NSInteger personType;
@property (setter=setJobType:, getter=getJobType, nonatomic) NSInteger jobType;
@property (setter=setAvailability:, getter=getAvailability, nonatomic) NSInteger availability;
@property (setter=setPrice:, getter=getPrice, nonatomic) NSDecimalNumber *price;
@property (setter=setRateId:, getter=getRateId, nonatomic) NSInteger rateId;
@property (setter=setFromHH:, getter=getFromHH, nonatomic) NSString *fromHH;
@property (setter=setFromMM:, getter=getFromMM, nonatomic) NSString *fromMM;
@property (setter=setToHH:, getter=getToHH, nonatomic) NSString *toHH;
@property (setter=setToMM:, getter=getToMM, nonatomic) NSString *toMM;
@property (setter=setType:, getter=getType, nonatomic) NSInteger type;
@property (setter=setCatId:, getter=getCatId, nonatomic) NSInteger catId;
@property (setter=setName:, getter=getName, nonatomic) NSString *name;
@property (setter=setDesc:, getter=getDesc, nonatomic) NSString *desc;
@property (setter=setResp:, getter=getResp, nonatomic) NSString *resp;



+ (BuyManager *)sharedBuyManager;

- (void)clearCurrentBuy;

@end
