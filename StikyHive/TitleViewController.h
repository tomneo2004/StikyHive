//
//  TitleViewController.h
//  StikyHive
//
//  Created by User on 17/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleViewController : UIViewController

/**
 * Give a title it will show up on navigation bar
 */
@property (copy, nonatomic) IBInspectable NSString *viewControllerTitle;

/**
 * Give a title that will display on back button on navigation bar.
 * Left it as empty it will use previous ViewController's title
 */
@property (copy, nonatomic) IBInspectable NSString *backButtonTitle;

@end
