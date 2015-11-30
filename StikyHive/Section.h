//
//  Section.h
//  StikyHive
//
//  Created by User on 16/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Section : NSObject

/**
 * The data array in the section
 */
@property (readonly, nonatomic) NSArray *dataArray;

/**
 * Init a section that contain an array of data
 */
- (id)initWithDataArray:(NSArray *)dataArray;

/**
 * Chcek if section is a class
 * first element in data array will be used to compare
 */
- (BOOL)isSectionAClass:(Class)classToCompare;

@end
