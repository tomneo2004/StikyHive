//
//  SellingViewController3.m
//  StikyHive
//
//  Created by THV1WP15S on 24/11/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "SellingViewController3.h"
#import "ViewControllerUtil.h"

@interface SellingViewController3 ()

@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) NSMutableArray *imageviewArray;

@end

@implementation SellingViewController3

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
    
    return  [ViewControllerUtil instantiateViewController:@"selling_view_controller_3"];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Start Selling";
    
    _contentScrollView.alwaysBounceVertical = YES;
    _contentScrollView.delegate = self;
    
    _imageviewArray = [[NSMutableArray alloc] init];
    
    CGFloat y = 33;
    CGFloat x = 20;
    CGFloat width = self.view.frame.size.width;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 200, 20)];
    titleLabel.text = @"Upload your photos";
    [_contentScrollView addSubview:titleLabel];
    
    y = y + titleLabel.frame.size.height  + 20;
    
    
    for (int i = 0; i < 4; i++)
    {
        
        y = [self createImageView:CGPointMake(20, y) andTarget:i];
        
    }
    
    
    UILabel *deslLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 200, 200)];
    deslLabel.text = @"Please upload at least one photo. The first photo uploaded wil be your thumbnail image.";
    deslLabel.numberOfLines = 0;
    deslLabel.textAlignment = NSTextAlignmentCenter;
    [deslLabel sizeToFit];
    CGPoint deslCenter = deslLabel.center;
    deslCenter.x = self.view.center.x;
    deslLabel.center = deslCenter;
    
    
    y = y + deslLabel.frame.size.height + 10;
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 200, 50)];
    descLabel.text = @"Photos must be originally yours.";
    [descLabel sizeToFit];
    descLabel.textAlignment = NSTextAlignmentCenter;
    CGPoint descCenter = descLabel.center;
    descCenter.x = self.view.center.x;
    descLabel.center = descCenter;
    
    y = y + descLabel.frame.size.height + 20;
    
    [_contentScrollView addSubview:deslLabel];
    [_contentScrollView addSubview:descLabel];
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width -40, 50)];
    [nextBtn setTitle:@"Next" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.backgroundColor = [UIColor colorWithRed:19.0/255 green:152.0/255 blue:139.0/255 alpha:1.0];
    nextBtn.layer.cornerRadius = 5;
    nextBtn.layer.masksToBounds = YES;

    
    [_contentScrollView addSubview:nextBtn];
    
    y = y + nextBtn.frame.size.height+20;
    
    
    [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width, y)];
    
    
    NSLog(@"skillinfo --- %@",Skill_Info);
    NSLog(@"humbnail ---- %@",Video_Thumbnail);
    NSLog(@"video --- %@",Video_Data);
    
    NSLog(@"image view array --- %@",_imageviewArray);
}

- (CGFloat)createImageView:(CGPoint)point andTarget:(NSInteger)target
{
    CGFloat y = point.y;
    CGFloat width = 240;
    CGFloat height = 145;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, y, width, height)];
    imageView.image = [UIImage imageNamed:@"sell_upload_photo"];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoImageViewTapped:)]];
    [imageView setUserInteractionEnabled:YES];
    [imageView setTag:target];
    
    
    
    CGPoint imageViewCenter = imageView.center;
    imageViewCenter.x = self.view.center.x;
    imageView.center = imageViewCenter;
    
    y = y + imageView.frame.size.height + 10;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(point.x, y, self.view.frame.size.width - 40, 40)];
    textField.backgroundColor = [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Caption"];
    textField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0);
    
    y = y + textField.frame.size.height + 20;
    
    
    
    [_contentScrollView addSubview:imageView];
    [_contentScrollView addSubview:textField];
    
    
    [_imageviewArray addObject:imageView];
    
    return y;
}

- (void)photoImageViewTapped:(UITapGestureRecognizer *)sender
{
//    NSInteger tag = sender.view.tag;
    
    [self showCropViewControllerWithOptions:_imageviewArray[sender.view.tag] andType:2];
    
    NSLog(@"sender view tag --- %ld",(long)sender.view.tag);
    
    NSLog(@"select image veiw --- %@",_imageviewArray[sender.view.tag]);
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
