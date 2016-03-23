//
//  PostBuyViewController.h
//  StikyHive
//
//  Created by THV1WP15S on 18/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPostInfo.h"

@class RadioButton;

@interface PostBuyViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource, UIGestureRecognizerDelegate, UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;


@property (strong, nonatomic) IBOutlet RadioButton *individualRBtn;
@property (strong, nonatomic) IBOutlet RadioButton *fulltRBtn;
@property (strong, nonatomic) IBOutlet RadioButton *openRBtn;


@property (strong, nonatomic) IBOutlet UITextField *rateTextField;
@property (strong, nonatomic) IBOutlet UITextField *industryTextField;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *priceTextField;

@property (strong, nonatomic) IBOutlet UITextField *fromHHTextField;
@property (strong, nonatomic) IBOutlet UITextField *fromMMTextField;
@property (strong, nonatomic) IBOutlet UITextField *toHHTextField;
@property (strong, nonatomic) IBOutlet UITextField *toMMTextField;

@property (strong, nonatomic) IBOutlet UIWebView *descWebView;
@property (strong, nonatomic) IBOutlet UIWebView *respWebView;

@property (strong, nonatomic) IBOutlet UIButton *professionalBtn;
@property (strong, nonatomic) IBOutlet UIButton *rawBtn;


@property (nonatomic, strong) MyPostInfo *myPostInfo;

- (IBAction)nextBtnPressed:(id)sender;

- (IBAction)professionalBtnTapped:(id)sender;

- (IBAction)rawBtnTapped:(id)sender;



- (IBAction)onPersonTypeRTapped:(id)sender;

- (IBAction)onJobTypeRTapped:(id)sender;

- (IBAction)onAvailabitityRTapped:(id)sender;


- (void)setBuyerId:(NSInteger)buyerId;

@end
