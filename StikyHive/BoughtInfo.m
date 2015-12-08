//
//  BoughtInfo.m
//  StikyHive
//
//  Created by User on 8/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "BoughtInfo.h"

@implementation BoughtInfo

@synthesize boughtId = _boughtId;
@synthesize offerId = _offerId;
@synthesize skillId = _skillId;
@synthesize buyerStkId = _buyerStkId;
@synthesize sellerStkId = _sellerStkId;
@synthesize paymentStatus = _paymentStatus;
@synthesize secPaymentStatus = _secPaymentStatus;
@synthesize originalCreateDate = _originalCreateDate;
@synthesize createDate = _createDate;
@synthesize originalUpdateDate = _originalUpdateDate;
@synthesize updateDate = _updateDate;
@synthesize commentId = _commentId;
@synthesize review = _review;
@synthesize rating = _rating;
@synthesize skillName = _skillName;
@synthesize firstname = _firstname;
@synthesize lastname = _lastname;
@synthesize price = _price;
@synthesize rateName = _rateName;
@synthesize thumbnailLocation = _thumbnailLocation;
@synthesize photoLocation = _photoLocation;

+ (id)createBoughtInfoFromDictionary:(NSDictionary *)dic{
    
    return [[BoughtInfo alloc] initWithDictionary:dic];
}

- (id)initWithDictionary:(NSDictionary *)dic{
    
    if(self = [super init]){
        
        _boughtId = [dic objectForKey:@"id"];
        _offerId = [dic objectForKey:@"offerId"];
        _skillId = [dic objectForKey:@"skillId"];
        _buyerStkId = [dic objectForKey:@"buyer"];
        _sellerStkId = [dic objectForKey:@"seller"];
        _paymentStatus = [dic objectForKey:@"firstPaymentStatus"];
        
        if(![[dic objectForKey:@"secondPaymentStatus"] isEqual:[NSNull null]])
            _secPaymentStatus = [dic objectForKey:@"secondPaymentStatus"];
        
        if(![[dic objectForKey:@"createDate"] isEqual:[NSNull null]])
            _originalCreateDate = [dic objectForKey:@"createDate"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        
        _createDate = [formatter dateFromString:_originalCreateDate];
        
        if(![[dic objectForKey:@"updateDate"] isEqual:[NSNull null]])
            _originalUpdateDate = [dic objectForKey:@"updateDate"];
        
        _updateDate = [formatter dateFromString:_originalUpdateDate];
        
        _commentId = [dic  objectForKey:@"commentId"];
        _review = [dic objectForKey:@"review"];
        _rating = [[dic objectForKey:@"rating"] integerValue];
        _skillName = [dic objectForKey:@"skillName"];
        _firstname = [dic objectForKey:@"firstname"];
        _lastname = [dic objectForKey:@"lastname"];
        _price = [[dic objectForKey:@"price"] doubleValue];
        _rateName = [dic objectForKey:@"rateName"];
        _thumbnailLocation = [dic objectForKey:@"thumbnailLocation"];
        _photoLocation = [dic objectForKey:@"photoLocation"];
    }
    
    return self;
}

@end
