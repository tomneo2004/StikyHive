//
//  SellingManager.m
//  StikyHive
//
//  Created by THV1WP15S on 2/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "SellingManager.h"

@interface SellingManager ()

@end

@implementation SellingManager {
    NSMutableArray *_photoArray;
    BOOL _photoStatus;
    BOOL _videoStatus;
    BOOL _videoExtendStatus;
    
    NSString *_skillName;
    NSInteger _skillCategoryId;
    NSString *_skillSummary;
    NSString *_skillDesc;
    NSDecimalNumber *_skillPrice;
    NSString *_skillRate;
    NSInteger _skillType;
    
    BOOL _profileTap;
    
    UIImage *_videoImage;
    NSData *_video;
    
    
    BOOL _promotionStatus;
}

static SellingManager *_instance;

+ (SellingManager *)sharedSellingManager
{
    if (_instance == nil) {
        _instance = [[SellingManager alloc] init];
    }
    
    return _instance;
}


#pragma mark - Setter
- (void)setPhotos:(NSMutableArray *)photoArray
{
    _photoArray = photoArray;
}

- (void)setPhotoStatus:(BOOL)photoStatus
{
    _photoStatus = photoStatus;
}

- (void)setVideoStatus:(BOOL)videoStatus
{
    _videoStatus = videoStatus;
}

- (void)setVideoExtendStatus:(BOOL)videoExtendStatus
{
    _videoExtendStatus = videoExtendStatus;
}

- (void)setSkillName:(NSString *)skillName
{
    _skillName = skillName;
}

- (void)setSkillCategoryId:(NSInteger)skillCategoryId
{
    _skillCategoryId = skillCategoryId;
}

- (void)setSkillSummary:(NSString *)skillSummary
{
    _skillSummary = skillSummary;
}


- (void)setSkillDesc:(NSString *)skillDesc
{
    _skillDesc = skillDesc;
}

- (void)setSkillPrice:(NSDecimalNumber *)skillPrice
{
    _skillPrice = skillPrice;
}

- (void)setSkillRate:(NSString *)skillRate
{
    _skillRate = skillRate;
}

- (void)setSkillType:(NSInteger)skillType
{
    _skillType = skillType;
}

- (void)setVideoImage:(UIImage *)videoImage
{
    _videoImage = videoImage;
}

- (void)setVideo:(NSData *)video
{
    _video = video;
}

- (void)setPromotionStatus:(BOOL)promotionStatus
{
    _promotionStatus = promotionStatus;
}

- (void)setProfileTap:(BOOL)profileTap
{
    _profileTap = profileTap;
}


#pragma mark - Getter
- (NSMutableArray *)getPhotos
{
    return _photoArray;
}

- (BOOL)getPhotoStatus
{
    return _photoStatus;
}

- (BOOL)getVideoStatus
{
    return _videoStatus;
}

- (BOOL)getVideoExtendStatus
{
    return _videoExtendStatus;
}

- (NSString *)getSkillName
{
    return _skillName;
}

- (NSInteger)getSkillCategoryId
{
    return _skillCategoryId;
}

- (NSString *)getSkillSummary
{
    return _skillSummary;
}

- (NSString *)getSkillDesc
{
    return _skillDesc;
}

- (NSDecimalNumber *)getSkillPrce
{
    return _skillPrice;
}

- (NSString *)getSkillRate
{
    return _skillRate;
}

- (UIImage *)getVideoImage
{
    return _videoImage;
}

- (NSData *)getVideo
{
    return _video;
}

- (BOOL)getPromotionStatus
{
    return _promotionStatus;
}

- (NSInteger)getSkillType
{
    return _skillType;
}

- (BOOL)getProfileTap
{
    return _profileTap;
}




#pragma mark - public interface
- (void)clearCurrentSelling
{
    _photoArray = nil;
    _photoStatus = nil;
    
}














@end
