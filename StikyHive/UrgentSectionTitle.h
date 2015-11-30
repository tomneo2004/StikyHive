//
//  UrgentSectionTitle.h
//  StikyHive
//
//  Created by User on 16/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UrgentSectionTitleDelegate <NSObject>

@optional
/**
 * Call when SeeAll button tapped
 */
- (void)urgentSectionSeeAll;

@end

/**
 * Represent UrgentSection title in table view
 */
@interface UrgentSectionTitle : UIView

@property (weak, nonatomic) id delegate;

@end
