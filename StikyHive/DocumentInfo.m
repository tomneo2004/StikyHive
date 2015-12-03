//
//  DocumentInfo.m
//  StikyHive
//
//  Created by User on 1/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "DocumentInfo.h"

@implementation DocumentInfo

@synthesize documentId = _documentId;
@synthesize stkId = _stkId;
@synthesize documentName = _documentName;
@synthesize documentLocation = _documentLocation;
@synthesize status = _status;
@synthesize originalCreateDate = _originalCreateDate;
@synthesize createDate = _createDate;
@synthesize updateDate = _updateDate;
@synthesize type = _type;


+ (id)createDocumentInfoFromDictionary:(NSDictionary *)dic{
    
    return [[DocumentInfo alloc] initWithDictionary:dic];
}

- (id)initWithDictionary:(NSDictionary *)dic{

    if(self = [super init]){
        
        _documentId = [[dic objectForKey:@"id"] integerValue];
        _stkId = [dic objectForKey:@"stkid"];
        _documentName = [dic objectForKey:@"name"];
        _documentLocation = [dic objectForKey:@"location"];
        _status = [[dic objectForKey:@"status"] integerValue];
        _originalCreateDate = [dic objectForKey:@"createDate"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        
        _createDate = [formatter dateFromString:_originalCreateDate];
        
        _updateDate = [dic objectForKey:@"updateDate"];
        _type = [[dic objectForKey:@"type"] integerValue];
    }
    
    return self;
}

@end
