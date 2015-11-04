//
//  Document.h
//  StikyHive
//
//  Created by Koh Quee Boon on 15/7/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Document : NSObject

@property (nonatomic, assign) NSInteger documentID;
@property (nonatomic, copy) NSString *ownerID;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *filePath;

- (id) initWithID:(NSInteger)documentID
          ownerID:(NSString *)ownerID
         fileName:(NSString *)fileName
         filePath:(NSString *)filePath;

@end
