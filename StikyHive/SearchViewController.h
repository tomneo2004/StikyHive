//
//  SearchViewController.h
//  StikyHive
//
//  Created by User on 23/3/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchCell.h"

@interface SearchViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, SearchCellDelegate>

@property (nonatomic, copy) NSString *searchKeyword;

@end
