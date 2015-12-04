//
//  ContactInfo.m
//  StikyHive
//
//  Created by User on 4/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "ContactInfo.h"

@implementation ContactInfo

@synthesize cId = _cId;
@synthesize stkId = _stkId;
@synthesize contactId = _contactId;
@synthesize originalCreateDate = _originalCreateDate;
@synthesize createDate = _createDate;
@synthesize photoPicture = _photoPicture;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;

+ (id)createContactInfoFromDictionary:(NSDictionary *)dic{
    
    return [[ContactInfo alloc] initWithDictionary:dic];
}

- (id)initWithDictionary:(NSDictionary *)dic{
    
    if(self = [super init]){
        
        _cId = [dic objectForKey:@"id"];
        _stkId = [dic objectForKey:@"stkid"];
        _contactId = [dic objectForKey:@"contactId"];
        _originalCreateDate = [dic objectForKey:@"createDate"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        
        _createDate = [formatter dateFromString:_originalCreateDate];
        _photoPicture = [dic objectForKey:@"profilePicture"];
        _firstName = [dic objectForKey:@"firstName"];
        _lastName = [dic objectForKey:@"lastName"];
        
    }
    
    return self;
}

@end
