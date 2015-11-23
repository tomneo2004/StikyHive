//
//  Section.m
//  StikyHive
//
//  Created by User on 16/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "Section.h"

@implementation Section{
    
    NSArray *_data;
}

- (id)initWithDataArray:(NSArray *)dataArray{
    
    if(self = [super init]){
     
        _data = dataArray;
    }
    
    return self;
}

- (BOOL)isSectionAClass:(Class)classToCompare{
    
    if(!_data || _data.count <= 0)
        return NO;
    
    id obj = [_data objectAtIndex:0];
    
    return [obj isKindOfClass:classToCompare];
}

- (NSArray *)dataArray{
    
    return _data;
}

@end
