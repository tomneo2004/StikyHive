//
//  CommentsViewController.h
//  StikyHive
//
//  Created by User on 18/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentInfo.h"

@protocol CommentsViewControllerDelegate <NSObject>

@optional
- (void)commentSeeAllTap;
- (void)commentPostCommentTap;

@end

@interface CommentsViewController : UIViewController

@property (weak, nonatomic) id<CommentsViewControllerDelegate> delegate;

- (void)refreshViewWithCommentInfo:(CommentInfo *)info;


@end
