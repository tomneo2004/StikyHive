//
//  ObjectCache.m
//  StikyHive
//
//  Created by User on 13/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "ObjectCache.h"

@implementation ObjectCache{
    
    NSCache *cache;
}

static ObjectCache *_instance;

- (id)init{
    
    if(self = [super init]){
        
        cache = [[NSCache alloc] init];
        cache.name = @"ObjectCache";
    }
    
    return self;
}

+ (id)sharedObjectCache{
    
    if(_instance == nil){
        
        _instance = [[ObjectCache alloc] init];
    }
    
    return _instance;
}

- (void)setObject:(id)obj forKey:(NSString *)key{
    
    [cache setObject:obj forKey:key];
}

- (id)getObjectForKey:(NSString *)key{
    
    return [cache objectForKey:key];
}


@end
