//
//  Section.h
//  StikyHive
//
//  Created by User on 16/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Section : NSObject

@property (readonly, nonatomic) NSArray *dataArray;

- (id)initWithDataArray:(NSArray *)dataArray;
- (BOOL)isSectionAClass:(Class)classToCompare;

@end
