//
//  SellerRevViewController.h
//  StikyHive
//
//  Created by THV1WP15S on 14/10/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SELLER_REVIEW_TAG_PROFILE_IMAGE 205
#define SELLER_REVIEW_TAG_NAME_LABEL 206
#define SELLER_REVIEW_TAG_DATE_LABEL 207
#define SELLER_REVIEW_TAG_REVIEW_LABEL 208

@interface SellerRevViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UITableView *reviewTableView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;



- (void)setSkillID:(NSString *)skillID;







@end



