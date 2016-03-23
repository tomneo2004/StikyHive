//
//  MakeOfferViewController.h
//  StikyHive
//
//  Created by THV1WP15S on 17/3/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MakeOfferViewController;


@protocol MakeOfferDelegate <NSObject>

@optional

- (void)onMakeOfferTapped:(MakeOfferViewController *)makeOfferViewController dict:(NSDictionary *)dict;

@end

@interface MakeOfferViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>




@property (strong, nonatomic) IBOutlet UIButton *checkBoxBtn;

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong, nonatomic) IBOutlet UITextField *skillTextField;


@property (strong, nonatomic) IBOutlet UITextField *priceTextField;


@property (strong, nonatomic) IBOutlet UITextField *rateTextField;


@property (weak, nonatomic) id<MakeOfferDelegate> delegate;

- (IBAction)checkBoxPressed:(id)sender;


- (IBAction)makeOfferPressed:(id)sender;


+ (void)setToStikyBee:(NSString *)toStikyBee;

@end
