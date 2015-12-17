//
//  ImageCaption.m
//  StikyHive
//
//  Created by THV1WP15S on 14/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "ImageCaption.h"

@implementation ImageCaption


- (id)initWithImage:(UIImage *)image caption:(NSString *)caption
{
    self = [super init];
    
    if (self) {
        
        _image = image;
        _caption = caption;
        
    }
    
    return self;
}


- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        _image = [decoder decodeObjectForKey:@"Image"];
        _caption = [decoder decodeObjectForKey:@"Caption"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    
    [encoder encodeObject:_image forKey:@"Image"];
    [encoder encodeObject:_caption forKey:@"Caption"];
    
}





@end
