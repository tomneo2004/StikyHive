//
//  PostReviewViewController.m
//  StikyHive
//
//  Created by User on 9/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "PostReviewViewController.h"
#import "HCSStarRatingView.h"
#import "WebDataInterface.h"
#import "LocalDataInterface.h"
#import "UIView+RNActivityView.h"

@interface PostReviewViewController ()

@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation PostReviewViewController


@synthesize delegate = _delegate;
@synthesize ratingView = _ratingView;
@synthesize textView = _textView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - internal
- (void)onTap:(UIGestureRecognizer *)recognizer{
    
    [_textView resignFirstResponder];
}

#pragma mark - setter
- (void)setRating:(NSInteger)rating{
    
    _ratingView.value = (CGFloat)rating;
}

- (void)setReview:(NSString *)review{
    
    _textView.text = review;
}

#pragma mark - IBAction
- (IBAction)close:(id)sender{
    
    [self dismissOverlay:^{
        
        if([_delegate respondsToSelector:@selector(onPostReviewClose)]){
            
            [_delegate onPostReviewClose];
        }
        
    }];
}

- (IBAction)save:(id)sender{
    
    NSString *commentId = [_delegate commentIdForUpdateReview];
    
    if(commentId == nil || commentId.length <= 0){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to update review, comment id not vaild" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    [self.view showActivityViewWithLabel:@"Updating review..."];
    [WebDataInterface editComment:[commentId integerValue] rating:_ratingView.value review:_textView.text stkid:[LocalDataInterface retrieveStkid] completion:^(NSObject *obj, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error != nil){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to update review!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                return;
            }
            
            [self.view hideActivityView];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successful" message:@"Update review successful!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            if([_delegate respondsToSelector:@selector(onPostReviewUpdateSuccessful:)]){
                
                [_delegate onPostReviewUpdateSuccessful:self];
            }
            
            [self dismissOverlay:^{
            
                if([_delegate respondsToSelector:@selector(onPostReviewClose)]){
                    
                    [_delegate onPostReviewClose];
                }
            }];
            
        });
    }];
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
