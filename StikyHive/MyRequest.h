//
//  MyRequest.h
//  StikyHive
//
//  Created by User on 16/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "Request.h"

@interface MyRequest : Request

/**
 * Return a MyRequest
 */
+ (MyRequest *)createMyRequestFromDictionary:(NSDictionary *)dic;

@end
