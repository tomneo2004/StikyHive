//
//  ViewControllerUtil.h
//  StikyHive
//
//  Created by Koh Quee Boon on 8/6/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerUtil : NSObject

+ (UIViewController *)instantiateViewController:(NSString *)storyBoardID;
+ (UIViewController *) instantiateEntryView;

+ (void)updateImageView:(UIImageView *)view withPath:(NSString *)imagePath defaultName:(NSString *)name;
+ (void)cacheImageForPath:(NSString *) path completion:(void (^)(NSObject *, NSError *))completion;
+ (UIImage *)getImageForPath:(NSString *)path;

+ (UILabel *)getLabelForTitle:(NSString *)title
                      xOffset:(CGFloat)x yOffset:(CGFloat)y
                        width:(CGFloat)w heigth:(CGFloat)h
                   withTarget:(id)target forSelector:(SEL)sel
                       andTag:(NSInteger)tag;


+ (UIImage *)getImageWithPath:(NSString *)urlString;


+ (UIView *)getViewWithImageURL:(NSString *)imageURLStr
                        xOffset:(CGFloat)x yOffset:(CGFloat)y
                          width:(CGFloat)w heigth:(CGFloat)h
                     withTarget:(id)target forSelector:(SEL)sel
                         andTag:(NSInteger)tag
                   defaultPhoto:(NSString *)defaultPhotoName;

+ (UIView *)getViewWithImageURLNormal:(NSString *)imageURLStr
                              xOffset:(CGFloat)x yOffset:(CGFloat)y
                                width:(CGFloat)w heigth:(CGFloat)h
                         defaultPhoto:(NSString *)defaultPhotoName;



+ (void)showFullPhoto:(NSString *)photoURLPath onViewController:(UIViewController *) parentVC;

+ (UIBarButtonItem *)createBarButton:(NSString *)imageName onTarget:(id)target withSelector:(SEL)sel;

+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;

+ (CGFloat)heightOfUITextViewWithText:(UITextView *)textView;

+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;

+ (NSString *)getCurrentDateTimeWithFormat:(NSString *)format;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+ (UILabel *)createBadgeWithText:(NSString *)text atX:(CGFloat)x andY:(CGFloat)y;

+ (BOOL)isLoggedIn;

@end
