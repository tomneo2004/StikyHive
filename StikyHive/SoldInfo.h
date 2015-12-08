//
//  SoldInfo.h
//  StikyHive
//
//  Created by User on 4/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoldInfo : NSObject

@property (copy, readonly, nonatomic) NSString *soldId;
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
@property (copy, readonly, nonatomic) NSString *name;
@property (assign, readonly, nonatomic) double price;
@property (copy, readonly, nonatomic) NSString *firstName;
@property (copy, readonly, nonatomic) NSString *lastName;

+ (id)createSoldInfoFromDictionary:(NSDictionary *)dic;

@end
