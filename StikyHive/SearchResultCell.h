//
//  SearchResultCell.h
//  StikyHive
//
//  Created by User on 24/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchResultCell;

@protocol SearchResultCellDelegate <NSObject>

@optional
- (void)SearchResultDidTapPhoneCall:(SearchResultCell *)cell;
- (void)SearchResultDidTapChat:(SearchResultCell *)cell;

@end

@interface SearchResultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) id<SearchResultCellDelegate> delegate;

- (void)displayProfilePictureWithURL:(NSString *)url;

@end
