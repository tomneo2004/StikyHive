//
//  MyRequest.h
//  StikyHive
//
//  Created by User on 16/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "Request.h"

@interface MyRequest : Request

+ (MyRequest *)createMyRequestFromDictionary:(NSDictionary *)dic;

@end
