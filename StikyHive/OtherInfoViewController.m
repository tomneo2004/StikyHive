//
//  OtherInfoViewController.m
//  StikyHive
//
//  Created by User on 5/1/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "OtherInfoViewController.h"

@interface OtherInfoViewController ()

@end

@implementation OtherInfoViewController

@synthesize delegate = _delegate;
@synthesize htmlText = _htmlText;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Additional Information";
    
    if(_htmlText != nil){
        
        [self setHTML:_htmlText];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    if([_delegate respondsToSelector:@selector(didFinishEditingWithHtmlText:)]){
        
        [_delegate didFinishEditingWithHtmlText:[self getHTML]];
    }
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
