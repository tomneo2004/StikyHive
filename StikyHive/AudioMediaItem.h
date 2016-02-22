//
//  AudioMediaItem.h
//  StikyHive
//
//  Created by User on 15/2/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "JSQMediaItem.h"


@interface AudioMediaItem : JSQMediaItem<JSQMessageMediaData, NSCoding, NSCopying>

@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, strong) NSNumber *duration;

- (instancetype)initWithFileURL:(NSURL *)fileURL Duration:(NSNumber *)duration;

@end
