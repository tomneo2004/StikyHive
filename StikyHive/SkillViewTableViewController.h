//
//  SkillViewTableViewController.h
//  StikyHive
//
//  Created by User on 17/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsViewController.h"
#import "ReviewsViewController.h"

@interface SkillViewTableViewController : UITableViewController<CommentsViewControllerDelegate, ReviewsViewControllerDelegate>

@property (copy, nonatomic) NSString *skillId;

@end
