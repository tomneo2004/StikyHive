//
//  UrgentRequest.m
//  StikyHive
//
//  Created by User on 16/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "UrgentRequest.h"

@implementation UrgentRequest

+ (UrgentRequest *)createUrgentRequestFromDictionary:(NSDictionary *)dic{
    
    return [[UrgentRequest alloc] initWithDictionary:dic];
}

@end
