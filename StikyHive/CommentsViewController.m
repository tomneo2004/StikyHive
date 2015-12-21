//
//  CommentsViewController.m
//  StikyHive
//
//  Created by User on 18/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "CommentsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "WebDataInterface.h"

@interface CommentsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;
@property (weak, nonatomic) IBOutlet UIButton *seeAllBtn;
@property (weak, nonatomic) IBOutlet UIButton *postCommentBtn;


@end

@implementation CommentsViewController

@synthesize dateLabel = _dateLabel;
@synthesize avatarImageView = _avatarImageView;
@synthesize nameLabel = _nameLabel;
@synthesize reviewTextView = _reviewTextView;
@synthesize seeAllBtn = _seeAllBtn;
@synthesize postCommentBtn = _postCommentBtn;
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

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [_avatarImageView cancelImageRequestOperation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)seeAll:(id)sender{
    
    if([_delegate respondsToSelector:@selector(commentSeeAllTap)]){
        
        [_delegate commentSeeAllTap];
    }
}

- (IBAction)postComment:(id)sender{
    
    if([_delegate respondsToSelector:@selector(commentPostCommentTap)]){
        
        [_delegate commentPostCommentTap];
    }
}

#pragma mark - public interface
- (void)refreshViewWithCommentInfo:(CommentInfo *)info{
    
    if(info == nil){
        
        _dateLabel.text = @"No comment !";
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        
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
        
        _avatarImageView.hidden = NO;
        _nameLabel.hidden = NO;
        _reviewTextView.hidden = NO;
        
        _seeAllBtn.hidden = NO;
        
        NSURL *profilePicURL = [NSURL URLWithString:[WebDataInterface getFullStoragePath:info.profilePicture]];
        [_avatarImageView setImageWithURLRequest:[NSURLRequest requestWithURL:profilePicURL] placeholderImage:[UIImage imageNamed:@"Default_profile_small@2x"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
            
            //set image
            _avatarImageView.image = image;
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
            
            
        }];
        
        _nameLabel.text = [NSString stringWithFormat:@"%@ %@", info.firstname, info.lastname];
        _reviewTextView.text = info.review;
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
