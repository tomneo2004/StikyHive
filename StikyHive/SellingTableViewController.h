//
//  SellingTableViewController.h
//  StikyHive
//
//  Created by THV1WP15S on 9/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellingCell.h"
#import "CropPhotoViewController.h"

@interface SellingTableViewController : CropPhotoViewController <UITableViewDataSource,UITableViewDelegate,SellingCellDelegate>

- (IBAction)nextBtnPressed:(id)sender;

@end
