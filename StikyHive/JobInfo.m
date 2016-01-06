//
//  JobInfo.m
//  StikyHive
//
//  Created by THV1WP15S on 5/1/16.
//  Copyright (c) 2016 Stiky Hive. All rights reserved.
//

#import "JobInfo.h"

@implementation JobInfo

@synthesize companyName = _companyName;
@synthesize jobTitle = _jobTitle;
@synthesize countryISO = _countryISO;
@synthesize originalFromDate = _originalFromDate;
@synthesize fromDate = _fromDate;
@synthesize originalToDate = _originalToDate;
@synthesize toDate = _toDate;
@synthesize otherInfo = _otherInfo;
@synthesize countryName = _countryName;


+ (id)createJobInfoFromDictionary:(NSDictionary *)dic
{
    return [[JobInfo alloc] initWithDictionary:dic];
}

- (id)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        _companyName = [dic objectForKey:@"companyName"];
        _jobTitle = [dic objectForKey:@"jobtitle"];
        _countryISO = [dic objectForKey:@"countryISO"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        
        _fromDate = [formatter dateFromString:_originalFromDate];
        
        _originalToDate = [dic objectForKey:@"toDate"];
        if (_originalFromDate != nil) {
            _toDate = [formatter dateFromString:_originalToDate];
        }
        

        
        if(![[dic objectForKey:@"otherInfo"] isEqual:[NSNull null]])
            _otherInfo = [dic objectForKey:@"otherInfo"];
        else
            _otherInfo = @"";
        
        
        _countryName = [dic objectForKey:@"countryName"];
        
        
    }
    
    return self;
}






@end
