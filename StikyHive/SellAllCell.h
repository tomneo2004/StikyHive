//
//  SellAllCell.h
//  StikyHive
//
//  Created by THV1WP15S on 23/3/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SellAllCell;

@protocol SellAllCellDelegate <NSObject>

@optional




@end

@interface SellAllCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *skillImageView;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (assign, nonatomic) BOOL isVideo;


@property (weak, nonatomic) id<SellAllCellDelegate> delegate;


- (void)displayProfileImage:(NSString *)url;
- (void)displaySkillImage:(NSString *)url;


@end
