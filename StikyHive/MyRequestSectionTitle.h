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
/**
 * Call when SeeAll button tapped
 */
- (void)myRequestSectionSeeAll;

@end

/**
 * Represent MyRequestSection title in table view
 */
@interface MyRequestSectionTitle : UIView

@property (weak, nonatomic) id delegate;

@end
