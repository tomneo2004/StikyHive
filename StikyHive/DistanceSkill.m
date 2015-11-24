//
//  DistanceSkill.m
//  StikyHive
//
//  Created by User on 23/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "DistanceSkill.h"

@implementation DistanceSkill{
    
    NSMutableArray *_skillInfos;
    float _distance;
}

@synthesize allSkills  = _allSkills;
@synthesize geoDistance = _geoDistance;
@synthesize distanceToString = _distanceToString;

+ (id)createDistanceSkillWithDistance:(float)dist{
    
    return [[DistanceSkill alloc] initWithDistance:dist];
}

- (id)initWithDistance:(float)dist{
    
    if(self = [super init]){
        
        _skillInfos = [[NSMutableArray alloc] init];
        _distance = dist;
    }
    
    return self;
}

- (void)addSkill:(SkillInfo *)skill{
    
    [_skillInfos addObject:skill];
}

- (void)removeSkill:(SkillInfo *)skill{
    
    [_skillInfos removeObject:skill];
}

- (NSArray *)getAllSkills{
    
    return _skillInfos;
}

- (float)getDistance{
    
    return _distance;
}

- (NSString *)stringFromDistance{
    
    float calculateDist = 0.0f;
    
    NSString *unitString;
    
    if((int)(_distance/1000.0f) > 0){
        
        calculateDist = _distance/1000.0f;
        unitString = @" km";
    }
    else{
        
        calculateDist = _distance;
        unitString = @" m";
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 2;
    
    return [NSString stringWithFormat:@"%@%@", [formatter stringFromNumber:[NSNumber numberWithFloat:calculateDist]], unitString];
}

@end
