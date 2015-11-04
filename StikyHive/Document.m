//
//  Document.m
//  StikyHive
//
//  Created by Koh Quee Boon on 15/7/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "Document.h"

@implementation Document

- (id) initWithID:(NSInteger)documentID
          ownerID:(NSString *)ownerID
         fileName:(NSString *)fileName
         filePath:(NSString *)filePath
{
    self = [super init];
    if (self)
    {
        _documentID = documentID;
        _ownerID = ownerID;
        _fileName = fileName;
        _filePath = filePath;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        _documentID = [decoder decodeIntegerForKey:@"Document_documentID"];
        _ownerID = [decoder decodeObjectForKey:@"Document_ownerID"];
        _fileName = [decoder decodeObjectForKey:@"Document_fileName"];
        _filePath = [decoder decodeObjectForKey:@"Document_filePath"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:_documentID forKey:@"Document_documentID"];
    [encoder encodeObject:_ownerID forKey:@"Document_ownerID"];
    [encoder encodeObject:_fileName forKey:@"Document_fileName"];
    [encoder encodeObject:_filePath forKey:@"Document_filePath"];
}

@end
