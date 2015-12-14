//
//  ImageCaption.h
//  StikyHive
//
//  Created by THV1WP15S on 14/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageCaption : NSObject


@property (setter=setImage:, getter=getImage, nonatomic) UIImage *image;
@property (setter=setCaption:, getter=getCaption, nonatomic) NSString *caption;

@end
