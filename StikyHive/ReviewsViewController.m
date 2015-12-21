//
//  ReviewsViewController.m
//  StikyHive
//
//  Created by User on 18/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "ReviewsViewController.h"
#import "HCSStarRatingView.h"
#import "UIImageView+AFNetworking.h"
#import "WebDataInterface.h"

@interface ReviewsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *seeAllBtn;

@end

@implementation ReviewsViewController

@synthesize dateLabel = _dateLabel;
@synthesize ratingView = _ratingView;
@synthesize avatarImageView = _avatarImageView;
@synthesize reviewTextView = _reviewTextView;
@synthesize nameLabel = _nameLabel;
@synthesize seeAllBtn = _seeAllBtn;
@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //make person's profile picture circle
    _avatarImageView.layer.cornerRadius = _avatarImageView.bounds.size.width/2;
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatarImageView.layer.borderWidth = 1;
    _avatarImageView.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)seeAll:(id)sender{
    
    if([_delegate respondsToSelector:@selector(reviewSeeAllTap)]){
        
        [_delegate reviewSeeAllTap];
    }
}

#pragma mark - public interface
- (void)refreshViewWithReviewInfo:(ReviewInfo *)info{
    
    if(info == nil){
        
        _dateLabel.text = @"No review !";
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        
        _ratingView.hidden = YES;
        _avatarImageView.hidden = YES;
        _nameLabel.hidden = YES;
        _reviewTextView.hidden = YES;
        
        _seeAllBtn.hidden = YES;
        
    }
    else{
        
        _dateLabel.textAlignment = NSTextAlignmentRight;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd MMM yyyy"];
        
        _dateLabel.text = [formatter stringFromDate:info.createDate];
        
        
        _ratingView.hidden = NO;
        _avatarImageView.hidden = NO;
        _nameLabel.hidden = NO;
        _reviewTextView.hidden = NO;
        
        _seeAllBtn.hidden = NO;
        
        [_ratingView setValue:info.rating];
        
        NSURL *profilePicURL = [NSURL URLWithString:[WebDataInterface getFullStoragePath:info.profilePicture]];
        [_avatarImageView setImageWithURLRequest:[NSURLRequest requestWithURL:profilePicURL] placeholderImage:[UIImage imageNamed:@"Default_profile_small@2x"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
            
            //set image
            _avatarImageView.image = image;
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
            
            
        }];
    }
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
