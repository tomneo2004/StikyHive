//
//  MyRequestCell.h
//  StikyHive
//
//  Created by User on 16/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestCell.h"

@class MyRequestCell;

@protocol MyRequestCellDelegate <NSObject>

@optional
- (void)myRequestCellDidTapPersonAvatar:(MyRequestCell *)requestCell;
- (void)myRequestCellDidTapImageAttachment:(MyRequestCell *)requestCell;

@end

@interface MyRequestCell : RequestCell


@end
