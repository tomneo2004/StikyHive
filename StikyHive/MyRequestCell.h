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
/**
 * Call when person's profile picture tapped
 */
- (void)myRequestCellDidTapPersonAvatar:(MyRequestCell *)requestCell;

/**
 * Call when attachement button tapped
 */
- (void)myRequestCellDidTapImageAttachment:(MyRequestCell *)requestCell;

@end

@interface MyRequestCell : RequestCell


@end
