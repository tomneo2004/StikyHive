//
//  CommentsViewController.h
//  StikyHive
//
//  Created by User on 18/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentInfo.h"

@interface CommentsViewController : UIViewController


- (void)refreshViewWithCommentInfo:(CommentInfo *)info;

@end
