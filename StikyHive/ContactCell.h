//
//  ContactCell.h
//  StikyHive
//
//  Created by User on 4/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactCell;

@protocol  ContactCellDelegate <NSObject>

@optional
- (void)onPhoneCallTap:(ContactCell *)cell;
- (void)onChatTap:(ContactCell *)cell;


@end

@interface ContactCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) id<ContactCellDelegate> delegate;

/**
 * Display person's profile picture
 */
- (void)displayProfilePictureWithURL:(NSString *)url;

@end
