//
//  ImageCaption.h
//  StikyHive
//
//  Created by THV1WP15S on 14/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ImageCaption;
@protocol ImageCaptionDelegate <NSObject>

@optional
- (void)onImageReady:(ImageCaption *)ic;

@end

@interface ImageCaption : NSObject


@property (nonatomic, copy) UIImage *image;
@property (nonatomic, copy) NSString *caption;
@property (nonatomic, assign) NSUInteger photoId;
@property (nonatomic, assign) BOOL edit;
@property (nonatomic, weak) id<ImageCaptionDelegate> delegate;


+ (id)emptyImageCaptionDelegate:(id<ImageCaptionDelegate>)del;
- (id)initWithImage:(UIImage *)image caption:(NSString *)caption;
- (id)initWithImageURL:(NSString *)imageURL caption:(NSString *)caption photoId:(NSUInteger)pId delegate:(id<ImageCaptionDelegate>)del;
- (BOOL)isPrepared;



@end
