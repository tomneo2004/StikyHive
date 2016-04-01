//
//  ITTableViewController.h
//  StikyHive
//
//  Created by User on 1/4/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    unknow,
    industry,
    talent
} ITCat;

@interface ITTableViewController : UITableViewController

@property (nonatomic, assign) ITCat catToShow;

@end
