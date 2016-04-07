//
//  ImageCaption.m
//  StikyHive
//
//  Created by THV1WP15S on 14/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "ImageCaption.h"
#import "AFNetworking.h"

@implementation ImageCaption{
    
    AFHTTPRequestOperation *imageOp;
}

+ (id)emptyImageCaptionDelegate:(id<ImageCaptionDelegate>)del{
    
    ImageCaption *ret = [[ImageCaption alloc] init];
    ret.delegate = del;
    
    return ret;
}

- (id)init{
    
    self = [super init];
    
    if (self) {
        
        _image = nil;
        _caption = @"";
        _photoId = 0;
        _edit = NO;
    }
    
    return self;
    
}

- (id)initWithImage:(UIImage *)image caption:(NSString *)caption
{
    self = [super init];
    
    if (self) {
        
        _image = image;
        _caption = caption;
        _photoId = 0;
        _edit = NO;
    }
    
    return self;
}

- (id)initWithImageURL:(NSString *)imageURL caption:(NSString *)caption photoId:(NSUInteger)pId delegate:(id<ImageCaptionDelegate>)del{
    
    self = [super init];
    
    if (self) {
        
        _delegate = del;
        _image = nil;
        _caption = caption;
        _photoId = pId;
        _edit = YES;
        
        imageOp = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]]];
        imageOp.responseSerializer = [AFImageResponseSerializer serializer];
        
        __weak id<ImageCaptionDelegate> weakDel = _delegate;
        __weak typeof(self) weakSelf = self;
        [imageOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            _image = responseObject;
            
            if([weakDel respondsToSelector:@selector(onImageReady:)]){
                
                [weakDel onImageReady:weakSelf];
            }
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
        }];
        
        [imageOp start];
    }
    
    return self;
}

- (BOOL)isPrepared{
    
    if(_edit){
        
        if(_image != nil){
            return YES;
        }
        
        return NO;
    }
    else{
        
        return YES;
    }
}

- (void)dealloc{

    if(imageOp){
        [imageOp cancel];
    }
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
