//
//  PostRequestManager.m
//  StikyHive
//
//  Created by User on 27/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "PostRequestManager.h"

@interface PostRequestManager ()



@end

@implementation PostRequestManager{
    
    NSString *_title;
    NSString *_description;
    UIImage *_attachmentImage;
}

static PostRequestManager *_instance;

+ (PostRequestManager *)sharedPostRequestManager{
    
    if(_instance == nil){
        
        _instance = [[PostRequestManager alloc] init];
    }
    
    return _instance;
}

#pragma mark - Setter
- (void)setTitle:(NSString *)title{
    
    _title = title;
}

- (void)setPostDesc:(NSString *)postDesc{
    
    _description = postDesc;
}

- (void)setAttachmentImage:(UIImage *)attachmentImage{
    
    _attachmentImage = attachmentImage;
}

#pragma mark - Getter
- (NSString *)getTitle{
    
    return _title;
}

- (NSString *)getPostDesc{
    
    return _description;
}

- (UIImage *)getAttachmentImage{
    
    return _attachmentImage;
}

#pragma mark - public interface
- (void)clearCurrentPostRequest{
    
    _title = nil;
    _description = nil;
    _attachmentImage = nil;
}

@end
