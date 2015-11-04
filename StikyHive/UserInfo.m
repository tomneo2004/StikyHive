//
//  UserInfo.m
//  StikyHive
//
//  Created by Koh Quee Boon on 27/4/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        _dob = [decoder decodeObjectForKey:@"UseInfo_dob"];
        _email = [decoder decodeObjectForKey:@"UseInfo_email"];
        _firstName = [decoder decodeObjectForKey:@"UseInfo_firstName"];
        _lastName = [decoder decodeObjectForKey:@"UseInfo_lastName"];
        _address = [decoder decodeObjectForKey:@"UseInfo_address"];
        _country = [decoder decodeObjectForKey:@"UseInfo_country"];
        _postalCode = [decoder decodeObjectForKey:@"UseInfo_postalCode"];
        _profilePicture = [decoder decodeObjectForKey:@"UseInfo_profilePicture"];
        
        _address1 = [decoder decodeObjectForKey:@"UseInfo_address1"];
        _address2 = [decoder decodeObjectForKey:@"UseInfo_address2"];
        _desc = [decoder decodeObjectForKey:@"UseInfo_description"];
        _stkID = [decoder decodeObjectForKey:@"UseInfo_stkID"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_dob forKey:@"UseInfo_dob"];
    [encoder encodeObject:_email forKey:@"UseInfo_email"];
    [encoder encodeObject:_firstName forKey:@"UseInfo_firstName"];
    [encoder encodeObject:_lastName forKey:@"UseInfo_lastName"];
    [encoder encodeObject:_address forKey:@"UseInfo_address"];
    [encoder encodeObject:_country forKey:@"UseInfo_country"];
    [encoder encodeObject:_postalCode forKey:@"UseInfo_postalCode"];
    [encoder encodeObject:_profilePicture forKey:@"UseInfo_profilePicture"];
    
    [encoder encodeObject:_desc forKey:@"UseInfo_description"];
    [encoder encodeObject:_stkID forKey:@"UseInfo_stkID"];
    [encoder encodeObject:_address1 forKey:@"UseInfo_address1"];
    [encoder encodeObject:_address2 forKey:@"UseInfo_address2"];
}

- (NSString *) displayName
{
    NSString *last = ![_lastName isKindOfClass:[NSNull class]] && _lastName.length > 0 ? _lastName : @"";
    NSString *first = ![_firstName isKindOfClass:[NSNull class]] && _firstName.length > 0 ? _firstName : @"";
    NSString *name = [NSString stringWithFormat:@"%@ %@", first, last];
    return name.length > 1 ? name : _email;
}

@end
