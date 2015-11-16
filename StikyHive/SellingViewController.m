//
//  SellingViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 16/11/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "SellingViewController.h"

@interface SellingViewController ()

@property (nonatomic, strong) UITextField *industryTextField;

@end

@implementation SellingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _contentScrollView.alwaysBounceVertical = YES;
    _contentScrollView.delegate = self;
    
    
    [self displayPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)displayPage
{
    CGFloat x = 20;
    CGFloat y = 0;
    CGFloat space = 20;
    CGFloat width = self.view.frame.size.width;
    
    UIColor *textBgColor = [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0];
    
    UILabel *listLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y+20, 100, 10)];
    listLabel.text = @"List your skill";
    listLabel.font = [UIFont systemFontOfSize:14];
    [listLabel sizeToFit];
    
    y = listLabel.frame.origin.y+listLabel.frame.size.height+space;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 100, 10)];
    titleLabel.text = @"Skill Title";
    titleLabel.font = [UIFont systemFontOfSize:14];
    [titleLabel sizeToFit];
    
    y = y+titleLabel.frame.size.height +10;
    
    UITextField *titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, width-space*2, 30)];
    titleTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"eg.Accounting"];
    titleTextField.backgroundColor = textBgColor;
    
    y = y + titleTextField.frame.size.height+20;
    
    UIButton *professBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, (width-40)/2, 30)];
    [professBtn setTitle:@"Professional Skill" forState:UIControlStateNormal];
    professBtn.backgroundColor = textBgColor;
    [professBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIButton *talentBtn = [[UIButton alloc] initWithFrame:CGRectMake(x+professBtn.frame.size.width, y, professBtn.frame.size.width, professBtn.frame.size.height)];
    [talentBtn setTitle:@"Raw Talent" forState:UIControlStateNormal];
    talentBtn.backgroundColor = textBgColor;
    [talentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    y = y+talentBtn.frame.size.height+space;
    
    _industryTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, width-40, 30)];
    _industryTextField.backgroundColor = textBgColor;
    
    UIPickerView *industryPickerView = [[UIPickerView alloc] init];
    industryPickerView.delegate = self;
    industryPickerView.dataSource = self;
    industryPickerView.tag = 111;
    
    [_industryTextField setInputView:industryPickerView];
    
    y = y+_industryTextField.frame.size.height+space;
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 50, 15)];
    priceLabel.text = @"Price";
    
    y = y+priceLabel.frame.size.height +10;
    
    UILabel *dollarLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 10, 15)];
    dollarLabel.text = @"$";
    dollarLabel.font = [UIFont systemFontOfSize:12];
    [dollarLabel sizeToFit];
    
    UITextField *priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(x+dollarLabel.frame.size.width+2, y, 90, 30)];
    priceTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"eg. 168.80"];
    priceTextField.backgroundColor = textBgColor;
    priceTextField.font = [UIFont systemFontOfSize:14];
    
    
    
    
    
    
    [_contentScrollView addSubview:listLabel];
    [_contentScrollView addSubview:titleLabel];
    [_contentScrollView addSubview:titleTextField];
    [_contentScrollView addSubview:professBtn];
    [_contentScrollView addSubview:talentBtn];
    [_contentScrollView addSubview:_industryTextField];
    [_contentScrollView addSubview:priceLabel];
    [_contentScrollView addSubview:dollarLabel];
    [_contentScrollView addSubview:priceTextField];
    
    // set scroll view content size
    [_contentScrollView setContentSize:CGSizeMake(width, y)];
}



#pragma mark - picker view delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag == 111) {
        return 1;
    }
    else
    {
        return 1;
    }
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 111) {
        return 1;
    }
    else
    {
        return 1;
    }
    
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 111) {
        NSString *test = @"testing";
        return test;
    }
    else
    {
        NSString *test = @"testing";
        return test;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    
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
