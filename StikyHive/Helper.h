//
//  Helper.h
//  StikyHive
//
//  Created by User on 16/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Helper : NSObject

+ (UIView *)viewFromNib:(NSString *)nibName atViewIndex:(NSUInteger)viewIndex owner:(id)owner;

+ (CGFloat)measureHeightOfUITextView:(UITextView *)textView;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
