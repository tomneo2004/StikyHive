//
//  ReadReviewViewController.m
//  StikyHive
//
//  Created by User on 9/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "ReadReviewViewController.h"
#import "HCSStarRatingView.h"

@interface ReadReviewViewController ()

@property (weak, nonatomic) IBOutlet UILabel *reviewForlabel;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end

@implementation ReadReviewViewController

@synthesize reviewForlabel = _reviewForlabel;
@synthesize ratingView = _ratingView;
@synthesize textView = _textView;
@synthesize closeBtn = _closeBtn;
@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setter
- (void)setReviewTitle:(NSString *)reviewTitle{
    
    _reviewForlabel.text = reviewTitle;
}

- (void)setRating:(NSInteger)rating{
    
    _ratingView.value = (CGFloat)rating;
}

- (void)setReview:(NSString *)review{
    
    _textView.text = review;
}

#pragma mark - IBAction
- (IBAction)editTap:(id)sender{
    
    if([_delegate respondsToSelector:@selector(onEditTap:)]){
        
        [_delegate onEditTap:self];
    }
}

- (IBAction)closeTap:(id)sender{
    
    [self dismissOverlay:^{
    
        if([_delegate respondsToSelector:@selector(onClose)]){
            
            [_delegate onClose];
        }
        
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
