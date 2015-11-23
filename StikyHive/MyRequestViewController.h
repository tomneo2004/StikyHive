//
//  MyRequestViewController.h
//  StikyHive
//
//  Created by User on 17/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyRequestCell.h"
#import "TitleViewController.h"

@interface MyRequestViewController : TitleViewController<UITableViewDataSource, UITableViewDelegate, MyRequestCellDelegate>

@end
