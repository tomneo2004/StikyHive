//
//  SellAllViewController.h
//  StikyHive
//
//  Created by THV1WP15S on 23/3/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellAllCell.h"

@interface SellAllViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SellAllCellDelegate>



@property (strong, nonatomic) IBOutlet UITableView *sellTableView;


@end
