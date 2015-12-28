//
//  PostBuyViewController.h
//  StikyHive
//
//  Created by THV1WP15S on 18/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PostBuyViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;


@property (strong, nonatomic) IBOutlet UIButton *individualRBtn;
@property (strong, nonatomic) IBOutlet UIButton *companyRBtn;


@property (strong, nonatomic) IBOutlet UIButton *fulltRBtn;
@property (strong, nonatomic) IBOutlet UIButton *parttRBtn;

@property (strong, nonatomic) IBOutlet UIButton *openRBtn;
@property (strong, nonatomic) IBOutlet UIButton *closeRBtn;

@property (strong, nonatomic) IBOutlet UITextField *rateTextField;
@property (strong, nonatomic) IBOutlet UITextField *industryTextField;

- (IBAction)nextBtnPressed:(id)sender;

- (IBAction)professionalBtnTapped:(id)sender;

- (IBAction)rawBtnTapped:(id)sender;


- (IBAction)onPersonTypeRTapped:(id)sender;


- (IBAction)onJobTypeRTapped:(id)sender;

- (IBAction)onAvailabitityRTapped:(id)sender;



@end
