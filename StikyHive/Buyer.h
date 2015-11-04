//
//  Buyer.h
//  StikyHive
//
//  Created by Koh Quee Boon on 25/5/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Buyer : NSObject

@property (nonatomic, assign) NSInteger buyerID;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger catID;
@property (nonatomic, copy) NSString *stkID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *overview;
@property (nonatomic, copy) NSString *photo;


@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *location;

- (id) initWithID:(NSInteger)buyerID
             type:(NSInteger)type
            catID:(NSInteger)catID
            stkID:(NSString *)stkID
            title:(NSString *)title
         overview:(NSString *)overview
            photo:(NSString *)photo;

- (id) initWithBuyerId:(NSInteger)buyerID
                  name:(NSString *)name
              location:(NSString *)location;

@end
