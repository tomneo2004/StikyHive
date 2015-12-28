//
//  ReviewInfo.m
//  StikyHive
//
//  Created by User on 18/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "ReviewInfo.h"

@implementation ReviewInfo

@synthesize reviewId = _reviewId;
@synthesize skillId = _skillId;
@synthesize offerId = _offerId;
@synthesize reviewerStkId = _reviewerStkId;
@synthesize review = _review;
@synthesize type = _type;
@synthesize originalCreateDate  = _originalCreateDate;
@synthesize createDate = _createDate;
@synthesize originalUpdateDate = _originalUpdateDate;
@synthesize updateDate = _updateDate;
@synthesize rating = _rating;
@synthesize profilePicture = _profilePicture;
@synthesize firstname = _firstname;
@synthesize lastname = _lastname;

+ (id)createReviewInfoFromDictionary:(NSDictionary *)dic{
    
    return [[ReviewInfo alloc] initWithDictionary:dic];
}

- (id)initWithDictionary:(NSDictionary *)dic{
    
    if(self = [super init]){
        
        _reviewId = [dic objectForKey:@"id"];
        _skillId = [[dic objectForKey:@"skillId"] integerValue];
        _offerId = [[dic objectForKey:@"offerId"] integerValue];
        _reviewerStkId = [dic objectForKey:@"reviewer"];
        
        if(![[dic objectForKey:@"review"] isEqual:[NSNull null]])
            _review = [dic objectForKey:@"review"];
        
        _type = [[dic objectForKey:@"type"] integerValue];
        
        _originalCreateDate = [dic objectForKey:@"createDate"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        
        _createDate = [formatter dateFromString:_originalCreateDate];
        
        if(![[dic objectForKey:@"updateDate"] isEqual:[NSNull null]]){
            
            _originalUpdateDate = [dic objectForKey:@"updateDate"];
            _updateDate = [formatter dateFromString:_originalUpdateDate];
        }
        
        _rating = [[dic objectForKey:@"rating"] integerValue];
        
        if(![[dic objectForKey:@"profilePicture"] isEqual:[NSNull null]])
            _profilePicture = [dic objectForKey:@"profilePicture"];
        else
            _profilePicture = @"";
        
        _firstname = [dic objectForKey:@"firstName"];
        _lastname = [dic objectForKey:@"lastName"];
        
    }
    
    return self;
}

@end
