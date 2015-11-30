//
//  RequestCell.h
//  StikyHive
//
//  Created by User on 16/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * A parent class of MyRequestCell and UrgentRequestCell
 */
@interface RequestCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) id delegate;

/**
 * Display person's profile picture
 */
- (void)displayProfilePictureWithURL:(NSString *)url;

@end
