//
//  BoughtViewController.h
//  StikyHive
//
//  Created by User on 8/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleViewController.h"
#import "BoughtCell.h"

@interface BoughtViewController : TitleViewController<UITableViewDataSource, UITableViewDelegate, BoughtCellDelegate>

@end
