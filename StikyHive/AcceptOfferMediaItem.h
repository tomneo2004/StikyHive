//
//  AcceptOfferMediaItem.h
//  StikyHive
//
//  Created by User on 4/3/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "JSQMediaItem.h"

@interface AcceptOfferMediaItem : JSQMediaItem<JSQMessageMediaData, NSCoding, NSCopying, UIWebViewDelegate>

- (instancetype)initWithHtmlString:(NSString *)htmlString;

@end
