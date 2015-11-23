//
//  RequestCell.m
//  StikyHive
//
//  Created by User on 16/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "RequestCell.h"
#import "WebDataInterface.h"
#import "UIImageView+AFNetworking.h"

@implementation RequestCell

@synthesize avatarImageView = _avatarImageView;
@synthesize titleLabel = _titleLabel;
@synthesize descLabel = _descLabel;
@synthesize delegate = _delegate;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

#pragma mark - override
- (void)prepareForReuse{
    
    _delegate = nil;
    [_avatarImageView cancelImageRequestOperation];
}

@end
