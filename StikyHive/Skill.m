//
//  Skill.m
//  StikyHive
//
//  Created by Koh Quee Boon on 14/4/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "Skill.h"

@implementation Skill

//- (id) initWithID:(NSInteger)skillID
//            catID:(NSInteger)catID
//           userID:(NSString *)userID
//        skillName:(NSString *)skillName
//        skillDesc:(NSString *)skillDesc
//    skillImageURL:(NSString *)imageURL
//    skillVideoURL:(NSString *)videoURL
//skillVideoThumbURL:(NSString *)videoThumbURL
//     userPhotoLoc:(NSString *)photoName
//{
//    self = [super init];
//    if (self)
//    {
//        _skillID = skillID;
//        _catID = catID;
//        _userID = userID;
//        _skillName = skillName;
//        _skillDesc = skillDesc;
//        _skillImageURL = imageURL;
//        _skillVideoURL = videoURL;
//        _skillVideoThumbURL = videoThumbURL;
//        _userPhotoName = photoName;
//    }
//    return self;
//}

// Echo ------------------
- (id) initWithSkillId:(NSString *)skillid
                 stkid:(NSString *)stkid
             skillName:(NSString *)skillName
    skillImageLocation:(NSString *)skillImageLocation
    skillThumbLocation:(NSString *)skillThumbLocation
       profileLocation:(NSString *)profileLocation
    skillVideoLocation:(NSString *)skillVideoLocation;
{
    self = [super init];
    if (self) {
        _skillid = skillid;
        _stkid = stkid;
        _skillName = skillName;
        _skillImageLocation = skillImageLocation;
        _skillThumbLocation = skillThumbLocation;
        _profileLocation = profileLocation;
        _skillVideoLocation = skillVideoLocation;
        
    }
    
    
    return self;
    
}


- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        _skillID = [decoder decodeIntegerForKey:@"Skill_skillID"];
        _catID = [decoder decodeIntegerForKey:@"Skill_catID"];
        _userID = [decoder decodeObjectForKey:@"Skill_userID"];
        _skillName = [decoder decodeObjectForKey:@"Skill_skillName"];
        _skillDesc = [decoder decodeObjectForKey:@"Skill_skillDesc"];
        _skillImageURL = [decoder decodeObjectForKey:@"Skill_skillImageURL"];
        _skillVideoURL = [decoder decodeObjectForKey:@"Skill_skillVideoURL"];
        _skillVideoThumbURL = [decoder decodeObjectForKey:@"Skill_skillVideoThumbURL"];
        _userPhotoName = [decoder decodeObjectForKey:@"Skill_userPhotoName"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:_skillID forKey:@"Skill_skillID"];
    [encoder encodeInteger:_catID forKey:@"Skill_catID"];
    [encoder encodeObject:_userID forKey:@"Skill_userID"];
    [encoder encodeObject:_skillName forKey:@"Skill_skillName"];
    [encoder encodeObject:_skillDesc forKey:@"Skill_skillDesc"];
    [encoder encodeObject:_skillImageURL forKey:@"Skill_skillImageURL"];
    [encoder encodeObject:_skillVideoURL forKey:@"Skill_skillVideoURL"];
    [encoder encodeObject:_skillVideoThumbURL forKey:@"Skill_skillVideoThumbURL"];
    [encoder encodeObject:_userPhotoName forKey:@"Skill_userPhotoName"];
}

@end
