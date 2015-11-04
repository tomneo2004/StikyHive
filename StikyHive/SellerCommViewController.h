//
//  SellerCommViewController.h
//  StikyHive
//
//  Created by THV1WP15S on 8/10/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellerCommViewController : UIViewController <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;


- (void)setSkillID:(NSString *)skillID;

@end
