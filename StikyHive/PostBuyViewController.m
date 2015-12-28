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
@property (nonatomic, strong) NSArray *hhArray;
@property (nonatomic, strong) NSArray *mmArray;

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
    
    _hhArray = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
    _mmArray = @[@"00",@"05",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55"];
    NSLog(@"hh array --- %@",_hhArray);
    NSLog(@"hh array 4 --- %@",_hhArray[4]);
    
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

    
    _fromHHTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"HH"];
    _fromHHTextField.textAlignment = NSTextAlignmentCenter;
    UIPickerView *fromHHPickerView = [[UIPickerView alloc] init];
    fromHHPickerView.delegate = self;
    fromHHPickerView.dataSource = self;
    fromHHPickerView.tag = 333;
    [_fromHHTextField setInputView:fromHHPickerView];
    
    
    _fromMMTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"MM"];
    _fromMMTextField.textAlignment = NSTextAlignmentCenter;
    UIPickerView *fromMMPickerView = [[UIPickerView alloc] init];
    fromMMPickerView.delegate = self;
    fromMMPickerView.dataSource = self;
    fromMMPickerView.tag = 444;
    [_fromMMTextField setInputView:fromMMPickerView];
    
    _toHHTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"MM"];
    _toHHTextField.textAlignment = NSTextAlignmentCenter;
    UIPickerView *toHHPickerView = [[UIPickerView alloc] init];
    toHHPickerView.delegate = self;
    toHHPickerView.dataSource = self;
    toHHPickerView.tag = 555;
    [_toHHTextField setInputView:toHHPickerView];
    
    
    _toMMTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"MM"];
    _toMMTextField.textAlignment = NSTextAlignmentCenter;
    UIPickerView *toMMPickerView = [[UIPickerView alloc] init];
    toMMPickerView.delegate = self;
    toMMPickerView.dataSource = self;
    toMMPickerView.tag = 666;
    [_toMMTextField setInputView:toMMPickerView];

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
//    if (pickerView.tag == 111)
//    {
//        return 1;
//    }
//    else if (pickerView.tag == 222)
//    {
//        return 1;
//    }
//    else if (pickerView.tag == 333)
//    {
//        return 1;
//    }
//    else{
//        return 1;
//    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 111)
    {
        return _skillArray.count;
    }
    else if(pickerView.tag == 222)
    {
        return _rateArray.count;
    }
    else if (pickerView.tag == 333 || pickerView.tag == 555)
    {
        return _hhArray.count;
    }
    else
    {
        return _mmArray.count;
    }
    
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 111)
    {
        return _skillArray[row][@"name"];
    }
    else if (pickerView.tag == 222)
    {
        return _rateArray[row][@"name"];
    }
    else if (pickerView.tag == 333 || pickerView.tag == 555)
    {
        return _hhArray[row];
    }
    else
    {
        return _mmArray[row];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 111) {
        NSString *name = _skillArray[row][@"name"];
        _industryTextField.text = name;
        
        _categoryId = _skillArray[row][@"id"];
        
    }
    else if (pickerView.tag == 222)
    {
        _rateTextField.text = _rateArray[row][@"name"];
        
        _rateId = _rateArray[row][@"id"];
        
    }
    else if (pickerView.tag == 333)
    {
        _fromHHTextField.text = _hhArray[row];
    }
    else if (pickerView.tag == 444)
    {
        _fromMMTextField.text = _mmArray[row];
    }
    else if (pickerView.tag == 555)
    {
        _toHHTextField.text = _hhArray[row];
    }
    else
    {
        _toMMTextField.text = _mmArray[row];
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

- (IBAction)onPersonTypeRTapped:(RadioButton *)sender
{
    
    NSLog(@"pressed");
    
    
    
}

- (IBAction)onJobTypeRTapped:(id)sender {
}

- (IBAction)onAvailabitityRTapped:(id)sender {
}
@end
