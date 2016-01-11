//
//  JobHistoryCell.h
//  StikyHive
//
//  Created by THV1WP15S on 5/1/16.
//  Copyright (c) 2016 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JobHistoryCell;

@protocol JobHistoryCellDelegate <NSObject>

@optional

- (void)onEdit:(JobHistoryCell *)cell;
- (void)onDelete:(JobHistoryCell *)cell;

@end

@interface JobHistoryCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *countryLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) id<JobHistoryCellDelegate> delegate;


- (IBAction)didTapEdit:(id)sender;

- (IBAction)didTapDelete:(id)sender;




@end
