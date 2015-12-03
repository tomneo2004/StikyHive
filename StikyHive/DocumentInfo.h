//
//  DocumentInfo.h
//  StikyHive
//
//  Created by User on 1/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocumentInfo : NSObject

@property (assign, readonly, nonatomic) NSInteger documentId;
@property (copy, readonly, nonatomic) NSString *stkId;
@property (copy, readonly, nonatomic) NSString *documentName;
@property (copy, readonly, nonatomic) NSString *documentLocation;
@property (assign, readonly, nonatomic) NSInteger status;
@property (copy, readonly, nonatomic) NSString *originalCreateDate;
@property (readonly, nonatomic) NSDate *createDate;
@property (copy, readonly, nonatomic) NSString *updateDate;
@property (assign, readonly, nonatomic) NSInteger type;

+ (id)createDocumentInfoFromDictionary:(NSDictionary *)dic;

@end
