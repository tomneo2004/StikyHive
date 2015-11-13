//
//  ObjectCache.h
//  StikyHive
//
//  Created by User on 13/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectCache : NSObject

+ (id)sharedObjectCache;
- (void)setObject:(id)obj forKey:(NSString *)key;
- (id)getObjectForKey:(NSString *)key;

@end
