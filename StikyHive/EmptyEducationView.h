//
//  EmptyEducationView.h
//  StikyHive
//
//  Created by User on 12/1/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmptyEducationViewDelegate <NSObject>

@optional
- (void)onAddInfoTap;

@end

@interface EmptyEducationView : UIView

@property (weak, nonatomic) id<EmptyEducationViewDelegate> delegate;

@end
