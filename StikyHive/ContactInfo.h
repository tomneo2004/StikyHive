//
//  ContactInfo.h
//  StikyHive
//
//  Created by User on 4/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactInfo : NSObject

@property (copy, readonly , nonatomic) NSString *cId;
@property (copy, readonly, nonatomic) NSString *stkId;
@property (copy, readonly, nonatomic) NSString *contactId;
@property (copy, readonly, nonatomic) NSString *originalCreateDate;
@property (readonly, nonatomic) NSDate *createDate;
@property (copy, readonly, nonatomic) NSString *photoPicture;
@property (copy, readonly, nonatomic) NSString *firstName;
@property (copy, readonly, nonatomic) NSString *lastName;

+ (id)createContactInfoFromDictionary:(NSDictionary *)dic;

@end
