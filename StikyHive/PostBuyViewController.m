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
#import "HtmlEditor.h"
#import "BuyManager.h"


@interface PostBuyViewController ()


@property (nonatomic, strong) NSMutableArray *industryArray;
@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (nonatomic, strong) NSArray *skillArray;
@property (nonatomic, strong) NSArray *rateArray;
@property (nonatomic, strong) UIPickerView *industryPickerView;
@property (nonatomic, assign) NSString *categoryId;
@property (nonatomic, assign) NSInteger rateId;
@property (nonatomic, assign) NSInteger skillType;
@property (nonatomic, strong) NSArray *hhArray;
@property (nonatomic, strong) NSArray *mmArray;
@property (nonatomic, assign) BOOL descEditorLoaded;
@property (nonatomic, assign) BOOL respEditorLoaded;
@property (nonatomic, strong) HtmlEditor *descEditor;
@property (nonatomic, strong) HtmlEditor *respEditor;
@property (nonatomic, strong) BuyManager *buyManager;

@end

@implementation PostBuyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _contentScrollView.alwaysBounceVertical = YES;
    _contentScrollView.delegate = self;
    
    
    [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1200)];
    
    _professionalBtn.layer.borderWidth = 1;
    _professionalBtn.layer.borderColor = [UIColor blackColor].CGColor;
    _rawBtn.layer.borderColor = [UIColor blackColor].CGColor;
    _rawBtn.layer.borderWidth = 1;
    _professionalBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    _buyManager = [BuyManager sharedBuyManager];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    //    tapGestureRecognizer.delegate = self;
    [self.contentScrollView addGestureRecognizer:tapGestureRecognizer];
    
    _industryArray = [[NSMutableArray alloc] init];
    _categoryArray = [[NSMutableArray alloc] init];
//    _skillType = 1;
    
    _buyManager.type = 1;
    
    _hhArray = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
    _mmArray = @[@"00",@"05",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55"];
    
    
    
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
    
    _toHHTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"HH"];
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
    
    
    _nameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0);
    
    _descWebView.delegate = self;
    _descWebView.tag = 777;
    
    UITapGestureRecognizer *tapCatcher = [[UITapGestureRecognizer alloc] init];
    [tapCatcher setNumberOfTapsRequired:1];
    [tapCatcher setDelegate:self];
    
    [_descWebView addGestureRecognizer:tapCatcher];
    
    _respWebView.delegate = self;
    _respWebView.tag = 888;
    
    UITapGestureRecognizer *tapCatcher2 = [[UITapGestureRecognizer alloc] init];
    [tapCatcher2 setNumberOfTapsRequired:1];
    [tapCatcher2 setDelegate:self];
    
    [_respWebView addGestureRecognizer:tapCatcher2];
    

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
    
    if (_descEditorLoaded) {
        [_descWebView loadHTMLString:[_descEditor getHTML] baseURL:nil];
        _descEditorLoaded = NO;
    }
    else if (_respEditorLoaded)
    {
        [_respWebView loadHTMLString:[_respEditor getHTML] baseURL:nil];
        _respEditorLoaded = NO;
    }

    
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    if ([otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && !_descEditorLoaded && gestureRecognizer.view.tag == 777)
    {
        _descEditorLoaded = YES;
        _descEditor = [[HtmlEditor alloc] init];
        [_descEditor setHTML:[_descWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"]];
        [self.navigationController pushViewController:_descEditor animated:YES];
        
    }
    else if ([otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && !_respEditorLoaded && gestureRecognizer.view.tag == 888)
    {
        _respEditorLoaded = YES;
        _respEditor = [[HtmlEditor alloc] init];
        [_respEditor setHTML:[_respWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"]];
        [self.navigationController pushViewController:_respEditor animated:YES];
    }
    
    return YES;
}

#pragma mark - picker view delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
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
        
        _rateId = [_rateArray[row][@"id"] integerValue];
        
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
    
//    NSString *descString = [_descWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
//    NSString *respString = [_respWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    NSString *innerDesc = [_descWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].innerHTML"];
    NSString *innerResp = [_respWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].innerHTML"];
    
    
    NSString *fromdate = @"";
    NSString *todate = @"";
    if (_fromMMTextField.text.length > 0 || _fromHHTextField.text.length > 0)
    {
        fromdate = [NSString stringWithFormat:@"%@:%@",_fromHHTextField.text,_fromMMTextField.text];
        NSLog(@"from date ------ %@",fromdate);

    }
    
    if (_toHHTextField.text.length > 0 || _toMMTextField.text.length > 0)
    {
        todate = [NSString stringWithFormat:@"%@:%@",_toHHTextField.text,_toMMTextField.text];
    }
    
    _buyManager.fromHH = fromdate;
    _buyManager.toHH = todate;
    
    
    
    if (_individualRBtn.isSelected)
    {
        _buyManager.personType = 2;
    }
    else
    {
        _buyManager.personType = 1;
    }
    
    if (_fulltRBtn.isSelected) {
        _buyManager.jobType = 1;
    }
    else{
        _buyManager.jobType = 2;
    }
    
    if (_openRBtn.isSelected) {
        _buyManager.availability = 1;
    }
    else
    {
        _buyManager.availability = 0;
    }
    
    _buyManager.name = _nameTextField.text;
    
    
    NSString *priceString = _priceTextField.text;
    
    if (priceString.length > 0)
     {
        NSDecimalNumber *priceFloat = [NSDecimalNumber decimalNumberWithString:priceString];
        _buyManager.price = priceFloat;
        _buyManager.rateId = _rateId;
        
    }
    else
    {
        NSDecimalNumber *zero = [[NSDecimalNumber alloc] initWithFloat:0.0];
        _buyManager.price = zero;
        _buyManager.rateId =[@"0" integerValue];
    }
    
    _buyManager.catId = [_categoryId integerValue];
    
    _buyManager.desc = innerDesc;
    _buyManager.resp = innerResp;
    
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"buyer_photo_view_controller"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)professionalBtnTapped:(id)sender
{
    _skillArray = [_industryArray mutableCopy];
    [_industryPickerView reloadAllComponents];
    
    _professionalBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _rawBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
//    _skillType = 1;
    _buyManager.type = 1;
}

- (IBAction)rawBtnTapped:(id)sender
{
    _skillArray = [_categoryArray mutableCopy];
    [_industryPickerView reloadAllComponents]; //reload picker view data
    
    _rawBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _professionalBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
//    _skillType = 2;
    _buyManager.type = 2;
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
