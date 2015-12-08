//
//  BoughtCell.h
//  StikyHive
//
//  Created by User on 8/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BoughtCell;

@protocol BoughtCellDelegate <NSObject>

@optional
- (void)onReadReviewTap:(BoughtCell *)cell;
- (void)onEditReviewTap:(BoughtCell *)cell;

@end

@interface BoughtCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *boughtFromLabel;
@property (weak, nonatomic) IBOutlet UILabel *onLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (setter=setRating:, nonatomic) NSInteger rating;
@property (weak, nonatomic) id<BoughtCellDelegate> delegate;

- (void)displayPhotoWithURL:(NSString *)url;

@end
