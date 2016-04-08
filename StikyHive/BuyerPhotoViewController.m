//
//  BuyerPhotoViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 23/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "BuyerPhotoViewController.h"
#import "LocalDataInterface.h"
#import "WebDataInterface.h"
#import "BuyManager.h"
#import "ViewControllerUtil.h"
#import "UIView+RNActivityView.h"
#import "UIImageView+AFNetworking.h"

@interface BuyerPhotoViewController ()


@property (nonatomic, assign) BOOL imageSelected;

@end

@implementation BuyerPhotoViewController{
    
    BOOL _isLoaded;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SEL selImage = @selector(tapImageDetected:);
    [_photoImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:selImage]];
    [_photoImageView setUserInteractionEnabled:YES];
    
    _isLoaded = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if(_myPostInfo != nil && ![_myPostInfo.location isEqual:[NSNull null]] && !_isLoaded){
        
        [self.view showActivityViewWithLabel:@"Fetching image..."];
        
        __weak typeof(self) weakSelf = self;
        __weak UIImageView *weakImageView = _photoImageView;
        [_photoImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[WebDataInterface getFullUrlPath:_myPostInfo.location]]] placeholderImage:[UIImage imageNamed:@"upload_buyer.png"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            
            weakImageView.image = image;
            
            [weakSelf.view hideActivityView];
            
            _isLoaded = YES;
            
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            
            [weakSelf.view hideActivityView];
            
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)onImageCropSuccessfulWithImageView:(UIImageView *)imageView
{
    _imageSelected = YES;
    
}


- (void)tapImageDetected:(UITapGestureRecognizer *)tapGestureRecognizer
{
    
    [self showCropViewControllerWithOptions:_photoImageView andType:1];
}

- (void)uploadImage:(UIImage *)profileImage stikyid:(NSString *)stikyid type:(NSInteger)type buyerId:(NSInteger)buyerId editFlag:(BOOL)editFlag
{
    NSLog(@"upload image");
    
    NSData *imageData =UIImageJPEGRepresentation(profileImage, 0.0);
    
    NSString *urlString = [NSString stringWithFormat:@"http://beta.stikyhive.com:81/androidstikyhive/filebuyerupload.php?stkid=%@&type=%ld&buyerId=%ld&editFlag=%d",stikyid,(long)type,(long)buyerId,editFlag];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    // NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_file\"; filename=\1\r\n"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
}

- (IBAction)nextBtnPressed:(id)sender
{
    
    BuyManager *bmg = [BuyManager sharedBuyManager];
    NSString *stkid = [LocalDataInterface retrieveStkid];
    NSInteger active = 1;
    NSString *time = @"00:00";
    
    [self.view showActivityViewWithLabel:@"Uploading..."];
    
    [WebDataInterface saveBuyerMarket:stkid type:bmg.type name:bmg.name description:bmg.desc respons:bmg.resp active:active catId:bmg.catId jobType:bmg.jobType personType:bmg.personType availability:bmg.availability startTime:bmg.fromHH endTime:bmg.toHH price:bmg.price rateId:bmg.rateId completion:^(NSObject *obj, NSError *err) {
        
        
        NSLog(@"obj --- %@", obj);
        NSDictionary *dict = (NSDictionary *)obj;
        if (dict && [dict[@"status"] isEqualToString:@"success"])
        {
            
            
                if (_imageSelected) {
            
                    NSLog(@"have image");
                    UIImage *image = _photoImageView.image;
                    NSString *stkid = [LocalDataInterface retrieveStkid];
//                    NSInteger buyer = 197;
            
                    [self uploadImage:image stikyid:stkid type:2 buyerId:[dict[@"buyerId"] integerValue] editFlag:NO];
                    
                    
                }
            
            
            [self.view hideActivityView];

            
            UIViewController *vc = [ViewControllerUtil instantiateViewController:@"buy_sucess_view_controller"];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
        
        
        
        
        
    }];
    
    
    
    
    
//    if (_imageSelected) {
//        
//        NSLog(@"have image");
//        UIImage *image = _photoImageView.image;
//        NSString *stkid = [LocalDataInterface retrieveStkid];
//        NSInteger buyer = 197;
//        
//        [self uploadImage:image stikyid:stkid type:2 buyerId:buyer editFlag:NO];
//        
//        
//    }
    
    
    
}
@end
