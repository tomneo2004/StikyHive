//
//  ContactViewController.h
//  StikyHive
//
//  Created by User on 4/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleViewController.h"
#import "ContactCell.h"

@interface ContactViewController : TitleViewController<UITableViewDataSource, UITableViewDelegate, ContactCellDelegate>

@end
