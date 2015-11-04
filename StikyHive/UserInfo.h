//
//  UserInfo.h
//  StikyHive
//
//  Created by Koh Quee Boon on 27/4/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, copy) NSString *dob;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *postalCode;
@property (nonatomic, copy) NSString *profilePicture;

@property (nonatomic, copy) NSString *stkID;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *address1;
@property (nonatomic, copy) NSString *address2;

- (NSString *) displayName;

@end
