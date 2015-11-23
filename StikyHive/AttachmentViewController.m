//
//  AttachmentViewController.m
//  StikyHive
//
//  Created by User on 17/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "AttachmentViewController.h"
#import "WebDataInterface.h"
#import "UIImageView+AFNetworking.h"

@interface AttachmentViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *attachmentImageView;

@end

@implementation AttachmentViewController

@synthesize attachmentImageView = _attachmentImageView;
@synthesize attachmentPhotoURL = _attachmentPhotoURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if(_attachmentPhotoURL == nil || [_attachmentPhotoURL isEqual:[NSNull null]]){
        
        [_attachmentImageView setImage:[UIImage imageNamed:@"Default_buyer_post"]];
        return;
    }
    
    
    if(_attachmentPhotoURL.length > 0){
        
        NSURL *photoURL = [NSURL URLWithString:[WebDataInterface getFullUrlPath:_attachmentPhotoURL]];
        
        [_attachmentImageView setImageWithURLRequest:[NSURLRequest requestWithURL:photoURL] placeholderImage:[UIImage imageNamed:@"Default_buyer_post"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
        
            if(image){
                
                [_attachmentImageView setImage:image];
            }
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        
        }];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [_attachmentImageView cancelImageRequestOperation];
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
