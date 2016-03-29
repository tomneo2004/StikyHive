//
//  BuyerPostViewController.h
//  StikyHive
//
//  Created by THV1WP15S on 19/10/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface BuyerPostViewController : UIViewController <UIWebViewDelegate,UIScrollViewDelegate,FBSDKSharingDelegate, UIAlertViewDelegate>


@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;


- (void)setBuyerId:(NSInteger)buyerId;

- (void)setPictureLocation:(NSString *)location;

@end
