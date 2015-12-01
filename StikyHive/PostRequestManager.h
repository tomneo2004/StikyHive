//
//  PostRequestManager.h
//  StikyHive
//
//  Created by User on 27/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PostRequestManager : NSObject

@property (setter=setTitle:, getter=getTitle, nonatomic) NSString *title;
@property (setter=setPostDesc:, getter=getPostDesc, nonatomic) NSString *postDesc;
@property (setter=setAttachmentImage:, getter=getAttachmentImage, nonatomic) UIImage *attachmentImage;

+ (PostRequestManager *)sharedPostRequestManager;

- (void)clearCurrentPostRequest;

@end
