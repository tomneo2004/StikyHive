//
//  AvatarView.h
//  StikyHive
//
//  Created by User on 28/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ThumbnailView : UIView

- (void)setImageViewTag:(NSInteger)tag;
- (void)setTapTarget:(id)target andAction:(SEL)action;
- (void)displayImageWithURL:(NSURL *)imageURL withWidth:(CGFloat)width withHeight:(CGFloat)height withDefaultPhotoName:(NSString *)defaultPhotoName;

@end
