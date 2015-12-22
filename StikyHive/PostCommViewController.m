//
//  PostCommViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 9/10/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "PostCommViewController.h"
#import "LocalDataInterface.h"
#import "WebDataInterface.h"
#import "SkillPageViewController.h"
#import "ViewControllerUtil.h"
#import "UIView+RNActivityView.h"

@interface PostCommViewController ()

@property (nonatomic, strong) NSString *skillid;
@property (nonatomic, strong) UIButton *submBtn;
@property (nonatomic, strong) UITextView *commTextView;

@end

@implementation PostCommViewController

- (void)setSkillID:(NSString *)skillID
{
    _skillid = skillID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSString *stkid = [LocalDataInterface retrieveStkid];
    
    [self displayContent];
}


- (void)displayContent
{
    CGFloat x = 20;
    CGFloat y = 20;
    UIColor *greenbColor = [UIColor colorWithRed:18.0/255 green:148.0/255 blue:133.0/255 alpha:1.0];
    
    self.view.backgroundColor = [UIColor colorWithRed:242.0/255 green:235.0/255 blue:184.0/255 alpha:1.0];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 150, 50)];
    titleLabel.text = @"Post a comment";
    titleLabel.textColor = [UIColor blackColor];
    CGPoint center = titleLabel.center;
    center.x = self.view.center.x;
    titleLabel.center = center;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _commTextView = [[UITextView alloc] initWithFrame:CGRectMake(x, titleLabel.frame.origin.y+titleLabel.frame.size.height+20, self.view.frame.size.width - 40, 150)];
    CGPoint textViewCenter = _commTextView.center;
    textViewCenter.x = self.view.center.x;
    _commTextView.center = textViewCenter;
    
    
    _submBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, _commTextView.frame.origin.y+_commTextView.frame.size.height+20, _commTextView.frame.size.width, 50)];
    [_submBtn setTitle:@"Submit" forState:UIControlStateNormal];
    [_submBtn setBackgroundColor:greenbColor];
    [_submBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submBtn.layer.borderColor = greenbColor.CGColor;
    _submBtn.layer.borderWidth = 1.5;
    _submBtn.layer.cornerRadius = 5;
    _submBtn.layer.masksToBounds = YES;
    [_submBtn addTarget:self action:@selector(submitBtnTapped:) forControlEvents:UIControlEventTouchUpInside];

    
    [self.view addSubview:titleLabel];
    [self.view addSubview:_commTextView];
    [self.view addSubview:_submBtn];
    
}


- (void)submitBtnTapped:(UITapGestureRecognizer *)sender
{
    
    _submBtn.userInteractionEnabled = NO;
    _commTextView.userInteractionEnabled = NO;
    
    NSString *stkid = [LocalDataInterface retrieveStkid];
    NSString *review = _commTextView.text;
    
    [self.view showActivityViewWithLabel:@"Updating..."];
    
    
    [WebDataInterface postSellerComments:_skillid reviewer:stkid review:review type:1 rating:0 completion:^(NSObject *obj, NSError *err) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict = (NSDictionary *)obj;
            
            if (dict)
            {
                if ([dict[@"status"] isEqualToString:@"success"])
                {
                    UINavigationController *navigationController = self.navigationController;
                    [navigationController popViewControllerAnimated:YES];
                }
            }
            
            [self.view hideActivityView];
        });
        
    }];
    
    _submBtn.userInteractionEnabled = YES;
    _commTextView.userInteractionEnabled = YES;
}

// touch anywhere to dismiss keyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
