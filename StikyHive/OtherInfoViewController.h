//
//  OtherInfoViewController.h
//  StikyHive
//
//  Created by User on 5/1/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "ZSSRichTextEditor.h"

@protocol OtherInfoViewControllerDelegate <NSObject>

@optional
- (void)didFinishEditingWithHtmlText:(NSString *)htmlText;

@end

@interface OtherInfoViewController : ZSSRichTextEditor

@property (weak, nonatomic) id<OtherInfoViewControllerDelegate> delegate;
@property (copy, nonatomic) NSString *htmlText;

@end
