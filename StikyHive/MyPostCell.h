//
//  MyPostCell.h
//  StikyHive
//
//  Created by User on 23/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyPostCell;

@protocol MyPostCellDelegate <NSObject>

@optional
- (void)onEditTap:(MyPostCell *)cell;
- (void)onViewTap:(MyPostCell *)cell;
-(void)onDeleteTap:(MyPostCell *)cell;

@end

@interface MyPostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *postDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *expiredDateLabel;
@property (weak, nonatomic) id<MyPostCellDelegate> delegate;

@end
