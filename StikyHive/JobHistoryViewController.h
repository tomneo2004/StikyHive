//
//  JobHistoryViewController.h
//  StikyHive
//
//  Created by THV1WP15S on 5/1/16.
//  Copyright (c) 2016 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobHistoryCell.h"

@interface JobHistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UITableView *jobTableView;




- (IBAction)addNewBtnTapped:(id)sender;

@end
