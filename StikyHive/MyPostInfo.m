//
//  MyPostInfo.m
//  StikyHive
//
//  Created by User on 23/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "MyPostInfo.h"

@implementation MyPostInfo

+ (id)createMyPostInfoFromDictionary:(NSDictionary *)dic{
    
    return [[MyPostInfo alloc] initWithDictionary:dic];
}

- (id)initWithDictionary:(NSDictionary *)dic{
    
    if(self = [super init]){
        
        _postId = [dic objectForKey:@"id"];
        _stkId = [dic  objectForKey:@"stkid"];
        _type = [[dic objectForKey:@"type"] integerValue];
        _name = [dic objectForKey:@"name"];
        _desc = [dic objectForKey:@"description"];
        _originalIssuedDate = [dic objectForKey:@"createDate"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        
        _issueDate = [formatter dateFromString:_originalIssuedDate];
        _originalUpdateDate = [dic objectForKey:@"updateDate"];
        _updateDate = [formatter dateFromString:_originalUpdateDate];
        _status = [[dic objectForKey:@"status"] integerValue];
        _catId = [[dic objectForKey:@"catId"] integerValue];
        _personType = [[dic objectForKey:@"personType"] integerValue];
        _originalExpiredDate = [dic objectForKey:@"expiredDate"];
        _expiredDate = [formatter dateFromString:_originalExpiredDate];
        _availability = [[dic objectForKey:@"availability"] integerValue];
        _active = [[dic objectForKey:@"active"] integerValue];
        _jobType = [[dic objectForKey:@"jobType"] integerValue];
        _responsibilities = [dic objectForKey:@"responsibilities"];
        
        if(![[dic objectForKey:@"startTime"] isEqual:[NSNull null]]){
            
            _originalStartTime = [dic objectForKey:@"startTime"];
            [formatter setDateFormat:@"HH:mm"];
            _startTime = [formatter dateFromString:_originalStartTime];
        }
        
        if(![[dic objectForKey:@"endTime"] isEqual:[NSNull null]]){
            
            _originalEndTime = [dic objectForKey:@"endTime"];
            [formatter setDateFormat:@"HH:mm"];
            _endTime = [formatter dateFromString:_originalEndTime];
        }
        
        if(![[dic objectForKey:@"price"] isEqual:[NSNull null]]){
            
            _price = [dic objectForKey:@"price"];
        }
        else{
            
            _price = @"";
        }
        
        if(![[dic objectForKey:@"rateId"] isEqual:[NSNull null]]){
            
            _rateId = [[dic objectForKey:@"rateId"] integerValue];
        }
        
        if(![[dic objectForKey:@"rate"] isEqual:[NSNull null]]){
            
            _rate = [dic objectForKey:@"rate"];
        }
        
        _location = [dic objectForKey:@"location"];
        
        if(![[dic objectForKey:@"rateName"] isEqual:[NSNull null]]){
            
            _rateName = [dic objectForKey:@"rateName"];
        }
    }
    
    return self;
}

@end
