//
//  AddJobViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 5/1/16.
//  Copyright (c) 2016 Stiky Hive. All rights reserved.
//

#import "AddJobViewController.h"
#import "WebDataInterface.h"
#import "CountryInfo.h"
#import "UIView+RNActivityView.h"

@interface AddJobViewController ()

@property (nonatomic, strong) UIPickerView *countryPicker;

@end

@implementation AddJobViewController{
    BOOL _shouldPullData;
    BOOL _isEdit;
    NSMutableArray *_countryInfo;
    NSInteger _countryIndex;
}

@synthesize jobInfo = _jobInfo;
@synthesize infoWebView = _infoWebView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _companyNameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0);
    _jobTitleTextField.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0);
    _countryTextField.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0);
    _fromMMTextField.tag = 111;
    _fromYYTextField.tag = 222;
    _toMMTextField.tag = 333;
    _toYYTextField.tag = 444;
    _fromMMTextField.delegate = self;
    _fromYYTextField.delegate = self;
    _toMMTextField.delegate = self;
    _toYYTextField.delegate = self;
    
    _infoWebView.backgroundColor = [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0];
    [_infoWebView setOpaque:NO];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    //    tapGestureRecognizer.delegate = self;
    [self.jobScrollView addGestureRecognizer:tapGestureRecognizer];
    
//    _jobScrollView.userInteractionEnabled = YES;
    
//    [_countryTextField addTarget:self action:@selector(countryTapped:) forControlEvents:UIControlEventTouchUpInside];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(countryTapped:)];
//    tap.delegate = self;
//    [_countryTextField addGestureRecognizer:tap];
    
    _countryPicker = [[UIPickerView alloc] init];
    _countryPicker.delegate = self;
    _countryPicker.dataSource = self;
    [_countryTextField setInputView:_countryPicker];
    
    
    // prepare for check box
    [_checkBox setImage:[UIImage imageNamed:@"uicheckbox_unchecked"] forState:UIControlStateNormal];
    [_checkBox setImage:[UIImage imageNamed:@"uicheckbox_checked"] forState:UIControlStateSelected];
    
    
    _shouldPullData = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_jobInfo != nil) {
        self.title = @"Update Job";
    }
    else
    {
        self.title = @"Add Job";
    }
    
    
    if (_shouldPullData) {
    
    [self.view showActivityViewWithLabel:@"Loading..."];
    [WebDataInterface getCountry:1 completion:^(NSObject *obj, NSError *err) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (err != nil) {
                
            }
            else {
                NSDictionary *dict = (NSDictionary *)obj;
                _countryInfo = [[NSMutableArray alloc] init];
                for (NSDictionary *data in dict[@"countries"]) {
                    CountryInfo *info = [CountryInfo createCountryInfoFromDictionary:data];
                    [_countryInfo addObject:info];
                }
                
                if (_jobInfo != nil) {
                    [self edit];
                }
                else
                {
                    [self addNewJob];
                }
                
                [self.view hideActivityView];
                
                _shouldPullData = NO;
                
                return;
                
            }
            
            //            [self.navigationController popViewControllerAnimated:YES];
            
        });
    }];

    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 111 || textField.tag == 333) {
        if ([textField.text length] < 2) {
            return YES;
        }
        
    }else if (textField.tag == 222 || textField.tag == 444){
        if ([textField.text length] < 4) {
            return YES;
        }
    }
    
    
    return NO;
}


- (void)edit{
    _isEdit = YES;
    
    _companyNameTextField.text = _jobInfo.companyName;
    _jobTitleTextField.text = _jobInfo.jobTitle;
//    _infoWebView.userInteractionEnabled = YES;
    
    [_infoWebView loadHTMLString:_jobInfo.otherInfo baseURL:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onEditAdditionInfo1:)];
    tap.delegate =self;
    [_infoWebView addGestureRecognizer:tap];
    
    _countryIndex = [_countryInfo indexOfObject:[self countryInfoByISO:_jobInfo.countryISO]];
    _countryTextField.text = _jobInfo.countryName;
    
    
}

- (void)addNewJob
{
    _isEdit = NO;
    
    _countryIndex = -1;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onEditAdditionInfo1:)];
    tap.delegate = self;
    [_infoWebView addGestureRecognizer:tap];

    
    
    
}

- (void)countryTapped:(UIGestureRecognizer *)recognizer
{
//    [self dismissAllInputField];
    [_countryTextField resignFirstResponder];
    
    NSLog(@"text field pressed");
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select Country" rows:[self allCountriesName] initialSelection:_countryIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        _countryIndex = selectedIndex;
        
//        [_countryBtn setTitle:selectedValue forState:UIControlStateNormal];
        [_countryTextField setText:selectedValue];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:recognizer];

}

#pragma mark - picker view delegae

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _countryInfo.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *arr = [self allCountriesName];
    return arr[row];
//    return 
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _countryTextField.text = [self allCountriesName][row];
}

- (NSArray *)allCountriesName{
    
    if(_countryInfo != nil){
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        for(CountryInfo *info in _countryInfo){
            
            [arr addObject:info.countryName];
        }
        
        return arr;
    }
    
    return nil;
}

- (void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [_jobScrollView endEditing:YES];
}

- (void)onEditAdditionInfo1:(UIGestureRecognizer *)recognizer{
    NSLog(@"on edit add info 111111111111111111111111");
    
    OtherInfoViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"OtherInfoViewController"];
    controller.htmlText = [_infoWebView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didFinishEditingWithHtmlText:(NSString *)htmlText{
    NSLog(@"did finish editing with ----");
    [_infoWebView loadHTMLString:htmlText baseURL:nil];
}

#pragma mark - override
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CountryInfo *)countryInfoByISO:(NSString *)countryISO{
    
    if(_countryInfo != nil){
        
        for(CountryInfo *info in _countryInfo){
            
            if([info.countryISO isEqualToString:countryISO]){
                
                return info;
            }
        }
    }
    
    return nil;
}


- (IBAction)checkBoxPressed:(id)sender
{
    _checkBox.selected = !_checkBox.selected;
    
    if (_checkBox.state == !_checkBox.selected)
    {
        _toMMTextField.hidden = NO;
        _toYYTextField.hidden = NO;
    }
    else {
        _toMMTextField.hidden = YES;
        _toYYTextField.hidden = YES;
    }

}
@end
