//
//  AcceptOfferMessage.h
//  StikyHive
//
//  Created by User on 3/3/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "JSQMessage.h"

@interface AcceptOfferMessage : JSQMessage

@property (nonatomic, assign) BOOL stikypay;
@property (nonatomic, assign) NSInteger offerId;

@end
