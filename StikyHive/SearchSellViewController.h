//
//  SearchSellViewController.h
//  StikyHive
//
//  Created by Koh Quee Boon on 9/6/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchSellViewController : UIViewController <UISearchBarDelegate>

- (void)addSearchDelegate:(UISearchBar *)searchBar;
- (void)prepareStartSelling;

@end
