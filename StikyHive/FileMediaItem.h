//
//  FileMediaItem.h
//  StikyHive
//
//  Created by User on 7/3/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "JSQMediaItem.h"

#define openFileRequired @"openFile"

@interface FileMediaItem : JSQMediaItem<JSQMessageMediaData, NSCoding, NSCopying>

- (instancetype)initWithFileURLString:(NSString *)theFileURL;
- (void)downloadFile;

@end
