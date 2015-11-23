//
//  AttachmentViewController.h
//  StikyHive
//
//  Created by User on 17/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleViewController.h"

@interface AttachmentViewController : TitleViewController

/**
 * Give attachment photo URL to show attachment
 */
@property (copy, nonatomic) NSString *attachmentPhotoURL;

@end
