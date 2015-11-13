//
//  RequestCell.h
//  StikyHive
//
//  Created by User on 13/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  RequestCell;

@protocol RequestCellDelegate <NSObject>

@optional

- (void)requestCellDidTapPersonAvatar:(RequestCell *)requestCell;
- (void)requestCellDidTapImageAttachment:(RequestCell *)requestCell;
- (void)requestCellDidTapVoiceCommunication:(RequestCell *)requestCell;
- (void)requestCellDidTapChat:(RequestCell *)requestCell;

@end

@interface RequestCell : UITableViewCell

/**
 * this is only used for position reference
 */
@property (weak, nonatomic) IBOutlet UIView *imageContainer;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) id<RequestCellDelegate> delegate;

- (void)displayProfilePictureWithURL:(NSString *)url withUniqueId:(NSString *)uniqueId;

@end
