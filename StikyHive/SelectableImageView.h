//
//  SelectableImageView.h
//  StikyHive
//
//  Created by Koh Quee Boon on 8/6/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectableImageView : UIImageView

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger index;

@end
