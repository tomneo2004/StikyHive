//
//  MySkillInfo.m
//  StikyHive
//
//  Created by User on 17/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "MySkillInfo.h"

@implementation MySkillInfo

@synthesize subId = _subId;
@synthesize status = _status;
@synthesize price = _price;
@synthesize originalExpiredDate =  _originalExpiredDate;
@synthesize expiredDate = _expiredDate;
@synthesize originalIssuedDate = _originalIssuedDate;
@synthesize issueDate = _issueDate;
@synthesize skillId = _skillId;
@synthesize photoId = _photoId;
@synthesize location = _location;
@synthesize caption = _caption;
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
@synthesize email =  _email;
@synthesize beeInfo = _beeInfo;
@synthesize ratename = _ratename;
@synthesize likeCount = _likeCount;
@synthesize reviewCount = _reviewCount;
@synthesize rating = _rating;
@synthesize likeId = _likeId;
@synthesize countOfLikeId = _countOfLikeId;

+ (id)createMySkillInfoFromDictionary:(NSDictionary *)dic{
    
    return [[MySkillInfo alloc] initWithDictionary:dic];
}

- (id)initWithDictionary:(NSDictionary *)dic{
    
    if(self = [super init]){
        
        _subId = [dic objectForKey:@"subId"];
        
        if(![[dic objectForKey:@"status"] isEqual:[NSNull null]])
            _status = [[dic objectForKey:@"status"] integerValue];
        
        if(![[dic objectForKey:@"price"] isEqual:[NSNull null]]){
            
            _price = [[dic objectForKey:@"price"] doubleValue];
        }
        else{
            
            _price = 0.00;
        }
        
        _originalExpiredDate = [dic objectForKey:@"expiredDate"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        
        _expiredDate = [formatter dateFromString:_originalExpiredDate];
        
        _originalIssuedDate = [dic objectForKey:@"issuedDate"];
        _issueDate = [formatter dateFromString:_originalIssuedDate];
        _skillId = [dic objectForKey:@"skillId"];
        _photoId = [dic objectForKey:@"photoId"];
        _location = [dic objectForKey:@"location"];
        _caption = [dic objectForKey:@"caption"];
        
        if(![[dic objectForKey:@"videoId"] isEqual:[NSNull null]]){
            
            _videoId = [dic objectForKey:@"videoId"];
        }
        
        if(![[dic objectForKey:@"videoLocation"] isEqual:[NSNull null]]){
            
            _videoLocation = [dic objectForKey:@"videoLocation"];
        }
        
        if(![[dic objectForKey:@"thumbnailLocation"] isEqual:[NSNull null]]){
            
            _thumbnailLocation = [dic objectForKey:@"thumbnailLocation"];
        }
        
        _stkId = [dic objectForKey:@"stkid"];
        
        if(![[dic objectForKey:@"catId"] isEqual:[NSNull null]])
            _catId = [[dic  objectForKey:@"catId"] integerValue];
        
        _name = [dic objectForKey:@"name"];
        _skillDesc = [dic objectForKey:@"skillDesc"];
        
        if(![[dic objectForKey:@"type"] isEqual:[NSNull null]])
            _type = [[dic objectForKey:@"type"] integerValue];
        
        _firstname = [dic objectForKey:@"firstname"];
        _lastname = [dic objectForKey:@"lastname"];
        _profilePicture = [dic objectForKey:@"profilePicture"];
        _email = [dic objectForKey:@"email"];
        _beeInfo = [dic objectForKey:@"beeInfo"];
        
        if(![[dic objectForKey:@"ratename"] isEqual:[NSNull null]]){
            
            _ratename = [dic objectForKey:@"ratename"];
        }
        
        if(![[dic objectForKey:@"likeCount"] isEqual:[NSNull null]])
            _likeCount = [[dic objectForKey:@"likeCount"] integerValue];
        
        if(![[dic objectForKey:@"reviewCount"] isEqual:[NSNull null]])
            _reviewCount = [[dic objectForKey:@"reviewCount"] integerValue];
        
        if(![[dic objectForKey:@"rating"] isEqual:[NSNull null]]){
            
            _rating = [[dic objectForKey:@"rating"] integerValue];
        }
        
        if(![[dic objectForKey:@"likeId"] isEqual:[NSNull null]])
            _likeId = [[dic objectForKey:@"likeId"] integerValue];
        
        if(![[dic objectForKey:@"countOfLikeId"] isEqual:[NSNull null]])
            _countOfLikeId = [[dic objectForKey:@"countOfLikeId"] integerValue];
    }
    
    return self;
}

@end
