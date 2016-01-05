//
//  EducationViewController.h
//  StikyHive
//
//  Created by User on 5/1/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EducationCell.h"
#import "EditEducationTableViewController.h"

@interface EducationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, EducationCellDelegate, EditDeucationDelegate, UINavigationControllerDelegate>

@end
