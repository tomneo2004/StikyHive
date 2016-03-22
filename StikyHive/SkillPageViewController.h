//
//  SkillPageViewController.h
//  StikyHive
//
//  Created by THV1WP15S on 23/9/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface SkillPageViewController : UIViewController <UIWebViewDelegate,UIScrollViewDelegate,UITextFieldDelegate, UIAlertViewDelegate, FBSDKSharingDelegate>


@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;

- (void)setSkillID:(NSString *)skillID;


@end
