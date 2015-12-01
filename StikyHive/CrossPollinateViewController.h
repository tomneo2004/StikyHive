//
//  CrossPollinateViewController.h
//  StikyHive
//
//  Created by User on 12/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrgentRequestCell.h"
#import "MyRequestCell.h"
#import "UrgentSectionTitle.h"
#import "MyRequestSectionTitle.h"
#import "TitleViewController.h"

@interface CrossPollinateViewController : TitleViewController<UITableViewDataSource, UITableViewDelegate, UrgentRequestCellDelegate, MyRequestCellDelegate, UrgentSectionTitleDelegate, MyRequestSectionTitleDelegate, UISearchBarDelegate, UINavigationControllerDelegate>



@end
