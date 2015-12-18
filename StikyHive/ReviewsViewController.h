//
//  ReviewsViewController.h
//  StikyHive
//
//  Created by User on 18/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewInfo.h"

@interface ReviewsViewController : UIViewController

- (void)refreshViewWithReviewInfo:(ReviewInfo *)info;

@end
