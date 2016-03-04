//
//  OfferMediaItem.h
//  StikyHive
//
//  Created by User on 1/3/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "JSQMediaItem.h"

#define acceptOfferNotification @"OfferAccept"
#define cancelOfferNotification @"OfferCancel"

@interface OfferMediaItem : JSQMediaItem<JSQMessageMediaData, NSCoding, NSCopying>

@property (nonatomic, assign) NSInteger offerId;
@property (nonatomic, assign) NSInteger offerStatus;
@property (nonatomic, assign) double price;
@property (nonatomic, copy) NSString *offerName;
@property (nonatomic, copy) NSString *offerRate;
@property (nonatomic, copy) NSString *fullString;
@property (nonatomic, assign) BOOL isOfferInteract;

- (instancetype)initWithOfferId:(NSInteger)mOfferId withOfferStatus:(NSInteger)mOfferStatus withPrice:(double)mPrice withOfferName:(NSString *)mOfferName withOfferRate:(NSString *)mOfferRate;

@end
