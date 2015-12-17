//
//  PaySummaryViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 4/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "PaySummaryViewController.h"
#import "SellingManager.h"
#import "LocalDataInterface.h"
#import "WebDataInterface.h"
#import "PaySucessViewController.h"
#import "ViewControllerUtil.h"
#import "UIView+RNActivityView.h"
#import "ImageCaption.h"


@interface PaySummaryViewController ()

@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;

@property (nonatomic, strong) NSString *basicDuration;
@property (nonatomic, strong) NSString *basicUnit;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) BOOL promotion;
@property (nonatomic, assign) BOOL photoStatus;
@property (nonatomic, assign) BOOL videoStatus;
@property (nonatomic, assign) BOOL videoExtendStatus;
//@property (nonatomic, assign) NSInteger subMonth;
//@property (nonatomic, assign) NSDecimalNumber *subPrice;
//@property (nonatomic, assign) NSInteger subType;
@property (nonatomic, strong) NSDictionary *subDict;
@property (nonatomic, strong) NSDictionary *photoDict;
@property (nonatomic, strong) NSDictionary *videoDict;
@property (nonatomic, strong) NSDictionary *extendDict;
@property (nonatomic, strong) NSDictionary *extraDict;

@end

@implementation PaySummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _contentScrollView.alwaysBounceVertical = YES;
    _contentScrollView.delegate = self;
    
    _basicLabel.layer.borderWidth = 2;
    _basicLabel.layer.borderColor = [UIColor colorWithRed:0/255 green:139.0/255 blue:123.0/255 alpha:1.0].CGColor;
    
    _photoStatus = [SellingManager sharedSellingManager].photoStatus;
    _videoStatus = [SellingManager sharedSellingManager].videoStatus;
    _videoExtendStatus = [SellingManager sharedSellingManager].videoExtendStatus;
    _promotion = [SellingManager sharedSellingManager].promotionStatus;
//    NSLog(@"promotion or not ---- %d",promotion);
    
        
    
    if (_promotion)
    {
        _basicDuration = @"18mths";
        _duration = 18;
//        _basicUnit = 
        
        _defDurationLabel.text = _basicDuration;
        
    }
    else
    {
        _duration = 12;
        
    }
    
    [self.view showActivityViewWithLabel:@"Loading..."];
    
    [WebDataInterface getSubscriptionPlan:1 completion:^(NSObject *obj, NSError *err)
    {
//        NSLog(@"subscription palan ==== %@",obj);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CGFloat y = 0;
            y = [self displayContent];
            
            [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width, y)];

            NSDictionary *dict = (NSDictionary *)obj;
            NSArray *dictArray = dict[@"plans"];
            _subDict = dictArray[0];
//            NSLog(@"sub dict --- %@",_subDict);
            _photoDict = dictArray[2];
            _videoDict = dictArray[3];
            _extendDict = dictArray[4];
            _extraDict = dictArray[1];
//            NSLog(@"photo dict --- %@",_photoDict);
//            NSLog(@"video dict --- %@",_videoDict);
//            NSLog(@"extend dict --- %@",_extendDict);
//            NSLog(@"extra dict --- %@",_extraDict);
            
            [self.view hideActivityView];
            
        });
        
    }];
    
    
}


- (CGFloat)displayContent
{
//    BOOL photoStatus = [SellingManager sharedSellingManager].photoStatus;
//    BOOL videoStatus = [SellingManager sharedSellingManager].videoStatus;
//    BOOL videoExtendStatus = [SellingManager sharedSellingManager].videoExtendStatus;
//    _promotion = [SellingManager sharedSellingManager].promotionStatus;
    
//    NSLog(@"promotion (display content)--- %d ",_promotion);
    
    UIColor *greenColor =  [UIColor colorWithRed:0/255 green:139.0/255 blue:123.0/255 alpha:1.0];
    
    CGFloat y = 230;
    CGFloat x = 20;
    CGFloat width = self.view.frame.size.width;
    float price = 0.0;
    
    
    if (_photoStatus || _videoStatus || _videoExtendStatus || _promotion)
    {
        UILabel *addOnFeatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 80, 55)];
        addOnFeatureLabel.text = @"Add-on Features";
        addOnFeatureLabel.textColor = greenColor;
        addOnFeatureLabel.numberOfLines = 0;
        addOnFeatureLabel.layer.borderWidth = 2;
        addOnFeatureLabel.layer.borderColor = greenColor.CGColor;
        addOnFeatureLabel.textAlignment = NSTextAlignmentCenter;
        
        [_contentScrollView addSubview:addOnFeatureLabel];
        
        
        y = y + addOnFeatureLabel.frame.size.height +20;
        
        NSString *durationString;
        NSString *unitString;
        NSString *totalString = @"11.88";
        if (_promotion)
        {
            durationString = @"18mths";
            unitString = @"$0.99*12";
            
        }
        else
        {
            durationString = @"12mths";
            unitString = @"$0.99*12";
        }
        
        
        
        if (_photoStatus)
        {
            UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 45, 15)];
            itemLabel.text = @"Add 4 Photos";
            itemLabel.font = [UIFont systemFontOfSize:14];
            [itemLabel sizeToFit];
            
            UILabel *durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(x+110, y, 30, 15)];
            durationLabel.text = durationString;
            durationLabel.font = [UIFont systemFontOfSize:14];
            [durationLabel sizeToFit];
            
            UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(x +200, y, 35, 15)];
            unitLabel.text = unitString;
            unitLabel.font = [UIFont systemFontOfSize:14];
            [unitLabel sizeToFit];
            
            UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(x+290, y, 35, 15)];
            totalLabel.text = totalString;
            totalLabel.font = [UIFont systemFontOfSize:14];
            [totalLabel sizeToFit];
            
            
            [_contentScrollView addSubview:itemLabel];
            [_contentScrollView addSubview:durationLabel];
            [_contentScrollView addSubview:unitLabel];
            [_contentScrollView addSubview:totalLabel];
            
            price += 11.88;
            y = y + 15 +15;
            
        }
        if (_videoStatus)
        {
            UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 45, 15)];
            itemLabel.text = @"Add a Video";
            itemLabel.font = [UIFont systemFontOfSize:14];
            [itemLabel sizeToFit];
            
            UILabel *durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(x+110, y, 30, 15)];
            durationLabel.text = durationString;
            durationLabel.font = [UIFont systemFontOfSize:14];
            [durationLabel sizeToFit];
            
            UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(x +200, y, 35, 15)];
            unitLabel.text = unitString;
            unitLabel.font = [UIFont systemFontOfSize:14];
            [unitLabel sizeToFit];
            
            UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(x+290, y, 35, 15)];
            totalLabel.text = totalString;
            totalLabel.font = [UIFont systemFontOfSize:14];
            [totalLabel sizeToFit];
            
            
            [_contentScrollView addSubview:itemLabel];
            [_contentScrollView addSubview:durationLabel];
            [_contentScrollView addSubview:unitLabel];
            [_contentScrollView addSubview:totalLabel];
            
            y = y + 15 +15;
            price += 11.88;

            
            
        }
        if(_videoExtendStatus)
        {
            UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 45, 15)];
            itemLabel.text = @"Extended Video";
            itemLabel.font = [UIFont systemFontOfSize:14];
            [itemLabel sizeToFit];
            
            UILabel *durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(x+110, y, 30, 15)];
            durationLabel.text = durationString;
            durationLabel.font = [UIFont systemFontOfSize:14];
            [durationLabel sizeToFit];
            
            UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(x +200, y, 35, 15)];
            unitLabel.text = unitString;
            unitLabel.font = [UIFont systemFontOfSize:14];
            [unitLabel sizeToFit];
            
            UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(x+290, y, 35, 15)];
            totalLabel.text = totalString;
            totalLabel.font = [UIFont systemFontOfSize:14];
            [totalLabel sizeToFit];
            
            
            [_contentScrollView addSubview:itemLabel];
            [_contentScrollView addSubview:durationLabel];
            [_contentScrollView addSubview:unitLabel];
            [_contentScrollView addSubview:totalLabel];
            
            y = y + 15 +15;
            price += 11.88;

            
            
            
        }
        if (_promotion)
        {
            UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 45, 15)];
            itemLabel.text = @"Extra 6 Months";
            itemLabel.font = [UIFont systemFontOfSize:14];
            [itemLabel sizeToFit];
            
            UILabel *durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(x+110, y, 30, 15)];
            durationLabel.text = @"6mths";
            durationLabel.font = [UIFont systemFontOfSize:14];
            [durationLabel sizeToFit];
            
            UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(x +200, y, 35, 15)];
            unitLabel.text = @"$1*6";
            unitLabel.font = [UIFont systemFontOfSize:14];
            [unitLabel sizeToFit];
            
            UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(x+290, y, 35, 15)];
            totalLabel.text = @"$6.0";
            totalLabel.font = [UIFont systemFontOfSize:14];
            [totalLabel sizeToFit];
            
            
            [_contentScrollView addSubview:itemLabel];
            [_contentScrollView addSubview:durationLabel];
            [_contentScrollView addSubview:unitLabel];
            [_contentScrollView addSubview:totalLabel];
            
            y = y + 15 +20;
            price += 6.0;
 
        }
    }
    
    UIColor *grey = [UIColor colorWithRed:213.0/255 green:213.0/255 blue:213.0/255 alpha:1.0];
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(x, y, width-40, 2)];
    lineView1.backgroundColor = grey;
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(x +270, y+15, 50, 15)];
    NSString *priceString = [NSString stringWithFormat:@"$%.2f",price];
    priceLabel.text = priceString;
    [priceLabel sizeToFit];
    priceLabel.textAlignment = NSTextAlignmentRight;
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(x, y+45, width-40, 2)];
    lineView2.backgroundColor = grey;
    
    [_contentScrollView addSubview:lineView1];
    [_contentScrollView addSubview:priceLabel];
    [_contentScrollView addSubview:lineView2];
    
    y = lineView2.frame.origin.y + 20;
    
    UITextField *promoTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, 160, 45)];
    promoTextField.textAlignment = NSTextAlignmentCenter;
    promoTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Promo code"];
    promoTextField.backgroundColor = [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0];
    
    
    UIButton *applyBtn = [[UIButton alloc] initWithFrame:CGRectMake(x + promoTextField.frame.size.width +15, y, 130, 45)];
    [applyBtn setTitle:@"Apply" forState:UIControlStateNormal];
    [applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    applyBtn.backgroundColor = greenColor;
    
    
    [_contentScrollView addSubview:promoTextField];
    [_contentScrollView addSubview:applyBtn];
    
    y = y + applyBtn.frame.size.height + 25;
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(x, y, width-40, 2)];
    lineView3.backgroundColor = grey;
    
    UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(x +270, y+15, 50, 15)];
    NSString *totalPriceString = [NSString stringWithFormat:@"$%.2f",price];
    totalPriceLabel.text = totalPriceString;
    [totalPriceLabel sizeToFit];
    totalPriceLabel.textAlignment = NSTextAlignmentRight;
    
    UILabel *sgdLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y+15, 50, 15)];
    sgdLabel.text = @"Total in SGD:";
    [sgdLabel sizeToFit];
    
    
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(x, y+45, width-40, 2)];
    lineView4.backgroundColor = grey;
    
    
    [_contentScrollView addSubview:lineView3];
    [_contentScrollView addSubview:totalPriceLabel];
    [_contentScrollView addSubview:sgdLabel];
    [_contentScrollView addSubview:lineView4];
    
    y = lineView4.frame.origin.y + 25;
    
    UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width-40, 45)];
    [payBtn setTitle:@"Proceed with payment" forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payBtn.backgroundColor = greenColor;
    [payBtn addTarget:self action:@selector(payBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [_contentScrollView addSubview:payBtn];
    
    y = y + payBtn.frame.size.height +20;
    
    
    return y;
    
}

- (void)payBtnTapped:(UITapGestureRecognizer *)sender
{

    SellingManager *smg = [SellingManager sharedSellingManager];
    
    NSLog(@"selling manage -- %@",smg);
    
    NSString *stkid = [LocalDataInterface retrieveStkid];
    NSInteger skillId = 0;
    NSString *rateIdString = [SellingManager sharedSellingManager].skillRate;
    NSInteger rateId = [rateIdString integerValue];
    
    NSString *subMonthString = _subDict[@"duration"];
    NSString *subPriceString = _subDict[@"price"];
    NSInteger subMonthInt = [subMonthString integerValue];
//    NSDecimalNumber *subMonthNumber = [NSDecimalNumber decimalNumberWithDecimal:[ decimalValue]];
    NSDecimalNumber *subPriceNumber = [NSDecimalNumber decimalNumberWithString:subPriceString];
    NSDecimalNumber *subTotal = [subPriceNumber decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"12"]];
    
//    NSLog(@"sub total -- %@",subTotal);
    NSDecimalNumber *zero = [[NSDecimalNumber alloc] initWithFloat:0.0];
    
    if (_photoStatus || _videoStatus || _videoExtendStatus || _promotion)
    {
        PayPalPayment *payment = [[PayPalPayment alloc] init];
        payment.amount = [[NSDecimalNumber alloc] initWithString:@"5.00"];
        payment.currencyCode = @"SGD";
        payment.shortDescription = @"Post a request";
        payment.intent = PayPalPaymentIntentSale;
        if (!payment.processable){
        }
        
        PayPalPaymentViewController *paymentViewController;
        paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                       configuration:self.payPalConfiguration
                                                                            delegate:self];
        
        [self presentViewController:paymentViewController animated:YES completion:nil];
    }
    else
    {
        [self.view showActivityViewWithLabel:@"Uploading"];
        
        NSArray *photoArray = smg.photoCaption;
        
        
        
        [WebDataInterface createUpdateSubPlan:stkid skillId:skillId name:smg.skillName description:smg.skillDesc catId:smg.skillCategoryId type:smg.skillType summary:smg.skillSummary price:smg.skillPrice rateId:rateId subId1:0 subMonth:subMonthInt subPrice:subPriceNumber subTotal:subTotal subType:1 status1:1 subId3:0 photoMonth:0 photoPrice:zero photoTotal:zero photoType:0 status3:0 subId4:0 videoMonth:0 videoPrice:zero videoTotal:zero videoType:0 status4:0 subId5:0 extendMonth:0 extendPrice:zero extendTotal:zero extendType:0 status5:0 subId2:0 extraMonth:0 extraPrice:zero extraTotal:zero extraType:0 status2:0 completion:^(NSObject *obj, NSError *err)
        {
            
            NSLog(@"obj ---- %@ ",obj);
            NSLog(@"err ---- %@",err);
            
            NSDictionary *createDict = (NSDictionary *)obj;
//            NSInteger skillId = [createDict[@"skillId"] integerValue];
            
            if (createDict && [createDict[@"status"] isEqualToString:@"success"])
            {
                
                NSInteger skillid = [createDict[@"skillId"] integerValue];
                [WebDataInterface updateSubSkillStatus:skillid duration:subMonthInt completion:^(NSObject *objS, NSError *errS)
                {
                    
                    NSLog(@"obj skill S ---- %@ ",objS);
                    NSLog(@"err skill  S--- %@",errS);
                    
                    NSDictionary *dictS = (NSDictionary *)objS;
                    
                    if (dictS && [dictS[@"status"] isEqualToString:@"success"])
                    {
                        
                        
                        for (int i =0; i < photoArray.count; i++) {
                            ImageCaption *ic = photoArray[i];
                            NSLog(@"image 77777--- %@",ic.image);
                            NSLog(@"caption 77777--- %@",ic.caption);
                            
                            if (ic.image != nil) {
                                
                                NSLog(@"upload image !!!!!!!!!");
                                
                                [WebDataInterface skillImageUpload:ic.image stikyid:stkid skillId:skillid type:1 editFlage:NO photoId:0 caption:ic.caption];
                                
                            }
                            
                        }
                        
                        
                        
                        UIViewController *vc = [ViewControllerUtil instantiateViewController:@"pay_sucess_view_controller"];
                        [self.navigationController pushViewController:vc animated:YES];

                    }
                    
                }];
                
                
            }

            [smg clearCurrentSelling];
            [self.view hideActivityView];
            
            
        }];
        
    }
    
    
}


#pragma mark - PayPalPaymentDelegate
- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment
{
    
    [self uploadDataToServer];
    
    
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - upload
- (void)uploadDataToServer
{
    [self.view showActivityViewWithLabel:@"Uploading..."];
    

    NSString *stkid = [LocalDataInterface retrieveStkid];
    NSInteger skillId = 0;
    NSString *rateIdString = [SellingManager sharedSellingManager].skillRate;
    NSInteger rateId = [rateIdString integerValue];

    NSInteger subId1 = 0;
    NSString *subMonthString = _subDict[@"duration"];
    NSString *subPriceString = _subDict[@"price"];
    NSInteger subMonthInt = [subMonthString integerValue];
    //    NSDecimalNumber *subMonthNumber = [NSDecimalNumber decimalNumberWithDecimal:[ decimalValue]];
    NSDecimalNumber *subPriceNumber = [NSDecimalNumber decimalNumberWithString:subPriceString];
    NSDecimalNumber *subTotal = [subPriceNumber decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"12"]];
    
    NSLog(@"sub total -- %@",subTotal);
    NSDecimalNumber *zero = [[NSDecimalNumber alloc] initWithFloat:0.0];
    
    
    NSInteger subId3 = 0;
    NSInteger photoMonth = 0;
    NSDecimalNumber *photoPrice =zero;
    NSDecimalNumber *photoTotal = zero;
    NSInteger photoType = 0;
    NSInteger status3 = 0;
    
    NSInteger subId4 = 0;
    NSInteger videoMonth = 0;
    NSDecimalNumber *videoPrice =zero;
    NSDecimalNumber *videoTotal = zero;
    NSInteger videoType = 0;
    NSInteger status4 = 0;

    NSInteger subId5 = 0;
    NSInteger extendMonth = 0;
    NSDecimalNumber *extendPrice =zero;
    NSDecimalNumber *extendTotal = zero;
    NSInteger extendType = 0;
    NSInteger status5 = 0;
    
    NSInteger subId2 = 0;
    NSInteger extraMonth = 0;
    NSDecimalNumber *extraPrice =zero;
    NSDecimalNumber *extraTotal = zero;
    NSInteger extraType = 0;
    NSInteger status2 = 0;
    
    SellingManager *smg = [SellingManager sharedSellingManager];
    
    if (_photoStatus) {
        photoMonth = [_photoDict[@"duration"] integerValue];
        photoPrice = [NSDecimalNumber decimalNumberWithString:_photoDict[@"price"]];
        photoTotal = [photoPrice decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"12"]];
        photoType = [_photoDict[@"id"] integerValue];
        status3 = 1;
    }
    if (_videoStatus) {
        videoMonth = [_videoDict[@"duration"] integerValue];
        videoPrice = [NSDecimalNumber decimalNumberWithString:_videoDict[@"price"]];
        videoTotal = [videoPrice decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"12"]];
        videoType = [_videoDict[@"id"] integerValue];
        status3 = 4;

    }
    if (_videoExtendStatus) {
        extendMonth = [_extendDict[@"duration"] integerValue];
        extendPrice = [NSDecimalNumber decimalNumberWithString:_extendDict[@"price"]];
        extendTotal = [extendPrice decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"12"]];
        extendType = [_extendDict[@"id"] integerValue];
        status5 = 4;

    }
    if (_promotion) {
        extraMonth = [_extraDict[@"duration"] integerValue];
        extraPrice = [NSDecimalNumber decimalNumberWithString:_extraDict[@"price"]];
        extraTotal = [extraPrice decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"6"]];
        extraType = [_extraDict[@"id"] integerValue];
        status2 = 4;

    }
    
    
    
    [WebDataInterface createUpdateSubPlan:stkid skillId:skillId name:smg.skillName description:smg.skillDesc catId:smg.skillCategoryId type:smg.skillType summary:smg.skillSummary price:smg.skillPrice rateId:rateId subId1:subId1 subMonth:subMonthInt subPrice:subPriceNumber subTotal:subTotal subType:1 status1:1 subId3:subId3 photoMonth:photoMonth photoPrice:photoPrice photoTotal:photoTotal photoType:photoType status3:status3 subId4:subId4 videoMonth:videoMonth videoPrice:videoPrice videoTotal:videoTotal videoType:videoType status4:status4 subId5:subId5 extendMonth:extendMonth extendPrice:extendPrice extendTotal:extendTotal extendType:extendType status5:status5 subId2:subId2 extraMonth:extraMonth extraPrice:extraPrice extraTotal:extraTotal extraType:extraType status2:status2 completion:^(NSObject *obj, NSError *err) {
        
        
        NSLog(@"obj ---- %@ ",obj);
        NSLog(@"err ---- %@",err);
        NSDictionary *dict = (NSDictionary *)obj;
        if (dict && [dict[@"status"] isEqualToString:@"success"])
        {
            
            NSInteger skillid = [dict[@"skillId"] integerValue];
            [WebDataInterface updateSubSkillStatus:skillid duration:subMonthInt completion:^(NSObject *objS, NSError *errS) {
                
                NSLog(@"obj skill ---- %@ ",objS);
                NSLog(@"err skill --- %@",errS);
                NSDictionary *dictS = (NSDictionary *)objS;
                
                if (dictS && [dictS[@"status"] isEqualToString:@"success"])
                {
                
                    for (int i =0; i < smg.photoCaption.count; i++) {
                        ImageCaption *ic = smg.photoCaption[i];
                        if (ic.image != nil) {
                        
                            [WebDataInterface skillImageUpload:ic.image stikyid:stkid skillId:skillid type:1 editFlage:NO photoId:0 caption:ic.caption];
                        
                        }
                    
                    }
                    
                }

            }];
            
            
        }
        
        
        [smg clearCurrentSelling];
        
        [self.view hideActivityView];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            
            UIViewController *vc = [ViewControllerUtil instantiateViewController:@"pay_sucess_view_controller"];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }];

        
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
