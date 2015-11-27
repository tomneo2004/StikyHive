//
//  PrepareRequestTableViewController.h
//  StikyHive
//
//  Created by User on 25/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PrepareRequestDelegate <NSObject>

@optional
- (void)onTitleDoneEdit:(NSString *)title;
- (void)onDescriptionChange:(NSString *)description;
- (void)onAttachementTapWithImageView:(UIImageView *)imageView;
- (void)onPostRequestButtonTap;

@end

@interface PrepareRequestTableViewController : UITableViewController<UITextFieldDelegate, UITextViewDelegate>

@property (assign, nonatomic) IBInspectable NSUInteger maxTitleCharacter;
@property (assign, nonatomic) IBInspectable NSUInteger maxDescCharacter;
@property (weak, nonatomic) id<PrepareRequestDelegate> delegate;

@end
