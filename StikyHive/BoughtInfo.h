//
//  BoughtInfo.h
//  StikyHive
//
//  Created by User on 8/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoughtInfo : NSObject

@property (copy, readonly, nonatomic) NSString *boughtId;
@property (copy, readonly, nonatomic) NSString *offerId;
@property (copy, readonly, nonatomic) NSString *skillId;
@property (copy, readonly, nonatomic) NSString *buyerStkId;
@property (copy, readonly, nonatomic) NSString *sellerStkId;
@property (copy, readonly, nonatomic) NSString *paymentStatus;
@property (copy, readonly, nonatomic) NSString *secPaymentStatus;
@property (copy, readonly, nonatomic) NSString *originalCreateDate;
@property (readonly, nonatomic) NSDate *createDate;
@property (copy, readonly, nonatomic) NSString *originalUpdateDate;
@property (readonly, nonatomic) NSDate *updateDate;
@property (copy, readonly, nonatomic) NSString *commentId;
@property (copy, readonly, nonatomic) NSString *review;
@property (assign, readonly, nonatomic) NSInteger rating;
@property (copy, readonly, nonatomic) NSString *skillName;
@property (copy, readonly, nonatomic) NSString *firstname;
@property (copy, readonly, nonatomic) NSString *lastname;
@property (assign, readonly, nonatomic) double price;
@property (copy, readonly, nonatomic) NSString *rateName;
@property (copy, readonly, nonatomic) NSString *thumbnailLocation;
@property (copy, readonly, nonatomic) NSString *photoLocation;

+ (id)createBoughtInfoFromDictionary:(NSDictionary *)dic;

@end
