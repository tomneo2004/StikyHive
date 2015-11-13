//
//  Request.h
//  StikyHive
//
//  Created by User on 12/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Request : NSObject

@property (copy, readonly, nonatomic) NSString *beeInfo;
@property (assign, readonly, nonatomic) NSInteger cpId;
@property (copy, readonly, nonatomic) NSString *desc;
@property (copy, readonly, nonatomic) NSString *firstname;
@property (copy, readonly, nonatomic) NSString *lastname;
@property (copy, readonly, nonatomic) NSString *photoLocation;
@property (copy, readonly, nonatomic) NSString *profilePicture;
@property (copy, readonly, nonatomic) NSString *originalRequestTime;
@property (readonly, nonatomic) NSDate *requestTime;
@property (copy, readonly, nonatomic) NSString *stkId;
@property (copy, readonly, nonatomic) NSString *title;

/**
 * Return a request by given a proper key/value pair dictionary
 */
+ (id)createRequestFromDictionary:(NSDictionary *)dic;

@end
