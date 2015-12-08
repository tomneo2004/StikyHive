//
//  BoughtCell.m
//  StikyHive
//
//  Created by User on 8/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "BoughtCell.h"
#import "HCSStarRatingView.h"
#import "WebDataInterface.h"
#import "UIImageView+AFNetworking.h"

@interface BoughtCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;

@end

@implementation BoughtCell

@synthesize boughtFromLabel = _boughtFromLabel;
@synthesize onLabel = _onLabel;
@synthesize photoImageView = _photoImageView;
@synthesize titleLabel = _titleLabel;
@synthesize priceLabel = _priceLabel;
@synthesize rating = _rating;
@synthesize delegate = _delegate;
@synthesize ratingView = _ratingView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - public interface
- (void)displayPhotoWithURL:(NSString *)url{
    
    //get full url
    NSString *fullURL = [WebDataInterface getFullUrlPath:url];
    
    //url request
    NSURL *requestURL = [NSURL URLWithString:fullURL];
    
    //start download image
    [_photoImageView setImageWithURLRequest:[NSURLRequest requestWithURL:requestURL] placeholderImage:[UIImage imageNamed:@"Default_profile_small@2x"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
        
        //set image
        _photoImageView.image = image;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        
        
    }];
}

#pragma mark - setter
- (void)setRating:(NSInteger)rating{
    
    _ratingView.value = (CGFloat)rating;
}

#pragma mark - IBAction
- (IBAction)readReview:(id)sender{
    
    if([_delegate respondsToSelector:@selector(onReadReviewTap:)]){
        
        [_delegate onReadReviewTap:self];
    }
}

- (IBAction)editReview:(id)sender{
    
    if([_delegate respondsToSelector:@selector(onEditReviewTap:)]){
        
        [_delegate onEditReviewTap:self];
    }
}

#pragma mark - override
- (void)prepareForReuse{
    
    _delegate = nil;
    
    //tell download image to cancel
    [_photoImageView cancelImageRequestOperation];
}

@end
