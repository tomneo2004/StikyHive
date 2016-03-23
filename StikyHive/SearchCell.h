//
//  SearchCell.h
//  StikyHive
//
//  Created by User on 23/3/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

@class SearchCell;

@protocol SearchCellDelegate <NSObject>

@optional
/**
 * Call when person's profile picture tapped
 */
- (void)searchCellDidTapPersonAvatar:(SearchCell *)cell;

- (void)searchCellDidTapThumbnailImage:(SearchCell *)cell;

@end

@interface SearchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) id<SearchCellDelegate> delegate;
@property (assign, nonatomic) BOOL isVideo;

- (void)displayThumbnailImageWithUrl:(NSString *)url;
- (void)displayProfilePictureWithURL:(NSString *)url;

@end
