//
//  SkillInfo.h
//  StikyHive
//
//  Created by User on 23/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SkillInfo : NSObject

@property (assign, readonly, nonatomic) NSInteger subId;
@property (assign, readonly, nonatomic) NSInteger status;
@property (copy, readonly, nonatomic) NSString *originalExpiredDate;
@property (readonly, nonatomic) NSDate *expiredDate;
@property (assign, readonly, nonatomic) NSInteger skillId;
@property (assign, readonly, nonatomic) NSInteger photoId;
@property (copy, readonly, nonatomic) NSString *location;
@property (assign, readonly, nonatomic) NSInteger videoId;
@property (copy, readonly, nonatomic) NSString *videoLocation;
@property (copy, readonly, nonatomic) NSString *thumbnailLocation;
@property (copy, readonly, nonatomic) NSString *stkId;
@property (assign, readonly, nonatomic) NSInteger catId;
@property (copy, readonly, nonatomic) NSString *name;
@property (copy, readonly, nonatomic) NSString *skillDesc;
@property (assign, readonly, nonatomic) NSInteger type;
@property (copy, readonly, nonatomic) NSString *firstname;
@property (copy, readonly, nonatomic) NSString *lastname;
@property (copy, readonly, nonatomic) NSString *profilePicture;
@property (copy, readonly, nonatomic) NSString *beeinfo;
@property (assign, readonly, nonatomic) double latitude;
@property (assign, readonly, nonatomic) double longitude;
@property (readonly, nonatomic) CLLocation *geoLocation;
@property (readonly, nonatomic) float distanceToFinder;
@property (getter=stringFromDistance, nonatomic) NSString *distanceToString;

/**
 * Return a SkillInfo by given a proper key/value pair dictionary
 */
+ (id)createSkillInfoFromDictionary:(NSDictionary *)dic;

- (id)initWithDictionary:(NSDictionary *)dic;

- (void)setDistanceFromFinder:(float)dist;

 @end
