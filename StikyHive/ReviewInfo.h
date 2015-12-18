//
//  ReviewInfo.h
//  StikyHive
//
//  Created by User on 18/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReviewInfo : NSObject

@property (copy, readonly, nonatomic) NSString *reviewId;
@property (assign, readonly, nonatomic) NSInteger skillId;
@property (assign, readonly, nonatomic) NSInteger offerId;
@property (copy, readonly, nonatomic) NSString *reviewerStkId;
@property (copy, readonly, nonatomic) NSString *review;
@property (assign, readonly, nonatomic) NSInteger type;
@property (copy, readonly, nonatomic) NSString *originalCreateDate;
@property (readonly, nonatomic) NSDate *createDate;
@property (copy, readonly, nonatomic) NSString *originalUpdateDate;
@property (readonly, nonatomic) NSDate *updateDate;
@property (assign, readonly, nonatomic) NSInteger rating;
@property (copy, readonly, nonatomic) NSString *profilePicture;
@property (copy, readonly, nonatomic) NSString *firstname;
@property (copy, readonly, nonatomic) NSString *lastname;

+ (id)createReviewInfoFromDictionary:(NSDictionary *)dic;

@end
