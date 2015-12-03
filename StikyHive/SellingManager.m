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






#pragma mark - public interface
- (void)clearCurrentSelling
{
    _photoArray = nil;
    _photoStatus = nil;
    
}














@end
