//
//  SellingViewController4.m
//  StikyHive
//
//  Created by THV1WP15S on 30/11/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "SellingViewController4.h"
#import "ViewControllerUtil.h"
#import "SellingManager.h"

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
    
    
    [_switchBtn4 setOn:NO animated:YES];
    
    BOOL status = [SellingManager sharedSellingManager].photoStatus;
    BOOL videoStatus = [SellingManager sharedSellingManager].videoStatus;
    if (status) {
        [_switchBtn2 setOn:YES animated:YES];
    }
    else
    {
       [_switchBtn2 setOn:NO animated:YES]; 
    }
    if (videoStatus) {
        [_switchBtn3 setOn:YES animated:YES];
    }
    else
    {
       [_switchBtn3 setOn:NO animated:YES];
    }

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 201)
    {
        if (buttonIndex == 0)
        {
            NSLog(@"add latter");
            
            
        }
        else
        {
            NSLog(@"add now");
            
            UIViewController *vc = [ViewControllerUtil instantiateViewController:@"selling_view_controller_33"];
            
            
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
    }
    else if (alertView.tag == 202)
    {
        if (buttonIndex == 0)
        {
            NSLog(@"cancel");
            [_switchBtn2 setOn:YES animated:YES];
        }
        else
        {
            NSLog(@"yes");
            
            [SellingManager sharedSellingManager].photoStatus = NO;
        }
    }
    else if (alertView.tag == 301)
    {
        if (buttonIndex == 0)
        {
            NSLog(@"add latter");
            
            
        }
        else
        {
            NSLog(@"add now");
            UIViewController *vc = [ViewControllerUtil instantiateViewController:@"selling_view_controller_2"];
//            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
            [self.navigationController pushViewController:vc animated:YES];

        }
    }
    else if (alertView.tag == 302)
    {
        if (buttonIndex == 0)
        {
            NSLog(@"cancel");
            [_switchBtn3 setOn:YES animated:YES];
        }
        else
        {
            NSLog(@"yes");
            [SellingManager sharedSellingManager].videoStatus = NO;
        }
    }


}


- (IBAction)switchBtn2Pressed:(id)sender
{
    if ([_switchBtn2 isOn])
    {
        NSLog(@"toggle on");
        
        UIAlertView *btn2AlertOn = [[UIAlertView alloc] initWithTitle:@"Add 4 Photos" message:@"Do you want to add 4 Photos now?" delegate:self cancelButtonTitle:@"Add Latter" otherButtonTitles:@"Yes,Now", nil];
        
        btn2AlertOn.tag = 201;
        [btn2AlertOn show];
        
        
        [SellingManager sharedSellingManager].photoStatus = YES;
    }
    else
    {
        NSLog(@"toggle off");
        
        UIAlertView *btn2AlertOff = [[UIAlertView alloc] initWithTitle:@"Remove 4 Photos" message:@"Do you want to Remove 4 Photos now?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        
        btn2AlertOff.tag = 202;
        [btn2AlertOff show];
        
    }
    
    
}

- (IBAction)switchBtn3Pressed:(id)sender
{
    if ([_switchBtn3 isOn])
    {
        NSLog(@"toggle on");
        
        UIAlertView *btn3AlertOn = [[UIAlertView alloc] initWithTitle:@"Add a Video" message:@"Do you want to add a Video now?" delegate:self cancelButtonTitle:@"Add Latter" otherButtonTitles:@"Yes,Now", nil];
        
        btn3AlertOn.tag = 301;
        [btn3AlertOn show];
        
        [SellingManager sharedSellingManager].videoStatus = YES;

    }
    else
    {
        NSLog(@"toggle off");
        
        UIAlertView *btn3AlertOff = [[UIAlertView alloc] initWithTitle:@"Remove a Video" message:@"Do you want to Remove a Video now?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        
        btn3AlertOff.tag = 302;
        [btn3AlertOff show];

    }
}

- (IBAction)switchBtn4Pressed:(id)sender
{
//    if ([_switchBtn4 isOn])
//    {
//        NSLog(@"toggle on");
//        
//        UIAlertView *btn4AlertOn = [[UIAlertView alloc] initWithTitle:@"Add a Video" message:@"Do you want to add a Video now?" delegate:self cancelButtonTitle:@"Add Latter" otherButtonTitles:@"Yes,Now", nil];
//        
//        btn4AlertOn.tag = 301;
//        [btn4AlertOn show];
//
//    }
    
    
}
@end
