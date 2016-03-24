//
//  SearchInfo.h
//  StikyHive
//
//  Created by User on 23/3/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchInfo : NSObject

@property (copy, readonly, nonatomic) NSString *thumbnailLocation;
@property (copy, readonly, nonatomic) NSString *profilePicture;
@property (copy, readonly, nonatomic) NSString *name;
@property (copy, readonly, nonatomic) NSString *stkId;
@property (copy, readonly, nonatomic) NSString *skillId;
@property (copy, readonly, nonatomic) NSString *videoUrl;

+ (id)createSearchInfoFromDictionary:(NSDictionary *)dic;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
