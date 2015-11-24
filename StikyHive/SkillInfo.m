//
//  SkillInfo.m
//  StikyHive
//
//  Created by User on 23/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "SkillInfo.h"

@implementation SkillInfo

@synthesize subId = _subId;
@synthesize status = _status;
@synthesize originalExpiredDate = _originalExpiredDate;
@synthesize expiredDate = _expiredDate;
@synthesize skillId = _skillId;
@synthesize photoId = _photoId;
@synthesize location = _location;
@synthesize videoId = _videoId;
@synthesize videoLocation = _videoLocation;
@synthesize thumbnailLocation = _thumbnailLocation;
@synthesize stkId = _stkId;
@synthesize catId = _catId;
@synthesize name = _name;
@synthesize skillDesc = _skillDesc;
@synthesize type = _type;
@synthesize firstname = _firstname;
@synthesize lastname = _lastname;
@synthesize profilePicture = _profilePicture;
@synthesize beeinfo = _beeinfo;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize geoLocation = _geoLocation;
@synthesize distanceToFinder = _distanceToFinder;
@synthesize distanceToString = _distanceToString;

+ (id)createSkillInfoFromDictionary:(NSDictionary *)dic{
    
    return [[SkillInfo alloc] initWithDictionary:dic];
}

- (id)initWithDictionary:(NSDictionary *)dic{
    
    if(self = [super init]){
        
        _subId = [[dic objectForKey:@"subId"] integerValue];
        _status = [[dic objectForKey:@"status"] integerValue];
        _originalExpiredDate = [dic objectForKey:@"expiredDate"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        
        _expiredDate = [formatter dateFromString:_originalExpiredDate];
        
        _skillId = [[dic objectForKey:@"skillId"] integerValue];
        _photoId = [[dic objectForKey:@"photoId"] integerValue];
        _location = [dic objectForKey:@"location"];
        
        id videoId = [dic objectForKey:@"videoId"];
        if(videoId != nil && ![videoId isEqual:[NSNull null]]){
            
            _videoId = [videoId integerValue];
        }
        else{
            
            _videoId = -1;
        }
        
        id videoLocation = [dic objectForKey:@"videoLocation"];
        if(videoLocation != nil && ![videoLocation isEqual:[NSNull null]]){
            
            _videoLocation = videoLocation;
        }
        else{
            
            _videoLocation =nil;
        }
        
        id thumbnailLocation = [dic objectForKey:@"thumbnailLocation"];
        if(thumbnailLocation != nil && ![thumbnailLocation isEqual:[NSNull null]]){
            
            _thumbnailLocation = thumbnailLocation;
        }
        else{
            
            _thumbnailLocation = nil;
        }
        
        _stkId = [dic objectForKey:@"stkid"];
        _catId = [[dic objectForKey:@"catId"] integerValue];
        _name = [dic objectForKey:@"name"];
        _skillDesc = [dic objectForKey:@"skillDesc"];
        _type = [[dic objectForKey:@"type"] integerValue];
        _firstname = [dic objectForKey:@"firstname"];
        _lastname = [dic objectForKey:@"lastname"];
        _profilePicture = [dic objectForKey:@"profilePicture"];
        _beeinfo = [dic objectForKey:@"beeInfo"];
        _latitude = [[dic objectForKey:@"lat"] doubleValue];
        _longitude = [[dic objectForKey:@"lon"] doubleValue];
        _geoLocation = [[CLLocation alloc] initWithLatitude:_latitude longitude:_longitude];
    }
    
    return self;
}

- (void)setDistanceFromFinder:(float)dist{
    
    _distanceToFinder = dist;
}

- (NSString *)stringFromDistance{
    
    float calculateDist = 0.0f;
    
    NSString *unitString;
    
    if((int)(_distanceToFinder/1000.0f) > 0){
        
        calculateDist = _distanceToFinder/1000.0f;
        unitString = @" km";
    }
    else{
        
        calculateDist = _distanceToFinder;
        unitString = @" m";
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 2;
    
    return [NSString stringWithFormat:@"%@%@", [formatter stringFromNumber:[NSNumber numberWithFloat:calculateDist]], unitString];
}

@end
