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

@interface PaySummaryViewController ()

@property (nonatomic, strong) NSString *basicDuration;
@property (nonatomic, strong) NSString *basicUnit;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) BOOL promotion;

@end

@implementation PaySummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _contentScrollView.alwaysBounceVertical = YES;
    _contentScrollView.delegate = self;
    
    _basicLabel.layer.borderWidth = 2;
    _basicLabel.layer.borderColor = [UIColor colorWithRed:0/255 green:139.0/255 blue:123.0/255 alpha:1.0].CGColor;
    
    
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
    
    CGFloat y = 0;
    y = [self displayContent];
    
    [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width, y)];
    
//    [self displayContent];
}


- (CGFloat)displayContent
{
    BOOL photoStatus = [SellingManager sharedSellingManager].photoStatus;
    BOOL videoStatus = [SellingManager sharedSellingManager].videoStatus;
    BOOL videoExtendStatus = [SellingManager sharedSellingManager].videoExtendStatus;
//    _promotion = [SellingManager sharedSellingManager].promotionStatus;
    
    NSLog(@"promotion (display content)--- %d ",_promotion);
    
    UIColor *greenColor =  [UIColor colorWithRed:0/255 green:139.0/255 blue:123.0/255 alpha:1.0];
    
    CGFloat y = 230;
    CGFloat x = 20;
    CGFloat width = self.view.frame.size.width;
    float price = 0.0;
    
    
    if (photoStatus || videoStatus || videoExtendStatus || _promotion)
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
        
        
        
        if (photoStatus)
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
        if (videoStatus)
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
        if(videoExtendStatus)
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
    BOOL photoStatus = [SellingManager sharedSellingManager].photoStatus;
    BOOL videoStatus = [SellingManager sharedSellingManager].videoStatus;
    BOOL videoExtendStatus = [SellingManager sharedSellingManager].videoExtendStatus;
//    _promotion = [SellingManager sharedSellingManager].promotionStatus;
    
    NSString *stkid = [LocalDataInterface retrieveStkid];
    NSInteger skillId = 0;
    NSString *name = [SellingManager sharedSellingManager].skillName;
    NSString *description = [SellingManager sharedSellingManager].skillDesc;
    NSInteger catId = [SellingManager sharedSellingManager].skillCategoryId;
    NSInteger type = [SellingManager sharedSellingManager].skillType;
    NSString *summary = [SellingManager sharedSellingManager].skillSummary;
    NSDecimalNumber *price = [SellingManager sharedSellingManager].skillPrice;
    NSInteger rateId = [SellingManager sharedSellingManager].skillRate;
    
    NSLog(@"photo status -- %d",photoStatus);
    NSLog(@"videoStatus --- %d ",videoStatus);
    NSLog(@"videoExtendStatus --- %d ",videoExtendStatus);
    NSLog(@"promotion --- %d ",_promotion);
    NSLog(@"stkid --- %@ ",[LocalDataInterface retrieveStkid]);
    NSLog(@"name --- %@ ",[SellingManager sharedSellingManager].skillName);
    NSLog(@"description --- %@ ",[SellingManager sharedSellingManager].skillDesc);
    NSLog(@"catId --- %ld ",(long)[SellingManager sharedSellingManager].skillCategoryId);
    NSLog(@"type --- %ld ",(long)[SellingManager sharedSellingManager].skillType);
    NSLog(@"summary --- %@ ",[SellingManager sharedSellingManager].skillSummary);
    NSLog(@"rateId --- %ld ",(long)rateId);
    NSLog(@"price --- %ld ",(long)price);

    
    
    
    
    
    if (photoStatus || videoStatus || videoExtendStatus || _promotion)
    {
        NSLog(@"yes choice");
    }
    else
    {
        [WebDataInterface createUpdateSubPlan:stkid skillId:skillId name:name description:description catId:catId type:type summary:summary price:price rateId:rateId subId1:0 subMonth:0 subPrice:0 subTotal:0 subType:0 status1:0 subId3:0 photoMonth:0 photoPrice:0 photoTotal:0 photoType:0 status3:0 subId4:0 videoMonth:0 videoPrice:0 videoTotal:0 videoType:0 status4:0 subId5:0 extendMonth:0 extendPrice:0 extendTotal:0 extendType:0 status5:0 subId2:0 extraMonth:0 extraPrice:0 extraTotal:0 extraType:0 status2:0 completion:^(NSObject *obj, NSError *err)
        {
            
            NSLog(@"obj ---- %@ ",obj);
            NSLog(@"err ---- %@",err);
        }];
    
        
        
    }
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
