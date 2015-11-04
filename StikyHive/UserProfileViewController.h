//
//  UserProfileViewController.h
//  StikyHive
//
//  Created by THV1WP15S on 23/10/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileViewController : UIViewController <UIWebViewDelegate ,UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;


- (void)setStkID:(NSString *)stkid;


@end
