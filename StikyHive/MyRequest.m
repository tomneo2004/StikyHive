//
//  MyRequest.m
//  StikyHive
//
//  Created by User on 16/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "MyRequest.h"

@implementation MyRequest

+ (MyRequest *)createMyRequestFromDictionary:(NSDictionary *)dic{

    return [[MyRequest alloc] initWithDictionary:dic];
}

@end
