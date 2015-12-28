//
//  SeeAllCommentViewController.h
//  StikyHive
//
//  Created by User on 21/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeeAllCommentViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (copy, nonatomic) NSMutableArray *commentsData;

@end
