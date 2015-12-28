//
//  ReviewCell.m
//  StikyHive
//
//  Created by User on 21/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "ReviewCell.h"
#import "HCSStarRatingView.h"
#import "WebDataInterface.h"
#import "UIImageView+AFNetworking.h"

@interface ReviewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;

@end

@implementation ReviewCell

@synthesize dateLabel = _dateLabel;
@synthesize nameLabel = _nameLabel;
@synthesize textView = _textView;
@synthesize avatarImageView = _avatarImageView;
@synthesize ratingView = _ratingView;
@synthesize rating = _rating;

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    //make person's profile picture circle
    _avatarImageView.layer.cornerRadius = _avatarImageView.bounds.size.width/2;
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatarImageView.layer.borderWidth = 1;
    _avatarImageView.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRating:(NSInteger)rating{
    
    [_ratingView setValue:rating];
}

- (void)displayProfileImageWithURL:(NSString *)profileImageURL{
    
    //get full url
    NSString *fullURL = [WebDataInterface getFullUrlPath:profileImageURL];
    
    //url request
    NSURL *requestURL = [NSURL URLWithString:fullURL];
    
    //start download image
    [_avatarImageView setImageWithURLRequest:[NSURLRequest requestWithURL:requestURL] placeholderImage:[UIImage imageNamed:@"Default_profile_small@2x"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
        
        //set image
        _avatarImageView.image = image;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        
        
    }];
}

- (void)prepareForReuse{
    
    //tell download image to cancel
    [_avatarImageView cancelImageRequestOperation];
}

@end
