//
//  SkillPageViewController.h
//  StikyHive
//
//  Created by THV1WP15S on 23/9/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkillPageViewController : UIViewController <UIWebViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;

- (void)setSkillID:(NSString *)skillID;


@end
