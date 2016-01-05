//
//  EducationInfo.m
//  StikyHive
//
//  Created by User on 5/1/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "EducationInfo.h"

@implementation EducationInfo

@synthesize educationId = _educationId;
@synthesize stkId = _stkId;
@synthesize institute = _institute;
@synthesize countryISO = _countryISO;
@synthesize qualification = _qualification;
@synthesize originalFromDate = _originalFromDate;
@synthesize fromDate = _fromDate;
@synthesize originalToDate = _originalToDate;
@synthesize toDate = _toDate;
@synthesize originalCreateDate = _originalCreateDate;
@synthesize createDate = _createDate;
@synthesize originalUpdateDate = _originalUpdateDate;
@synthesize updateDate = _updateDate;
@synthesize otherInfo = _otherInfo;
@synthesize status = _status;
@synthesize countryName = _countryName;

+ (id)createEducationInfoFromDictionary:(NSDictionary *)dic{
    
    return [[EducationInfo alloc] initWithDictionary:dic];
}

- (id)initWithDictionary:(NSDictionary *)dic{
    
    if(self = [super init]){
        
        _educationId = [[dic objectForKey:@"id"] integerValue];
        _stkId = [dic objectForKey:@"stkid"];
        _institute = [dic objectForKey:@"institute"];
        _countryISO = [dic objectForKey:@"countryISO"];
        _qualification = [dic objectForKey:@"qualification"];
        _originalFromDate = [dic objectForKey:@"fromDate"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        
        _fromDate = [formatter dateFromString:_originalFromDate];
        
        _originalToDate = [dic objectForKey:@"toDate"];
        _toDate = [formatter dateFromString:_originalToDate];
        
        if(![[dic objectForKey:@"createDate"] isEqual:[NSNull null]]){
            
            _originalCreateDate = [dic objectForKey:@"createDate"];
            _createDate = [formatter dateFromString:_originalCreateDate];
        }
        
        if(![[dic objectForKey:@"updateDate"] isEqual:[NSNull null]]){
            
            _originalUpdateDate = [dic objectForKey:@"updateDate"];
            _updateDate = [formatter dateFromString:_originalUpdateDate];
        }
        
        if(![[dic objectForKey:@"otherInfo"] isEqual:[NSNull null]])
            _otherInfo = [dic objectForKey:@"otherInfo"];
        else
            _otherInfo = @"";
        
        _status = [[dic objectForKey:@"status"] integerValue];
        _countryName = [dic objectForKey:@"countryName"];
    }
    
    return self;
}

@end
