//
//  MySkillCell.h
//  StikyHive
//
//  Created by User on 17/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MySkillCell;

@protocol MySkillCellDelegate <NSObject>

@optional
- (void)onEditTap:(MySkillCell *)cell;
- (void)onViewTap:(MySkillCell *)cell;
-(void)onDeleteTap:(MySkillCell *)cell;

@end

@interface MySkillCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak , nonatomic) IBOutlet UILabel *issueDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *expiredDateLabel;
@property (weak, nonatomic) id<MySkillCellDelegate> delegate;

@end
