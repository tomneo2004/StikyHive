//
//  Helper.m
//  StikyHive
//
//  Created by User on 16/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+ (UIView *)viewFromNib:(NSString *)nibName atViewIndex:(NSUInteger)viewIndex owner:(id)owner{

    if(!nibName || !owner)
        return nil;
    
    if([[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"]){
        
        NSArray *viewArray = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil];
        
        UIView *view = [viewArray objectAtIndex:viewIndex];
        
        return view;
    }
    
    return nil;
}

+ (CGFloat)measureHeightOfUITextView:(UITextView *)textView
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        // This is the code for iOS 7. contentSize no longer returns the correct value, so
        // we have to calculate it.
        //
        // This is partly borrowed from HPGrowingTextView, but I've replaced the
        // magic fudge factors with the calculated values (having worked out where
        // they came from)
        
        CGRect frame = textView.bounds;
        
        // Take account of the padding added around the text.
        
        UIEdgeInsets textContainerInsets = textView.textContainerInset;
        UIEdgeInsets contentInsets = textView.contentInset;
        
        CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + textView.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
        CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
        
        frame.size.width -= leftRightPadding;
        frame.size.height -= topBottomPadding;
        
        NSString *textToMeasure = textView.text;
        if ([textToMeasure hasSuffix:@"\n"])
        {
            textToMeasure = [NSString stringWithFormat:@"%@-", textView.text];
        }
        
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName: textView.font, NSParagraphStyleAttributeName : paragraphStyle };
        
        CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        
        CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + topBottomPadding);
        return measuredHeight;
    }
    else
    {
        return textView.contentSize.height;
    }
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (NSString *)documentPaht{
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths objectAtIndex:0];
    
    return documentPath;
}

+ (NSString *)filePathFromDocument:(NSString *)fileName extension:(NSString *)fileExtension{
    
    if([self isFileExistInDocument:fileName extension:fileExtension]){
        
        NSString *fullPath = [[self documentPaht] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", fileName, fileExtension]];
        
        return fullPath;
    }
    
    return nil;
}

+ (BOOL)isFileExistInDocument:(NSString *)fileName extension:(NSString *)fileExtension{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *fullPath = [[self documentPaht] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", fileName, fileExtension]];
    
    return [fileManager fileExistsAtPath:fullPath];
}

+ (BOOL)deleteFileInDocument:(NSString *)fileName extension:(NSString *)fileExtension{
    
    if([self isFileExistInDocument:fileName extension:fileExtension]){
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *fullPath = [[self documentPaht] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", fileName, fileExtension]];
        
        NSError *error = nil;
        
        [fileManager removeItemAtPath:fullPath error:&error];
        
        if(error != nil)
            return NO;
        
        return YES;
    }
    
    return NO;
}

+ (BOOL)writeFileIntoDocumentWithData:(NSData *)data withFileName:(NSString *)fileName withFileExtension:(NSString *)fileExtension{
    
    NSString *fullPath = [[self documentPaht] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", fileName, fileExtension]];
    
    return [data writeToFile:fullPath atomically:YES];
}

@end
