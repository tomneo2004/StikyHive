//
//  MyRequestSectionTitle.h
//  StikyHive
//
//  Created by User on 16/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyRequestSectionTitleDelegate <NSObject>

@optional
- (void)myRequestSectionSeeAll;

@end

@interface MyRequestSectionTitle : UIView

@property (weak, nonatomic) id delegate;

@end
