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
    
    NSString *_skillName;
    NSString *_skillCategoryId;
    NSString *_skillSummary;
    NSString *_skillDesc;
    NSString *_skillPrice;
    NSString *_skillRate;
    
    
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

- (void)setSkillName:(NSString *)skillName
{
    _skillName = skillName;
}

- (void)setSkillCategoryId:(NSString *)skillCategoryId
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

- (void)setSkillPrice:(NSString *)skillPrice
{
    _skillPrice = skillPrice;
}

- (void)setSkillRate:(NSString *)skillRate
{
    _skillRate = skillRate;
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

- (NSString *)getSkillName
{
    return _skillName;
}

- (NSString *)getSkillCategoryId
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

- (NSString *)getSkillPrce
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



#pragma mark - public interface
- (void)clearCurrentSelling
{
    _photoArray = nil;
    _photoStatus = nil;
    
}














@end
