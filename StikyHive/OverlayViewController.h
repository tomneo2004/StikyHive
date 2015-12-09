//
//  OverlayViewController.h
//  StikyHive
//
//  Created by User on 9/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OverlayViewController;

typedef void(^dismissComplete)(void);
typedef void(^didPresentView)(OverlayViewController *);

@interface OverlayViewController : UIViewController

- (void)presentOverlay:(didPresentView)presentComplete;
- (void)dismissOverlay:(dismissComplete)complete;
- (void)didAddView;

@end
