//
//  TextEditorViewController.h
//  StikyHive
//
//  Created by Koh Quee Boon on 10/6/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextEditorViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

- (void)setTextFields:(NSArray *)textFields;
- (void)setTextViews:(NSArray *)textViews;
- (void)setMaxCharacters:(NSDictionary *)maxChars;
- (void)setCharCountDownIndicators:(NSDictionary *)countDownLabels;
- (void)setAnimateDistances:(NSDictionary *)animateDistances;

@end
