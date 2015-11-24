//
//  DistanceSkill.h
//  StikyHive
//
//  Created by User on 23/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkillInfo.h"

@interface DistanceSkill : NSObject

@property (getter=getAllSkills, nonatomic) NSArray *allSkills;
@property (getter=getDistance, nonatomic) float geoDistance;
@property (getter=stringFromDistance, nonatomic) NSString *distanceToString;

+ (id)createDistanceSkillWithDistance:(float)dist;
- (void)addSkill:(SkillInfo *)skill;
- (void)removeSkill:(SkillInfo *)skill;

@end
