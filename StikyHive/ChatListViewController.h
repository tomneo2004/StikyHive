//
//  ChatListViewController.h
//  StikyHive
//
//  Created by THV1WP15S on 18/1/16.
//  Copyright (c) 2016 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CHAT_TABLE_VIEW_IMAGE_VIEW_TAG 101
#define CHAT_TABLE_VIEW_NAME_LABEL_TAG 102
#define CHAT_TABLE_VIEW_MSG_LABLE_TAG 103
#define CHAT_TABLE_VIEW_TIME_LABLE_TAG 104

@interface ChatListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>



@property (strong, nonatomic) IBOutlet UITableView *chatTableView;


@end
