//
//  PostReviewViewController.h
//  StikyHive
//
//  Created by User on 9/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "OverlayViewController.h"

@class PostReviewViewController;

@protocol PostReviewViewControllerDelegate <NSObject>

@required
- (NSString *)commentIdForUpdateReview;

@optional
- (void)onPostReviewClose;
- (void)onPostReviewUpdateSuccessful:(PostReviewViewController *)controller;

@end

@interface PostReviewViewController : OverlayViewController

@property (weak, nonatomic) id<PostReviewViewControllerDelegate> delegate;
@property (setter=setRating:, nonatomic) NSInteger rating;
@property (setter=setReview:, nonatomic) NSString *review;

@end
