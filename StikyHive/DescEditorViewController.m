//
//  DescEditorViewController.m
//  StikyHive
//
//  Created by User on 11/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "DescEditorViewController.h"

@interface DescEditorViewController ()

@end

@implementation DescEditorViewController

@synthesize delegate = _delegate;
@synthesize htmlText = _htmlText;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Description";
    
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
