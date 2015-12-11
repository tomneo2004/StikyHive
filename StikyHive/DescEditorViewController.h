//
//  DescEditorViewController.h
//  StikyHive
//
//  Created by User on 11/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "ZSSRichTextEditor.h"

@protocol DescEditorViewControllerDelegate <NSObject>

@optional
- (void)didFinishEditingWithHtmlText:(NSString *)htmlText;

@end

@interface DescEditorViewController : ZSSRichTextEditor

@property (weak, nonatomic) id<DescEditorViewControllerDelegate> delegate;

@property (copy, nonatomic) NSString *htmlText;

@end
