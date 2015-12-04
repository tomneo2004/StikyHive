//
//  SellingViewController33.m
//  StikyHive
//
//  Created by THV1WP15S on 27/11/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "SellingViewController33.h"
#import "ViewControllerUtil.h"
#import "SellingManager.h"

@interface SellingViewController33 ()

@property (nonatomic, strong) NSArray *skillImageViews;
@property (nonatomic, assign) BOOL imageSelected0;
@property (nonatomic, assign) BOOL imageSelected1;
@property (nonatomic, assign) BOOL imageSelected2;
@property (nonatomic, assign) BOOL imageSelected3;

@property (nonatomic, strong) UIImageView *imageView5;
@property (nonatomic, strong) UIImageView *imageView6;
@property (nonatomic, strong) UIImageView *imageView7;
@property (nonatomic, strong) UIImageView *imageView8;


@property (nonatomic, strong) NSMutableArray *imageFileArray;
@property (nonatomic, strong) NSMutableDictionary *imageDict;

@end

@implementation SellingViewController33

static NSMutableDictionary *Skill_Info;
static UIImage *Video_Thumbnail;
static NSData *Video_Data;



+ (UIViewController *)instantiateForInfo:(NSDictionary *)skillInfo
                              videoThumb:(UIImage *)thumbImage
                            andVideodata:(NSData *)videoData
{
    
    Skill_Info = skillInfo.mutableCopy;
    Video_Thumbnail = thumbImage;
    Video_Data = videoData;
    
    return  [ViewControllerUtil instantiateViewController:@"selling_view_controller_33"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _contentViewController.alwaysBounceVertical = YES;
    _contentViewController.delegate = self;

    
    _imageDict = [[NSMutableDictionary alloc] init];
    NSLog(@"crop dicr ---- %@",_imageDict);
    
    _imageFileArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++)
    {
        [_imageFileArray insertObject:[NSNull null] atIndex:i];
    }
    
    
    BOOL status = [SellingManager sharedSellingManager].photoStatus;
    if (status)
    {
     
        _imageFileArray = [[SellingManager sharedSellingManager].photoArray mutableCopy];
        
        for (int i = 0; i < _imageFileArray.count; i++)
        {
            UIImage *image = _imageFileArray[i];
            if (image != [NSNull null]) {
                if (i==0) {
                    _imageView1.image = image;
                }
                else if (i==1)
                {
                    _imageView2.image = image;
                }
                else if (i==2)
                {
                    _imageView3.image = image;
                }
                else if (i==3)
                {
                    _imageView4.image = image;
                }
                
            }
        }
        
        
        CGFloat y = 896 + 30;
        CGFloat imageW = 240;
        CGFloat imageH = 145;
        
        for (int i = 4; i < 8; i++)
        {
            [_imageFileArray insertObject:[NSNull null] atIndex:i];
        }
        
        
        _imageView5 = [[UIImageView alloc] initWithFrame:CGRectMake(20, y, imageW, imageH)];
        CGPoint center5 = _imageView5.center;
        center5.x = _contentViewController.center.x;
        _imageView5.center = center5;
//        _imageView5.image = [UIImage imageNamed:@"sell_upload_photo"];
        
        y = y + imageH + 30;
        
        
        _imageView6 = [[UIImageView alloc] initWithFrame:CGRectMake(20, y, imageW, imageH)];
        CGPoint center6 = _imageView6.center;
        center6.x = _contentViewController.center.x;
        _imageView5.center = center5;
        _imageView6.image = [UIImage imageNamed:@"sell_upload_photo"];
        
        y = y + imageH + 30;

        _imageView7 = [[UIImageView alloc] initWithFrame:CGRectMake(20, y, imageW, imageH)];
        CGPoint center7 = _imageView7.center;
        center7.x = _contentViewController.center.x;
        _imageView7.center = center7;
        _imageView7.image = [UIImage imageNamed:@"sell_upload_photo"];
        
        y = y + imageH + 30;

        
        
        _imageView8 = [[UIImageView alloc] initWithFrame:CGRectMake(20, y, imageW, imageH)];
        CGPoint center8 = _imageView8.center;
        center8.x = _contentViewController.center.x;
        _imageView8.center = center8;
        _imageView8.image = [UIImage imageNamed:@"sell_upload_photo"];
        
        y = y + imageH + 30;

        
        
//        [_contentViewController addSubview:_imageView5];
        [_contentViewController addSubview:_imageView6];
        [_contentViewController addSubview:_imageView7];
        [_contentViewController addSubview:_imageView8];
        
        [_contentViewController addSubview:[_imageView5 initWithImage:[UIImage imageNamed:@"sell_upload_photo"]]];
        
        
        [_contentViewController setContentSize:CGSizeMake(self.view.frame.size.width, y)];
        
        
        
        _skillImageViews = @[_imageView1,_imageView2,_imageView3,_imageView4,_imageView5,_imageView6,_imageView7,_imageView8];
    }
    else
    {
       
        
        [_contentViewController setContentSize:CGSizeMake(self.view.frame.size.width, 1200)];
        
        _skillImageViews = @[_imageView1,_imageView2,_imageView3,_imageView4];
        
        
        
        [_contentViewController addSubview:[_imageView1 initWithImage:[UIImage imageNamed:@"sell_upload_photo"]]];
        [_contentViewController addSubview:[_imageView2 initWithImage:[UIImage imageNamed:@"sell_upload_photo"]]];
        [_contentViewController addSubview:[_imageView3 initWithImage:[UIImage imageNamed:@"sell_upload_photo"]]];
    }
    
    
    
    
    
    
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [_contentViewController addGestureRecognizer:tapGestureRecognizer];
    
    
    for (int i = 0; i < _skillImageViews.count; i++)
    {
        UIGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
        [_skillImageViews[i] addGestureRecognizer:rec];
        [_skillImageViews[i] setUserInteractionEnabled:YES];
        [_skillImageViews[i] setTag:i];
    }
    
    
    
}

- (void)imageViewTapped:(UITapGestureRecognizer *)sender
{
    [self showCropViewControllerWithOptions:_skillImageViews[sender.view.tag] andType:2];
}


#pragma mark - override
- (void)onImageCropSuccessfulWithImageView:(UIImageView *)imageView
{
    if (imageView.tag == 0)
    {
        _imageSelected0 = YES;
//        UIImageView *imageview = _skillImageViews[0];
        UIImage *image = _imageView1.image;
        
        [_imageFileArray replaceObjectAtIndex:0 withObject:image];
        [_imageDict setObject:image forKey:@"0"];
        NSLog(@"crop dicr ---- %@",_imageFileArray);
        NSLog(@"crop successful ---- 0");
    }
    else if (imageView.tag == 1)
    {
        _imageSelected1 = YES;
        UIImage *image = _imageView2.image;
        [_imageFileArray replaceObjectAtIndex:1 withObject:image];
        
        [_imageDict setObject:image forKey:@"1"];

        NSLog(@"crop dicr ---- %@",_imageFileArray);
        NSLog(@"crop successful ---- 1");
        
    }
    else if (imageView.tag == 2)
    {
        _imageSelected2 = YES;
        UIImage *image = _imageView3.image;
       
        [_imageFileArray replaceObjectAtIndex:2 withObject:image];
        [_imageDict setObject:image forKey:@"2"];
        NSLog(@"crop dicr ---- %@",_imageFileArray);

        NSLog(@"crop successful ---- 2");
    }
    else if (imageView.tag == 3)
    {
        _imageSelected3 = YES;
        UIImage *image = _imageView4.image;

        [_imageFileArray replaceObjectAtIndex:3 withObject:image];
        [_imageDict setObject:image forKey:@"3"];
        NSLog(@"crop successful ---- 3");
        NSLog(@"crop dicr ---- %@",_imageFileArray);
    }
    
    
}


//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
////    [self.view endEditing:YES];// this will do the trick
//    [_textField1 resignFirstResponder];
//    
//}

- (void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [_contentViewController endEditing:YES];
}


- (IBAction)nextButtonPressed:(id)sender
{
    NSMutableArray *checkArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _imageFileArray.count; i++) {
        if (_imageFileArray[i] != [NSNull null]) {
            [checkArray addObject:_imageFileArray[i]];
        }
    }
    
    
//    if (checkArray.count > 0)
//    {
    
        [SellingManager sharedSellingManager].photoArray = [_imageFileArray mutableCopy];
        
        NSLog(@"selling manager array --- %@",[SellingManager sharedSellingManager].photoArray);
        
        
        
        UIViewController *vc = [ViewControllerUtil instantiateViewController:@"selling_view_controller_4"];
        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else
//    {
//        
//        [ViewControllerUtil showAlertWithTitle:@"" andMessage:@"Please upload at least one photo"];
//        
//    }
    
    
  }



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
