//
//  SearchInfo.m
//  StikyHive
//
//  Created by User on 23/3/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "SearchInfo.h"


@implementation SearchInfo

+ (id)createSearchInfoFromDictionary:(NSDictionary *)dic{
    
    return  [[SearchInfo alloc] initWithDictionary:dic];
}

- (id)initWithDictionary:(NSDictionary *)dic{
    
    if(self = [super init]){
        
        if(![dic[@"thumbnailLocation"] isEqual:[NSNull null]])
            _thumbnailLocation = dic[@"thumbnailLocation"];
        else
            _thumbnailLocation = dic[@"location"];
        
        _profilePicture = dic[@"profilePicture"];
        
        if(![dic[@"videoLocation"] isEqual:[NSNull null]]){
            
            _videoUrl = dic[@"videoLocation"];
        }
        else{
            
            _videoUrl = nil;
        }
        
        _name = dic[@"name"];
        _stkId = dic[@"stkid"];
        _skillId = dic[@"skillId"];
    }
    
    return self;
}

@end
