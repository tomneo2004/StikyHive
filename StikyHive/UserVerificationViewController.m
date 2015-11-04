//
//  UserVerificationViewController.m
//  StikyHive
//
//  Created by Koh Quee Boon on 20/8/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "UserVerificationViewController.h"
#import "WebDataInterface.h"
#import "LocalDataInterface.h"
#import "ViewControllerUtil.h"

@interface UserVerificationViewController ()

@end

@implementation UserVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTextFields:@[_confirmCodeTextfield]];
    NSDictionary *animateDists = @{_confirmCodeTextfield:[NSNumber numberWithInteger:-20]};
    [self setAnimateDistances:animateDists];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dataReceived: (NSDictionary *)dict {
    
    if (dict && dict[@"status"]) {
        NSString *statusString = dict[@"status"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([statusString isEqualToString:@"success"]) {
                
                UIViewController *vc = [ViewControllerUtil instantiateViewController:@"user_info_editor_view_controller_1"];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else {
                [ViewControllerUtil showAlertWithTitle:@"Error" andMessage:@"Wrong hashcode"];
            }
        });
    }
}

- (IBAction)confirmButtonPressed:(id)sender {
    
    NSString *hashCode = _confirmCodeTextfield.text;
    NSString *email = [LocalDataInterface retrieveUsername];
    NSString *password = [LocalDataInterface retrievePassword];
    
   [WebDataInterface verifyUserEmail:email password:password hashcode:hashCode completion:^(NSObject *obj, NSError *err)
    {
        [self dataReceived:(NSDictionary *)obj];
    }];
    
    
}
@end
