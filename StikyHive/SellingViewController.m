//
//  SellingViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 16/11/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "SellingViewController.h"
#import "HtmlEditor.h"
#import "WebDataInterface.h"
#import "ViewControllerUtil.h"
#import "SellingViewController2.h"

@interface SellingViewController ()

@property (nonatomic, strong) UITextField *industryTextField;
@property (nonatomic, strong) UIButton *professBtn;
@property (nonatomic, strong) UIButton *talentBtn;
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UITextField *priceTextField;
@property (nonatomic, strong) UITextField *rateTextField;
@property (nonatomic, strong) NSArray *skillArray;
@property (nonatomic, strong) NSArray *rateArray;
@property (nonatomic, strong) NSMutableArray *industryArray;
@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (nonatomic, strong) UIPickerView *industryPickerView;
//@property (nonatomic, strong) NSArray *rateArray;
@property (nonatomic, strong) UIWebView *summaryWebView;
@property (nonatomic, strong) HtmlEditor *summaryEditor;
@property (nonatomic, assign) BOOL summaryEditorLoaded;
@property (nonatomic, strong) UIWebView *descWebView;
@property (nonatomic, strong) HtmlEditor *descEditor;
@property (nonatomic, assign) BOOL descEditorLoaded;
@property (nonatomic, assign) NSString *categoryId;
@property (nonatomic, assign) NSString *rateId;



@end

@implementation SellingViewController

//static NSMutableDictionary *Skill_Info;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _contentScrollView.alwaysBounceVertical = YES;
    _contentScrollView.delegate = self;
    
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
//    tapGestureRecognizer.delegate = self;
    [self.contentScrollView addGestureRecognizer:tapGestureRecognizer];
    
    
    _industryArray = [[NSMutableArray alloc] init];
    _categoryArray = [[NSMutableArray alloc] init];
    
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
                

                [self displayPage];
            
            });
        
        }];
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self setTitle:@"Start Selling"];
    
    if (_summaryEditorLoaded) {
        [_summaryWebView loadHTMLString:[_summaryEditor getHTML] baseURL:nil];
        _summaryEditorLoaded = NO;
    }
    else if (_descEditorLoaded)
    {
        [_descWebView loadHTMLString:[_descEditor getHTML] baseURL:nil];
        _descEditorLoaded = NO;
    }
    
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
    listLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:18];
    [listLabel sizeToFit];
    
    y = listLabel.frame.origin.y+listLabel.frame.size.height+space;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 100, 10)];
    titleLabel.text = @"Skill Title";
    titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16];
    [titleLabel sizeToFit];
    
    y = y+titleLabel.frame.size.height +10;
    
    _titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, width-space*2, 40)];
    _titleTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"eg.Accounting"];
    _titleTextField.backgroundColor = textBgColor;
    _titleTextField.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0);  //text inset for uitextfield
    _titleTextField.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
    
    
    y = y + _titleTextField.frame.size.height+20;
    
    _professBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, (width-40)/2 - 2, 30)];
    [_professBtn setTitle:@"Professional Skill" forState:UIControlStateNormal];
    _professBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//    _professBtn.backgroundColor = textBgColor;
    _professBtn.layer.borderWidth = 1;
    _professBtn.layer.borderColor = [UIColor blackColor].CGColor;
    _professBtn.layer.cornerRadius = 5;
    _professBtn.layer.masksToBounds = YES;
    
    [_professBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_professBtn addTarget:self action:@selector(professBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    _talentBtn = [[UIButton alloc] initWithFrame:CGRectMake(x+_professBtn.frame.size.width+4, y, _professBtn.frame.size.width, _professBtn.frame.size.height)];
    [_talentBtn setTitle:@"Raw Talent" forState:UIControlStateNormal];
//    _talentBtn.backgroundColor = textBgColor;
    [_talentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _talentBtn.layer.borderWidth = 1;
    _talentBtn.layer.borderColor = [UIColor blackColor].CGColor;
    _talentBtn.layer.cornerRadius = 5;
    _talentBtn.layer.masksToBounds = YES;
    _talentBtn.titleLabel.font = [UIFont systemFontOfSize:14];

    [_talentBtn addTarget:self action:@selector(talentBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    y = y+_talentBtn.frame.size.height+space/2;
    
    _industryTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, width-40, 40)];
    _industryTextField.backgroundColor = textBgColor;
    _industryTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Select Industry"];
//    _industryTextField.textAlignment = NSTextAlignmentFromCTTextAlignment(100);
    _industryTextField.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0);
    
    _industryPickerView = [[UIPickerView alloc] init];
    _industryPickerView.delegate = self;
    _industryPickerView.dataSource = self;
    _industryPickerView.tag = 111;
    
    [_industryTextField setInputView:_industryPickerView];
    
    y = y+_industryTextField.frame.size.height+space;
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 50, 16)];
    priceLabel.text = @"Price";
    priceLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16];
    
    y = y+priceLabel.frame.size.height +10;
    
    UILabel *dollarLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y+10, 10, 15)];
    dollarLabel.text = @"$";
    dollarLabel.font = [UIFont systemFontOfSize:14];
    [dollarLabel sizeToFit];
    
    _priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(x+dollarLabel.frame.size.width+2, y, 90, 40)];
    _priceTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"eg. 168.80"];
    _priceTextField.backgroundColor = textBgColor;
    _priceTextField.font = [UIFont systemFontOfSize:16];
    _priceTextField.textAlignment = NSTextAlignmentCenter;
    _priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    
    UILabel *smLabel = [[UILabel alloc] initWithFrame:CGRectMake(_priceTextField.frame.origin.x+_priceTextField.frame.size.width+5, y+10, 10, 15)];
    smLabel.text = @"/";
    smLabel.font = [UIFont systemFontOfSize:14];
    [smLabel sizeToFit];
    
    _rateTextField = [[UITextField alloc] initWithFrame:CGRectMake(smLabel.frame.origin.x+smLabel.frame.size.width+5, y, 90, 40)];
    _rateTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Select rate"];
    _rateTextField.backgroundColor = textBgColor;
    _rateTextField.font = [UIFont systemFontOfSize:16];
    _rateTextField.textAlignment = NSTextAlignmentCenter;
    
    UIPickerView *ratePickerView = [[UIPickerView alloc] init];
    ratePickerView.delegate = self;
    ratePickerView.dataSource = self;
    ratePickerView.tag = 222;
    
    [_rateTextField setInputView:ratePickerView];

    
    
    y = y+_rateTextField.frame.size.height+space;
    
    
    UILabel *summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 100, 20)];
    summaryLabel.text = @"Summary";
    summaryLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16];
    
    y = y + summaryLabel.frame.size.height + space/2;
    
    _summaryWebView = [[UIWebView alloc] initWithFrame:CGRectMake(x, y, width-40, 100)];
    _summaryWebView.backgroundColor = textBgColor;
    [_summaryWebView setOpaque:NO];
    _summaryWebView.delegate = self;
    _summaryWebView.tag = 777;
    
    UITapGestureRecognizer *tapCatcher = [[UITapGestureRecognizer alloc] init];
    [tapCatcher setNumberOfTapsRequired:1];
    [tapCatcher setDelegate:self];

    [_summaryWebView addGestureRecognizer:tapCatcher];
    
    y = y + _summaryWebView.frame.size.height+ space;
    
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 100, 20)];
    descLabel.text = @"Description";
    descLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16];
    
    y = y + descLabel.frame.size.height + space/2;
    
    _descWebView = [[UIWebView alloc] initWithFrame:CGRectMake(x, y, width-40, 100)];
    _descWebView.backgroundColor = textBgColor;
    [_descWebView setOpaque:NO];
    _descWebView.delegate = self;
    _descWebView.tag = 888;
    
    
    UITapGestureRecognizer *tapCatcher2 = [[UITapGestureRecognizer alloc] init];
    [tapCatcher2 setNumberOfTapsRequired:1];
    [tapCatcher2 setDelegate:self];
    
    [_descWebView addGestureRecognizer:tapCatcher2];

    
    y = y + _descWebView.frame.size.height+space;
    
    
    UIColor *greenColor = [UIColor colorWithRed:19.0/255 green:152.0/255 blue:139.0/255 alpha:1.0];
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width-40, 50)];
    [nextBtn setTitle:@"Next" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = 5;
    nextBtn.layer.masksToBounds = YES;
    nextBtn.backgroundColor = greenColor;
    [nextBtn addTarget:self action:@selector(nextBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    y = y + nextBtn.frame.size.height + space;
    
    
    
    [_contentScrollView addSubview:listLabel];
    [_contentScrollView addSubview:titleLabel];
    [_contentScrollView addSubview:_titleTextField];
    [_contentScrollView addSubview:_professBtn];
    [_contentScrollView addSubview:_talentBtn];
    [_contentScrollView addSubview:_industryTextField];
    [_contentScrollView addSubview:priceLabel];
    [_contentScrollView addSubview:dollarLabel];
    [_contentScrollView addSubview:_priceTextField];
    [_contentScrollView addSubview:smLabel];
    [_contentScrollView addSubview:_rateTextField];
    [_contentScrollView addSubview:summaryLabel];
    [_contentScrollView addSubview:_summaryWebView];
    [_contentScrollView addSubview:descLabel];
    [_contentScrollView addSubview:_descWebView];
    [_contentScrollView addSubview:nextBtn];
    
    // set scroll view content size
    [_contentScrollView setContentSize:CGSizeMake(width, y)];
}

- (void)nextBtnTapped:(UITapGestureRecognizer *)sender
{
    NSString *titleString = _titleTextField.text;
    NSString *priceString = _priceTextField.text;
    NSString *rateString = _rateTextField.text;
    
    NSLog(@"category - %@",_categoryId);
    NSLog(@"rate - %@",_rateId);
    NSString *industryString = _industryTextField.text;
    
    NSString *summaryString = [_summaryWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    NSString *descString = [_descWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    NSString *innerSummary = [_summaryWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].innerHTML"];
    NSString *innerDesc = [_descWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].innerHTML"];
    
    
//    NSLog(@"inner summary --- %@",innerSummary);
//    NSLog(@"inner desc -- %@",innerDesc);
//    
//    NSLog(@"summary string -- %@",summaryString);
//    NSLog(@"desc string -- %@",descString);
    
    if (titleString.length == 0) {
        [ViewControllerUtil showAlertWithTitle:@"Incomplete Information" andMessage:@"Skill Title not fill in."];
    }
    else if (industryString.length == 0)
    {
        [ViewControllerUtil showAlertWithTitle:@"Incomplete Information" andMessage:@"Plese select skill."];
    }
    else if (innerSummary.length == 0)
    {
        [ViewControllerUtil showAlertWithTitle:@"Incomplete Information" andMessage:@"Skill Summary not fill in."];
    }
    else if (innerDesc.length == 0)
    {
        [ViewControllerUtil showAlertWithTitle:@"Incomplete Information" andMessage:@"Skill Description not fill in."];
    }
    else if (priceString.length > 0 && rateString.length == 0)
    {
        [ViewControllerUtil showAlertWithTitle:@"Incomplete Information" andMessage:@"Please select rate."];
    }
    else
    {
//        if (priceString.length > 0 && rateString == 0) {
//            
//        }
        
        NSMutableDictionary *skillinfo = [[NSMutableDictionary alloc] init];
        
        
        if (priceString.length == 0)
        {
            skillinfo[@"price"] = [NSNull null];
            skillinfo[@"rate"] = [NSNull null];
        }
        else
        {
            skillinfo[@"price"] = priceString;
            skillinfo[@"rate"] = _rateId;
        }
        
//        Skill_Info[@"name"] = titleString;
//        Skill_Info[@"categoryid"] = _categoryId;
//        Skill_Info[@"summary"] = summaryString;
//        Skill_Info[@"description"] = descString;
        
        skillinfo[@"name"] = titleString;
        skillinfo[@"categoryid"] = _categoryId;
        skillinfo[@"summary"] = summaryString;
        skillinfo[@"description"] = descString;
        
        NSString *name = skillinfo[@"name"];
        NSLog(@"name1 -- %@",name);
        NSLog(@"name2 -- %@",titleString);
        NSLog(@"categorid -- %@",skillinfo[@"categoryid"]);
        NSLog(@"summary -- %@",skillinfo[@"summary"]);
        NSLog(@"description -- %@",skillinfo[@"description"]);
        
        NSLog(@"price -- %@",skillinfo[@"price"]);
        NSLog(@"rate -- %@",skillinfo[@"rate"]);
        
        
        UIViewController *vc = [SellingViewController2 instantiateForInfo:skillinfo];
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
    }
    
    
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    if ([otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && !_summaryEditorLoaded && gestureRecognizer.view.tag == 777)
    {
        _summaryEditorLoaded = YES;
        _summaryEditor = [[HtmlEditor alloc] init];
        [_summaryEditor setHTML:[_summaryWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"]];
        [self.navigationController pushViewController:_summaryEditor animated:YES];

    }
    else if ([otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && !_descEditorLoaded && gestureRecognizer.view.tag == 888)
    {
        _descEditorLoaded = YES;
        _descEditor = [[HtmlEditor alloc] init];
        [_descEditor setHTML:[_descWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"]];
        [self.navigationController pushViewController:_descEditor animated:YES];
    }
    
    return YES;
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


-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    
//    [_titleTextField resignFirstResponder];
//    [_industryTextField resignFirstResponder];
//    [_priceTextField resignFirstResponder];
//    [_rateTextField resignFirstResponder];
    
    [_contentScrollView endEditing:YES];
    
}

- (void)talentBtnTapped:(UITapGestureRecognizer *)sender
{
    _skillArray = [_categoryArray mutableCopy];
    [_industryPickerView reloadAllComponents]; //reload picker view data
    
    _talentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _professBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
}

- (void)professBtnTapped:(UITapGestureRecognizer *)sender
{
    _skillArray = [_industryArray mutableCopy];
    [_industryPickerView reloadAllComponents];
    
    _professBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _talentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
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
