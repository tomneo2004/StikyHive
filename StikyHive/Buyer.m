//
//  Buyer.m
//  StikyHive
//
//  Created by Koh Quee Boon on 25/5/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "Buyer.h"

@implementation Buyer

- (id) initWithID:(NSInteger)buyerID
             type:(NSInteger)type
            catID:(NSInteger)catID
            stkID:(NSString *)stkID
            title:(NSString *)title
         overview:(NSString *)overview
            photo:(NSString *)photo
{
    self = [super init];
    if (self)
    {
        _buyerID = buyerID;
        _type = type;
        _catID = catID;
        _stkID = stkID;
        _title = title;
        _overview = overview;
        _photo = photo;
    }
    return self;
}


- (id) initWithBuyerId:(NSInteger)buyerID
                  name:(NSString *)name
              location:(NSString *)location
{
    self = [super init];
    if (self) {
        _buyerID = buyerID;
        _name = name;
        _location = location;
        
    }
    
    return self;
}

@end
