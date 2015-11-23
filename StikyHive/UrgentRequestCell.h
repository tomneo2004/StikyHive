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

- (void)urgentRequestCellDidTapPersonAvatar:(UrgentRequestCell *)requestCell;
- (void)urgentRequestCellDidTapImageAttachment:(UrgentRequestCell *)requestCell;
- (void)urgentRequestCellDidTapVoiceCommunication:(UrgentRequestCell *)requestCell;
- (void)urgentRequestCellDidTapChat:(UrgentRequestCell *)requestCell;

@end

@interface UrgentRequestCell : RequestCell


@end
