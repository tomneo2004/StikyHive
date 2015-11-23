//
//  UrgentRequestViewController.h
//  StikyHive
//
//  Created by User on 17/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrgentRequestCell.h"
#import "TitleViewController.h"

@interface UrgentRequestViewController : TitleViewController<UITableViewDataSource, UITableViewDelegate, UrgentRequestCellDelegate>

@end
