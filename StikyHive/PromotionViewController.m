//
//  PromotionViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 3/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "PromotionViewController.h"
#import "ViewControllerUtil.h"
#import "SellingManager.h"
#import "PaySummaryViewController.h"
#import "UIView+RNActivityView.h"
#import "LocalDataInterface.h"
#import "WebDataInterface.h"
#import "SubInfo.h"

@interface PromotionViewController ()

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

@implementation PromotionViewController{
    
    NSMutableArray *_subInfos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Start Selling";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if(_mySkillInfo == nil)
        return;
    
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
             
             //[self.view hideActivityView];
             
             [self pullData];
             
         });
         
     }];
}

- (void)pullData{
    
    //[self.view showActivityViewWithLabel:@"Refreshing..." detailLabel:@"Fetching data"];
    [WebDataInterface selectSubInfo:[LocalDataInterface retrieveStkid] completion:^(NSObject *obj, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error != nil){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to get data!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                
            }
            else{
                
                NSDictionary *dic = (NSDictionary *)obj;
                
                NSLog(@"sub info ---- %@",dic);
                
                NSLog(@"info count --- %lu",(unsigned long)((NSArray *)dic[@"subInfo"]).count);
                
                if(((NSArray *)dic[@"subInfo"]).count <=0){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No result" message:@"No subscription!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                }
                else{
                    
                    _subInfos = [[NSMutableArray alloc] init];
                    
                    NSArray *data = dic[@"subInfo"];
                    
                    for(int i=0; i<data.count; i++){
                        
                        NSArray *subData = data[i];
                        
                        if(subData != nil){
                            
                            SubInfo *info = [SubInfo createSubInfoFromDictionary:subData[0]];
                            
                            for(int j=0; j<subData.count; j++){
                                
                                NSDictionary *subDic = subData[j];
                                
                                [info addSubPlanId:[subDic[@"subscriptionplanId"] integerValue]];
                            }
                            
                            [_subInfos addObject:info];
                        }
                        
                    }
                    
                    /*
                     for(NSArray *data in dic[@"subInfo"]){
                     
                     SubInfo *info = [SubInfo createSubInfoFromDictionary:data[0]];
                     [_subInfos addObject:info];
                     }
                     */
                    
                    
                    [self.view hideActivityView];
                    
                    return;
                }
                
            }
            
            [self.view hideActivityView];
            
            //[self.navigationController popViewControllerAnimated:YES];
            
        });
    }];
}

- (BOOL)containPlan:(NSInteger)plan{
    
    for(SubInfo *info in _subInfos){
        
        for(NSNumber *planId in info.subPlanId){
           
            if([planId integerValue] == plan){
                
                return YES;
            }
        }
    }
    
    return NO;
}

- (IBAction)wantBtnPressed:(id)sender
{
    
    [SellingManager sharedSellingManager].promotionStatus = YES;
    
    
    if(![self containPlan:1]){
        
        [SellingManager sharedSellingManager].promotionStatus = YES;
        
        UIViewController *vc = [ViewControllerUtil instantiateViewController:@"pay_summary_view_controller"];
        PaySummaryViewController *sv = (PaySummaryViewController *)vc;
        sv.mySkillInfo = _mySkillInfo;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if([SellingManager sharedSellingManager].promotionStatus && ![self containPlan:2]){
        
        [SellingManager sharedSellingManager].promotionStatus = YES;
        
        UIViewController *vc = [ViewControllerUtil instantiateViewController:@"pay_summary_view_controller"];
        PaySummaryViewController *sv = (PaySummaryViewController *)vc;
        sv.mySkillInfo = _mySkillInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([SellingManager sharedSellingManager].photoStatus && ![self containPlan:3]){
        
        [SellingManager sharedSellingManager].promotionStatus = YES;
        
        UIViewController *vc = [ViewControllerUtil instantiateViewController:@"pay_summary_view_controller"];
        PaySummaryViewController *sv = (PaySummaryViewController *)vc;
        sv.mySkillInfo = _mySkillInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([SellingManager sharedSellingManager].videoStatus && ![self containPlan:4]){
        
        [SellingManager sharedSellingManager].promotionStatus = YES;
        
        UIViewController *vc = [ViewControllerUtil instantiateViewController:@"pay_summary_view_controller"];
        PaySummaryViewController *sv = (PaySummaryViewController *)vc;
        sv.mySkillInfo = _mySkillInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([SellingManager sharedSellingManager].videoExtendStatus && ![self containPlan:5]){
        
        [SellingManager sharedSellingManager].promotionStatus = YES;
        
        UIViewController *vc = [ViewControllerUtil instantiateViewController:@"pay_summary_view_controller"];
        PaySummaryViewController *sv = (PaySummaryViewController *)vc;
        sv.mySkillInfo = _mySkillInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        
        [self uploadDataToServer];
    }

     NSLog(@"promotion status --- %d",[SellingManager sharedSellingManager].promotionStatus);
    
}

- (IBAction)laterBtnPressed:(id)sender
{
    
    if(_mySkillInfo == nil){
        
        [SellingManager sharedSellingManager].promotionStatus = NO;
        
        UIViewController *vc = [ViewControllerUtil instantiateViewController:@"pay_summary_view_controller"];
        PaySummaryViewController *sv = (PaySummaryViewController *)vc;
        sv.mySkillInfo = _mySkillInfo;
        [self.navigationController pushViewController:vc animated:YES];
        
        NSLog(@"promotion status --- %d",[SellingManager sharedSellingManager].promotionStatus);
    }
    else{
        
        if(![self containPlan:1]){
            
            [SellingManager sharedSellingManager].promotionStatus = NO;
            
            UIViewController *vc = [ViewControllerUtil instantiateViewController:@"pay_summary_view_controller"];
            PaySummaryViewController *sv = (PaySummaryViewController *)vc;
            sv.mySkillInfo = _mySkillInfo;
            [self.navigationController pushViewController:vc animated:YES];

        }
        else if([SellingManager sharedSellingManager].photoStatus && ![self containPlan:3]){
            
            [SellingManager sharedSellingManager].promotionStatus = NO;
            
            UIViewController *vc = [ViewControllerUtil instantiateViewController:@"pay_summary_view_controller"];
            PaySummaryViewController *sv = (PaySummaryViewController *)vc;
            sv.mySkillInfo = _mySkillInfo;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if([SellingManager sharedSellingManager].videoStatus && ![self containPlan:4]){
            
            [SellingManager sharedSellingManager].promotionStatus = NO;
            
            UIViewController *vc = [ViewControllerUtil instantiateViewController:@"pay_summary_view_controller"];
            PaySummaryViewController *sv = (PaySummaryViewController *)vc;
            sv.mySkillInfo = _mySkillInfo;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if([SellingManager sharedSellingManager].videoExtendStatus && ![self containPlan:5]){
            
            [SellingManager sharedSellingManager].promotionStatus = NO;
            
            UIViewController *vc = [ViewControllerUtil instantiateViewController:@"pay_summary_view_controller"];
            PaySummaryViewController *sv = (PaySummaryViewController *)vc;
            sv.mySkillInfo = _mySkillInfo;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            
            [self uploadDataToServer];
        }
    }

}

#pragma mark - upload
- (void)uploadDataToServer
{
    [self.view showActivityViewWithLabel:@"Uploading..."];
    
    
    NSString *stkid = [LocalDataInterface retrieveStkid];
    NSInteger skillId = [_mySkillInfo.skillId integerValue];
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
    
    NSArray *photoArray = smg.photoCaption;
    
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
            /*
             [WebDataInterface updateSubSkillStatus:skillid duration:subMonthInt completion:^(NSObject *objS, NSError *errS) {
             
             NSLog(@"obj skill ---- %@ ",objS);
             NSLog(@"err skill --- %@",errS);
             NSDictionary *dictS = (NSDictionary *)objS;
             
             if (dictS && [dictS[@"status"] isEqualToString:@"success"])
             {
             
             
             
             }
             
             [self.view hideActivityView];
             
             }];
             */
            
            for (int i =0; i < photoArray.count; i++) {
                ImageCaption *ic = photoArray[i];
                
                NSLog(@"image 888888--- %@",ic.image);
                NSLog(@"caption 8888888--- %@",ic.caption);
                if (ic.image != nil) {
                    
                    NSLog(@"upload image with payment !!!!!!!!!");
                    
                    [WebDataInterface skillImageUpload:ic.image stikyid:stkid skillId:skillid type:1 editFlage:ic.edit photoId:ic.photoId caption:ic.caption];
                    
                    //[WebDataInterface skillImageUploadTest:ic.image stikyid:stkid type:1 editFlage:NO photoId:0 caption:ic.caption];
                    
                }
                
            }
            
            if([SellingManager sharedSellingManager].video != nil){
                
                [WebDataInterface skillVideoUpload:[SellingManager sharedSellingManager].video thumbnail:[SellingManager sharedSellingManager].videoImage stikyid:stkid skillId:skillid type:1 editFlage:[SellingManager sharedSellingManager].videoEdit videoId:[SellingManager sharedSellingManager].videoId isExtend:[SellingManager sharedSellingManager].videoExtendStatus];
            }
            
            if([SellingManager sharedSellingManager].secVideo != nil){
                
                [WebDataInterface skillVideoUpload:[SellingManager sharedSellingManager].secVideo thumbnail:[SellingManager sharedSellingManager].secVideoImage stikyid:stkid skillId:skillid type:1 editFlage:[SellingManager sharedSellingManager].videoEdit videoId:[SellingManager sharedSellingManager].videoId isExtend:[SellingManager sharedSellingManager].videoExtendStatus];
            }
            
            [smg clearCurrentSelling];
            [self.view hideActivityView];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(self.navigationController != nil){
                    
                    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"pay_sucess_view_controller"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            });
            
            
        }
        
        
        
        
        
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            
            UIViewController *vc = [ViewControllerUtil instantiateViewController:@"pay_sucess_view_controller"];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }];
        
        
    }];
    
    
}

@end
