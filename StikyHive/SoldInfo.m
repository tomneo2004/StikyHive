//
//  SoldInfo.m
//  StikyHive
//
//  Created by User on 4/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "SoldInfo.h"

@implementation SoldInfo

@synthesize soldId = _soldId;
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
@synthesize name = _name;
@synthesize price = _price;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;

+ (id)createSoldInfoFromDictionary:(NSDictionary *)dic{
    
    return [[SoldInfo alloc] initWithDictionary:dic];
}

- (id)initWithDictionary:(NSDictionary *)dic{
    
    if(self = [super init]){
        
        _soldId = [dic objectForKey:@"id"];
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
        
        _name = [dic objectForKey:@"name"];
        _price = [[dic objectForKey:@"price"] doubleValue];
        _firstName = [dic objectForKey:@"firstname"];
        _lastName = [dic objectForKey:@"lastname"];
    }
    
    return self;
}

@end
