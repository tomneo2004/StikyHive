//
//  SellerCommTableViewController.h
//  StikyHive
//
//  Created by THV1WP15S on 9/10/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>


#define SELLER_COMMENTS_TAG_PROFILE_IMAGE 201
#define SELLER_COMMENTS_TAG_NAME_LABEL 202
#define SELLER_COMMENTS_TAG_DATE_LABEL 203
#define SELLER_COMMENTS_TAG_COMMENT_LABEL 204

@interface SellerCommTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UITableView *commTableView;
@property (strong, nonatomic) IBOutlet UIButton *postBtn;

- (IBAction)postBtnPressed:(id)sender;

- (void)setSkillID:(NSString *)skillID;


@end
