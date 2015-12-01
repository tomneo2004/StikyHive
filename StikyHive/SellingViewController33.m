//
//  SellingViewController33.m
//  StikyHive
//
//  Created by THV1WP15S on 27/11/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "SellingViewController33.h"
#import "ViewControllerUtil.h"

@interface SellingViewController33 ()

@property (nonatomic, strong) NSArray *skillImageViews;

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
    
    
    [_contentViewController setContentSize:CGSizeMake(self.view.frame.size.width, 1200)];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [_contentViewController addGestureRecognizer:tapGestureRecognizer];
    
//    _textField1.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0);
//    _textField2.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0);
//    _textField3.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0);
//    _textField4.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0);
    
    
    _skillImageViews = @[_imageView1,_imageView2,_imageView3,_imageView4];
    
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


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self.view endEditing:YES];// this will do the trick
    [_textField1 resignFirstResponder];
    
}

- (void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [_contentViewController endEditing:YES];
}


- (IBAction)nextButtonPressed:(id)sender
{
    
    
    
    
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"selling_view_controller_4"];
    [self.navigationController pushViewController:vc animated:YES];
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
