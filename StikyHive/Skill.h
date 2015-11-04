//
//  Skill.h
//  StikyHive
//
//  Created by Koh Quee Boon on 14/4/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SKILL_TYPE_PROF_SKILL 1
#define SKILL_TYPE_RAW_TALENT 2

@interface Skill : NSObject

@property (nonatomic, assign) NSInteger skillType;
@property (nonatomic, assign) NSInteger skillID;
@property (nonatomic, assign) NSInteger catID;
@property (nonatomic, copy) NSString *userID;
//@property (nonatomic, copy) NSString *skillName;
@property (nonatomic, copy) NSString *skillDesc;
@property (nonatomic, copy) NSString *skillImageURL;
@property (nonatomic, copy) NSString *skillVideoURL;
@property (nonatomic, copy) NSString *userPhotoName;
@property (nonatomic, copy) NSString *skillVideoThumbURL;

/////

@property (nonatomic, copy) NSString *stkid;
@property (nonatomic, copy) NSString *skillid;
@property (nonatomic, copy) NSString *skillName;
@property (nonatomic, copy) NSString *skillImageLocation;
@property (nonatomic, copy) NSString *skillVideoLocation;
@property (nonatomic, copy) NSString *skillThumbLocation;
@property (nonatomic, copy) NSString *profileLocation;

/////

// skillType set after init
//- (id) initWithID:(NSInteger)skillID
//            catID:(NSInteger)catID
//           userID:(NSString *)userID
//        skillName:(NSString *)skillName
//        skillDesc:(NSString *)skillDesc
//    skillImageURL:(NSString *)imageURL
//    skillVideoURL:(NSString *)videoURL
//skillVideoThumbURL:(NSString *)videoThumbURL
//     userPhotoLoc:(NSString *)photoName;

///// Echo ------------------

- (id) initWithSkillId:(NSString *)skillid
                 stkid:(NSString *)stkid
             skillName:(NSString *)skillName
    skillImageLocation:(NSString *)skillImageLocation
    skillThumbLocation:(NSString *)skillThumbLocation
       profileLocation:(NSString *)profileLocation
    skillVideoLocation:(NSString *)skillVideoLocation;


@end
