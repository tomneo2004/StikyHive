//
//  AllSellerViewController.h
//  StikyHive
//
//  Created by Koh Quee Boon on 21/5/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SELLER_COLLECTION_TAG_SKILL_IMAGE 100
#define SELLER_COLLECTION_TAG_SKILL_TITLE 101
#define SELLER_COLLECTION_TAG_PROFILE_IMAGE 102
#define SELLER_COLLECTION_TAG_CHAT_ICON 103
#define SELLER_COLLECTION_TAG_CALL_ICON 104
#define SELLER_COLLECTION_TAG_CIRCLE_VIEW 105

@interface SellerCollectionViewController : UICollectionViewController

+ (void )setSearchText:(NSString *)searchText;
+ (void )setSkillCat:(NSInteger)catID;
+ (void )setUserID:(NSString *)userID;

- (NSInteger)numRecords;

@end
