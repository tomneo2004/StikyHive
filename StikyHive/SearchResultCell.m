//
//  SearchResultCell.m
//  StikyHive
//
//  Created by User on 24/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "SearchResultCell.h"
#import "WebDataInterface.h"
#import "UIImageView+AFNetworking.h"

@implementation SearchResultCell{
    
    BOOL _isInit;
}

@synthesize avatarImageView = _avatarImageView;
@synthesize nameLabel = _nameLabel;
@synthesize descLabel = _descLabel;
@synthesize distanceLabel = _distanceLabel;
@synthesize delegate = _delegate;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - override
- (void)prepareForReuse{
    
    _delegate = nil;
    [_avatarImageView cancelImageRequestOperation];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if(!_isInit){
        
        _avatarImageView.layer.cornerRadius = _avatarImageView.bounds.size.width/2;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _avatarImageView.layer.borderWidth = 1;
        
        _isInit = YES;
    }
}

#pragma mark - public interface
- (void)displayProfilePictureWithURL:(NSString *)url{
    
    NSString *fullURL = [WebDataInterface getFullUrlPath:url];
    NSURL *requestURL = [NSURL URLWithString:fullURL];
    
    [_avatarImageView setImageWithURLRequest:[NSURLRequest requestWithURL:requestURL] placeholderImage:[UIImage imageNamed:@"Default_profile_small@2x"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
        
        _avatarImageView.image = image;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        
        
    }];
    
}

#pragma mark - IBAction
- (IBAction)didTapPhoneCall:(id)sender{
    
    if([_delegate respondsToSelector:@selector(SearchResultDidTapPhoneCall:)]){
        
        [_delegate SearchResultDidTapPhoneCall:self];
    }
}

- (IBAction)didTapChat:(id)sender{
    
    if([_delegate respondsToSelector:@selector(SearchResultDidTapChat:)]){
        
        [_delegate SearchResultDidTapChat:self];
    }
}

@end
