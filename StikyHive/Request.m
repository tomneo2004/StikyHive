//
//  Request.m
//  StikyHive
//
//  Created by User on 12/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "Request.h"

@implementation Request

@synthesize beeInfo = _beeInfo;
@synthesize cpId = _cpId;
@synthesize desc = _desc;
@synthesize firstname = _firstname;
@synthesize lastname = _lastname;
@synthesize photoLocation = _photoLocation;
@synthesize profilePicture = _profilePicture;
@synthesize originalRequestTime = _originalRequestTime;
@synthesize requestTime = _requestTime;
@synthesize stkId = _stkId;
@synthesize title = _title;

+ (id)createRequestFromDictionary:(NSDictionary *)dic{
    
    return  [[Request alloc] initWithDictionary:dic];
}

- (id)initWithDictionary:(NSDictionary *)dic{
    
    if(self = [super init]){
        
        _beeInfo = [dic valueForKey:@"beeInfo"];
        _cpId = [[dic valueForKey:@"cpId"] integerValue];
        _desc = [dic valueForKey:@"description"];
        _firstname = [dic valueForKey:@"firstname"];
        _lastname = [dic valueForKey:@"lastname"];
        _photoLocation = [dic valueForKey:@"photoLocation"];
        _profilePicture = [dic valueForKey:@"profilePicture"];
        _stkId = [dic valueForKey:@"stkId"];
        _title = [dic valueForKey:@"title"];
        _originalRequestTime = [dic valueForKey:@"requestTime"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        
        _requestTime = [formatter dateFromString:_originalRequestTime];
    }
    
    return self;
}

@end
