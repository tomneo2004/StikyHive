//
//  EducationCell.h
//  StikyHive
//
//  Created by User on 5/1/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EducationCell;

@protocol EducationCellDelegate <NSObject>

@optional
- (void)onEdit:(EducationCell *)cell;
- (void)onDelete:(EducationCell *)cell;

@end

@interface EducationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *instituteLabel;
@property (weak, nonatomic) IBOutlet UILabel *qualificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) id<EducationCellDelegate> delegate;

@end
