//
//  SellingViewController4.m
//  StikyHive
//
//  Created by THV1WP15S on 30/11/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "SellingViewController4.h"

@interface SellingViewController4 ()

@end

@implementation SellingViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _contentScrollView.alwaysBounceVertical = YES;
    _contentScrollView.delegate = self;
    
    [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width, 800)];
    
    _switchBtn1.userInteractionEnabled = NO;
    [_switchBtn2 setOn:NO animated:YES];
    [_switchBtn3 setOn:NO animated:YES];
    [_switchBtn4 setOn:NO animated:YES];
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

- (IBAction)switchBtn2Pressed:(id)sender
{
    if ([_switchBtn2 isOn])
    {
        NSLog(@"toggle on");
        
        UIAlertView *btn2AlertOn = [[UIAlertView alloc] initWithTitle:@"Add 4 Photos" message:@"Do you want to add 4 Photos now?" delegate:self cancelButtonTitle:@"Add Latter" otherButtonTitles:@"Yes,Now", nil];
        
    }
    else
    {
        NSLog(@"toggle off");
    }
    
    
}

- (IBAction)switchBtn3Pressed:(id)sender {
}

- (IBAction)switchBtn4Pressed:(id)sender {
}
@end
