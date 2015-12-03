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


+ (SellingManager *)sharedSellingManager;

- (void)clearCurrentSelling;



@end
