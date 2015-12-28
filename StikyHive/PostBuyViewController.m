//
//  PostBuyViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 18/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "PostBuyViewController.h"
#import "RadioButton.h"
#import "ViewControllerUtil.h"
#import "WebDataInterface.h"
#import "UIView+RNActivityView.h"


@interface PostBuyViewController ()


@property (nonatomic, strong) NSMutableArray *industryArray;
@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (nonatomic, strong) NSArray *skillArray;
@property (nonatomic, strong) NSArray *rateArray;
@property (nonatomic, strong) UIPickerView *industryPickerView;
@property (nonatomic, assign) NSString *categoryId;
@property (nonatomic, assign) NSString *rateId;
@property (nonatomic, assign) NSInteger skillType;

@end

@implementation PostBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _contentScrollView.alwaysBounceVertical = YES;
    _contentScrollView.delegate = self;
    
    
    [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1200)];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    //    tapGestureRecognizer.delegate = self;
    [self.contentScrollView addGestureRecognizer:tapGestureRecognizer];
    
    _industryArray = [[NSMutableArray alloc] init];
    _categoryArray = [[NSMutableArray alloc] init];
    _skillType = 1;
    
    [self preparePage];
    
    
    [self.view showActivityViewWithLabel:@"Loading..."];
    
    NSInteger status = 1;
    [WebDataInterface getCategory:status completion:^(NSObject *obj, NSError *err) {
        
        [WebDataInterface getRate:0 completion:^(NSObject *obj2, NSError *err2) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *category = (NSDictionary *)obj;
                NSArray *list = category[@"skills"];
                
                for (int i = 0; i < list.count; i++)
                {
                    
                    NSString *type = [[list objectAtIndex:i]valueForKey:@"type"];
                    long long intType = [type integerValue];
                    if (intType == 1)
                    {
                        [_industryArray addObject:list[i]];
                        
                    }
                    else if (intType == 2)
                    {
                        
                        [_categoryArray addObject:list[i]];
                        
                    }
                }
                
                _skillArray = [_industryArray mutableCopy];
                
                NSDictionary *rate = (NSDictionary *)obj2;
                _rateArray = rate[@"rate"];
                NSLog(@"skill array --- %@",_skillArray);
                NSLog(@"rate array --- %@",_rateArray);


                
                
                
                [self.view hideActivityView];
            });
            
        }];
    }];
    

    
}


- (void)preparePage
{
    _rateTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Select rate"];
    _rateTextField.textAlignment = NSTextAlignmentCenter;
    
    UIPickerView *ratePickerView = [[UIPickerView alloc] init];
    ratePickerView.delegate = self;
    ratePickerView.dataSource = self;
    ratePickerView.tag = 222;
    
    [_rateTextField setInputView:ratePickerView];
    
    
    
    
    
    _industryTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Select Industry"];
    _industryTextField.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0);
    
    _industryPickerView = [[UIPickerView alloc] init];
    _industryPickerView.delegate = self;
    _industryPickerView.dataSource = self;
    _industryPickerView.tag = 111;
    
    [_industryTextField setInputView:_industryPickerView];

    
    
    
}


- (void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [_contentScrollView endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    
}

#pragma mark - picker view delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag == 111)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 111)
    {
        return _skillArray.count;
    }
    else
    {
        return _rateArray.count;
    }
    
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 111)
    {
        return _skillArray[row][@"name"];
    }
    else
    {
        return _rateArray[row][@"name"];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 111) {
        NSString *name = _skillArray[row][@"name"];
        _industryTextField.text = name;
        
        _categoryId = _skillArray[row][@"id"];
        
    }
    else
    {
        _rateTextField.text = _rateArray[row][@"name"];
        
        _rateId = _rateArray[row][@"id"];
        
    }
    
    
}




- (IBAction)nextBtnPressed:(id)sender
{
    
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"buyer_photo_view_controller"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)professionalBtnTapped:(id)sender
{
    _skillArray = [_industryArray mutableCopy];
    [_industryPickerView reloadAllComponents];
    
//    _professBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//    _talentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    _skillType = 1;
}

- (IBAction)rawBtnTapped:(id)sender
{
    _skillArray = [_categoryArray mutableCopy];
    [_industryPickerView reloadAllComponents]; //reload picker view data
    
//    _talentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//    _professBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    _skillType = 2;
}

- (IBAction)onPersonTypeRTapped:(id)sender {
}

- (IBAction)onJobTypeRTapped:(id)sender {
}

- (IBAction)onAvailabitityRTapped:(id)sender {
}
@end
