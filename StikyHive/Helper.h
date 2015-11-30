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

/**
 * Use this method to retrieve a view from xib file that was designed in IB
 */
+ (UIView *)viewFromNib:(NSString *)nibName atViewIndex:(NSUInteger)viewIndex owner:(id)owner;


/**
 * Measure height of UITextView by its content
 */
+ (CGFloat)measureHeightOfUITextView:(UITextView *)textView DEPRECATED_MSG_ATTRIBUTE("This will be removed");

/**
 * Scale UIImage to a size
 */
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
