//
//  ReadReviewViewController.h
//  StikyHive
//
//  Created by User on 9/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "OverlayViewController.h"

@class ReadReviewViewController;

@protocol ReadReviewViewControllerDelegate <NSObject>

@optional
- (void)onEditTap:(ReadReviewViewController *)controller;

/**
 * Automatically close view for you
 */
- (void)onClose;

@end

@interface ReadReviewViewController : OverlayViewController

@property (weak, nonatomic) id<ReadReviewViewControllerDelegate> delegate;
@property (setter=setReviewTitle:, nonatomic) NSString *reviewTitle;
@property (setter=setRating:, nonatomic) NSInteger rating;
@property (setter=setReview:, nonatomic) NSString *review;

@end
