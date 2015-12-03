//
//  SellingManager.h
//  StikyHive
//
//  Created by THV1WP15S on 2/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SellingManager : NSObject


@property (setter=setPhotos:, getter=getPhotos, nonatomic) NSMutableArray *photoArray;
@property (setter=setPhotoStatus:, getter=getPhotoStatus, nonatomic) BOOL photoStatus;
@property (setter=setVideoStatus:, getter=getVideoStatus, nonatomic) BOOL videoStatus;

@property (setter=setSkillName:, getter=getSkillName, nonatomic) NSString *skillName;
@property (setter=setSkillCategoryId:, getter=getSkillCategoryId, nonatomic) NSString *skillCategoryId;
@property (setter=setSkillSummary:, getter=getSkillSummary, nonatomic) NSString *skillSummary;
@property (setter=setSkillDesc:, getter=getSkillDesc, nonatomic) NSString *skillDesc;
@property (setter=setSkillPrice:,getter=getSkillPrce, nonatomic) NSString *skillPrice;
@property (setter=setSkillRate:, getter=getSkillRate, nonatomic) NSString *skillRate;

@property (setter=setVideoImage:, getter=getVideoImage, nonatomic) UIImage *videoImage;
@property (setter=setVideo:, getter=getVideo, nonatomic) NSData *video;



+ (SellingManager *)sharedSellingManager;

- (void)clearCurrentSelling;



@end