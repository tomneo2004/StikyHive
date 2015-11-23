//
//  SellingViewController2.m
//  StikyHive
//
//  Created by THV1WP15S on 23/11/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "SellingViewController2.h"
#import "ViewControllerUtil.h"

@interface SellingViewController2 ()

@end

@implementation SellingViewController2

static NSMutableDictionary *Skill_Info;


- (IBAction)nextButton:(id)sender {
}

+ (UIViewController *)instantiateForInfo:(NSDictionary *)skillInfo
{
    Skill_Info = skillInfo.mutableCopy;
    return [ViewControllerUtil instantiateViewController:@"selling_view_controller_2"];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSLog(@"skill info ---- %@",Skill_Info);
    
    
    [_videoImageView setUserInteractionEnabled:YES];
    [_videoImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoImageViewTapped:)]];
    
    
    
    
    
    
}


- (void)videoImageViewTapped:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self showVideoPicker];
}


- (void)showVideoPicker
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        picker.videoMaximumDuration = MAX_VIDEO_DURATION_DEFAULT;
        //    picker.videoQuality = UIImagePickerControllerQualityTypeIFrame960x540;
        picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        
        [self presentViewController:picker animated:YES completion:NULL];
        NSString *msg = @"Please record in landscape mode to ensure your video is not distorted.";
        [ViewControllerUtil showAlertWithTitle:@"" andMessage:msg];
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
