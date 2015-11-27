//
//  RequestCell.h
//  StikyHive
//
//  Created by User on 13/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestCell.h"

@class  UrgentRequestCell;

@protocol UrgentRequestCellDelegate <NSObject>

@optional
/**
 * Call when person's proflile picture tapped
 */
- (void)urgentRequestCellDidTapPersonAvatar:(UrgentRequestCell *)requestCell;

/**
 * Call when attachment button tapped
 */
- (void)urgentRequestCellDidTapImageAttachment:(UrgentRequestCell *)requestCell;

/**
 * Call when phone call button tapped
 */
- (void)urgentRequestCellDidTapVoiceCommunication:(UrgentRequestCell *)requestCell;

/**
 * Call when chat button tapped
 */
- (void)urgentRequestCellDidTapChat:(UrgentRequestCell *)requestCell;

@end

@interface UrgentRequestCell : RequestCell

@property (setter=setIsMyRequest:, nonatomic) BOOL isMyRequest;

@end
