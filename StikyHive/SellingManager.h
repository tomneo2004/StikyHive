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

@property (setter=setPhotoCaption:, getter=getPhotoCaption, nonatomic) NSMutableArray*photoCaption;


@property (setter=setPhotoStatus:, getter=getPhotoStatus, nonatomic) BOOL photoStatus;
@property (setter=setVideoStatus:, getter=getVideoStatus, nonatomic) BOOL videoStatus;
@property (setter=setVideoExtendStatus:, getter=getVideoExtendStatus, nonatomic) BOOL videoExtendStatus;

@property (setter=setSkillName:, getter=getSkillName, nonatomic) NSString *skillName;
@property (setter=setSkillCategoryId:, getter=getSkillCategoryId, nonatomic) NSInteger skillCategoryId;
@property (setter=setSkillSummary:, getter=getSkillSummary, nonatomic) NSString *skillSummary;
@property (setter=setSkillDesc:, getter=getSkillDesc, nonatomic) NSString *skillDesc;
@property (setter=setSkillPrice:,getter=getSkillPrce, nonatomic) NSDecimalNumber *skillPrice;
@property (setter=setSkillRate:, getter=getSkillRate, nonatomic) NSString *skillRate;
@property (setter=setSkillType:, getter=getSkillType, nonatomic) NSInteger skillType;

@property (nonatomic, assign) BOOL videoEdit;
@property (nonatomic, assign) NSInteger videoId;
@property (setter=setVideoImage:, getter=getVideoImage, nonatomic) UIImage *videoImage;

@property (setter=setVideo:, getter=getVideo, nonatomic) NSData *video;

@property (nonatomic, assign) BOOL secVideoEdit;
@property (nonatomic, assign) NSInteger secVideoId;
@property (setter=setSecVideoImage:, getter=getSecVideoImage, nonatomic) UIImage *secVideoImage;
@property (setter=setSecVideo:, getter=getSecVideo, nonatomic) NSData *secVideo;
@property (setter=setThumbnail:, getter=getThumbnail, nonatomic) NSData *thumbnail;
@property (setter=setVideo:, getter=getVideo2, nonatomic) NSData *video2;
@property (setter=setThumbnail2:, getter=getThumbnail2, nonatomic) NSData *thumbnail2;

@property (setter=setPromotionStatus:, getter=getPromotionStatus, nonatomic) BOOL promotionStatus;


@property (setter=setProfileTap:, getter=getProfileTap, nonatomic) BOOL profileTap;

@property (setter=setIsSkillId:, getter=getIsSkillId, nonatomic) NSString *isSkillId;


+ (SellingManager *)sharedSellingManager;

- (void)clearCurrentSelling;



@end
