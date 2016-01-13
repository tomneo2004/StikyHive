//
//  NoExperienceView.h
//  StikyHive
//
//  Created by THV1WP15S on 13/1/16.
//  Copyright (c) 2016 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoExperienceViewDelegate <NSObject>

@optional
- (void)onAddJobTapped;

@end

@interface NoExperienceView : UIView

@property (weak, nonatomic) id<NoExperienceViewDelegate> delegate;
- (IBAction)addInfoTapped:(id)sender;

@end
