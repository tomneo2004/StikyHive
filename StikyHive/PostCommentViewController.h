//
//  PostCommentViewController.h
//  StikyHive
//
//  Created by User on 21/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "OverlayViewController.h"

@class PostCommentViewController;

@protocol PostCommentViewControllerDelegate <NSObject>

@optional
- (void)onPostCommentClose;
- (void)onPostCommentPostSuccessful:(PostCommentViewController *)controller;

@end

@interface PostCommentViewController : OverlayViewController

@property (weak, nonatomic) id<PostCommentViewControllerDelegate> delegate;

@end
