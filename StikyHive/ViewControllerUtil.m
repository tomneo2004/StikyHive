//
//  ViewControllerUtil.m
//  StikyHive
//
//  Created by Koh Quee Boon on 8/6/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "ViewControllerUtil.h"
#import "PhotoViewController.h"
#import "LocalDataInterface.h"
#import "UIImageView+AFNetworking.h"


@implementation ViewControllerUtil

+ (UIViewController *)instantiateViewController:(NSString *)storyBoardID
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [mainStoryboard instantiateViewControllerWithIdentifier:storyBoardID];
}

+ (void)updateImageView:(UIImageView *)view withPath:(NSString *)imagePath defaultName:(NSString *)name
{
    view.image = [ViewControllerUtil getImageForPath:imagePath];
    if (!view.image)
    {
        [self cacheImageForPath:imagePath completion:^(NSObject *obj, NSError *err)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 view.image = obj ? (UIImage *)obj : [UIImage imageNamed:name];
             });
         }];
    }
}

+ (void)cacheImageForPath:(NSString *)urlPath completion:(void (^)(NSObject *, NSError *))completion
{
    if (urlPath && ![ViewControllerUtil getImageForPath:urlPath])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlPath]];
            UIImage *image = [UIImage imageWithData:imageData];
            if (image && image.size.width > 0 && image.size.height > 0)
                [LocalDataInterface storeObject:image forKey:urlPath];
            completion(image,nil);
        });
    }
}

+ (UIImage *)getImageForPath:(NSString *)urlPath
{
    NSObject *obj = urlPath ? [LocalDataInterface retrieveObjectForKey:urlPath] : nil;
    return obj ? (UIImage *)obj : nil;
}

+ (UILabel *)getLabelForTitle:(NSString *)title
                      xOffset:(CGFloat)x yOffset:(CGFloat)y
                        width:(CGFloat)w heigth:(CGFloat)h
                   withTarget:(id)target forSelector:(SEL)sel
                       andTag:(NSInteger)tag
{
    CGRect rect = CGRectMake(x,y,w,h);
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = title;
    label.tag = tag;
    label.userInteractionEnabled = YES;
//    label.textColor = [UIColor colorWithRed:18.0/255 green:148.0/255 blue:133.0/255 alpha:1.0];
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target action:sel]];
    return label;
}

////////////////////////// ECHO ///////////////////////////////

+ (UIImage *)getImageWithPath:(NSString *)urlString
{
    NSURL *imageUrl = [NSURL URLWithString:urlString];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    UIImage *image = [UIImage imageWithData:imageData];
    
    return image? image : nil;
}


+ (UIView *)getViewWithImageURL:(NSString *)imageURLStr
                        xOffset:(CGFloat)x yOffset:(CGFloat)y
                          width:(CGFloat)w heigth:(CGFloat)h
                     withTarget:(id)target forSelector:(SEL)sel
                         andTag:(NSInteger)tag
                   defaultPhoto:(NSString *)defaultPhotoName
{
    
    
    NSURL *imageURL = [NSURL URLWithString:imageURLStr];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    
    
//    UIImage *image = [ViewControllerUtil getImageForPath:imageURLStr];
    if (!image)
    {
        [ViewControllerUtil cacheImageForPath:imageURLStr completion:^(NSObject *obj, NSError *err)
        {
        }];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLStr]];
        image = [[UIImage alloc] initWithData:data];
    }
    
    if (!image) // Image path is wrong, or contains no valid image
    {
        image = [UIImage imageNamed:defaultPhotoName];
    }
    
    CGRect rect = CGRectMake(0,0,w,h);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
     //    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
     //      NSData *imageData = UIImagePNGRepresentation(picture1);
//    NSData *imgData = UIImageJPEGRepresentation(picture1, 1.0);
//    UIImage *img = [UIImage imageWithData:imgData];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage: img];
    
    __block UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:imageURL] placeholderImage:[UIImage imageNamed:defaultPhotoName] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        imageView.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        
    }];
    
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target action:sel]];
    imageView.tag = tag;
    
    
    CGRect frame = CGRectMake(x, y, w, h);
    UIView *subview = [[UIView alloc] initWithFrame:frame];
    [subview addSubview:imageView];
    
    return subview;
}


+ (UIView *)getViewWithImageURLNormal:(NSString *)imageURLStr
                        xOffset:(CGFloat)x yOffset:(CGFloat)y
                          width:(CGFloat)w heigth:(CGFloat)h
                   defaultPhoto:(NSString *)defaultPhotoName
{
    
    
    NSURL *imageURL = [NSURL URLWithString:imageURLStr];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    
    
    //    UIImage *image = [ViewControllerUtil getImageForPath:imageURLStr];
    if (!image)
    {
        [ViewControllerUtil cacheImageForPath:imageURLStr completion:^(NSObject *obj, NSError *err)
         {
         }];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLStr]];
        image = [[UIImage alloc] initWithData:data];
    }
    
    if (!image) // Image path is wrong, or contains no valid image
    {
        image = [UIImage imageNamed:defaultPhotoName];
    }
    
    CGRect rect = CGRectMake(0,0,w,h);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //  NSData *imageData = UIImagePNGRepresentation(picture1);
    NSData *imgData = UIImageJPEGRepresentation(picture1, 1.0);
    UIImage *img = [UIImage imageWithData:imgData];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    imageView.userInteractionEnabled = YES;
    
    CGRect frame = CGRectMake(x, y, w, h);
    UIView *subview = [[UIView alloc] initWithFrame:frame];
    [subview addSubview:imageView];
    
    return subview;
}


//////////////////////// END /////////////////////////////////

+ (BOOL) isLoggedIn
{
    return [LocalDataInterface retrieveUsername] ? YES : NO;
}

+ (void)showFullPhoto:(NSString *)fullPhotoPath onViewController:(UIViewController *) parentVC
{
    [PhotoViewController setPhotoPath:fullPhotoPath];
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"photo_view_controller"];
    [parentVC.navigationController pushViewController:vc animated:YES];
}

+ (UIViewController *) instantiateEntryView
{
    return [ViewControllerUtil instantiateViewController:@"entry_view_controller"];
}

+ (UIBarButtonItem *)createBarButton:(NSString *)imageName onTarget:(id)target withSelector:(SEL)sel
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIBarButtonItemStyle style = UIBarButtonItemStylePlain;
    return [[UIBarButtonItem alloc] initWithImage:image style:style target:target action:sel];
}

+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    //-----------------------------------------
    // Convert hex string to an integer
    //-----------------------------------------
    unsigned int hexint = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet
                                       characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexint];
    
    //-----------------------------------------
    // Create color object, specifying alpha
    //-----------------------------------------
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}

+ (CGFloat)heightOfUITextViewWithText:(UITextView *)textView
{
    CGRect frame = textView.bounds;
    
    UIEdgeInsets textContainerInsets = textView.textContainerInset;
    UIEdgeInsets contentInsets = textView.contentInset;
    
    CGFloat linePad = textView.textContainer.lineFragmentPadding * 2;
    CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + linePad + contentInsets.left + contentInsets.right;
    CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
    
    frame.size.width -= leftRightPadding;
    frame.size.height -= topBottomPadding;
    
    NSString *textToMeasure = textView.text;
    if ([textToMeasure hasSuffix:@"\n"])
        textToMeasure = [NSString stringWithFormat:@"%@-", textView.text];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    
    //    NSDictionary *attributes = @{ NSFontAttributeName: textView.font, NSParagraphStyleAttributeName : paragraphStyle };
    NSDictionary *attributes = nil;
    
    CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    
    return ceilf(CGRectGetHeight(size) + topBottomPadding);
}

+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

+ (NSString *)getCurrentDateTimeWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:[NSDate date]];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UILabel *)createBadgeWithText:(NSString *)text atX:(CGFloat)x andY:(CGFloat)y
{
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 20, 20)];
    numLabel.layer.cornerRadius = 10;
    [numLabel.layer setMasksToBounds:YES];
    numLabel.backgroundColor = [UIColor redColor];
    numLabel.textColor = [UIColor whiteColor];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.text = text;
    return numLabel;
}

@end
