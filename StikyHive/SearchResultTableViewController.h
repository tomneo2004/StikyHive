//
//  SearchResultTableViewController.h
//  StikyHive
//
//  Created by User on 24/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultCell.h"

@interface SearchResultTableViewController : UITableViewController<SearchResultCellDelegate>

@property (setter=setSearchResult:, nonatomic) NSArray *searchResult;

@end
