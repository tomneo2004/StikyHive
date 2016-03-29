//
//  SellAllCell.m
//  StikyHive
//
//  Created by THV1WP15S on 23/3/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "SellAllCell.h"
#import "WebDataInterface.h"
#import "UIImageView+AFNetworking.h"

@implementation SellAllCell
{
    BOOL _isInit;
}


@synthesize skillImageView = _skillImageView;
@synthesize profileImageView = _profileImageView;
@synthesize delegate = _delegate;



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - override
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!_isInit) {
        self.profileImageView.layer.cornerRadius = 45/2;
        self.profileImageView.layer.masksToBounds = YES;
        self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.profileImageView.layer.borderWidth = 2;
        self.profileImageView.userInteractionEnabled = YES;
        
        _isInit = YES;
        
        
    }
}

- (void)setIsVideo:(BOOL)isVideo
{
    _isVideo = isVideo;
    if (_isVideo) {
        
    }
    else
    {
        
    }
}

- (void)displayProfileImage:(NSString *)url
{
   
    NSString *fullUrl = [WebDataInterface getFullUrlPath:url];
    NSURL *urlRequest = [NSURL URLWithString:fullUrl];
    
    [_profileImageView setImageWithURLRequest:[NSURLRequest requestWithURL:urlRequest] placeholderImage:[UIImage imageNamed:@"Default_profile_small@2x"] success:^(NSURLRequest *request, NSHTTPURLResponse * response, UIImage *image)
    {
        _profileImageView.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"fail to download image");
    }];
    
}


- (void)displaySkillImage:(NSString *)url
{
    NSString *fullUrl = [WebDataInterface getFullUrlPath:url];
    NSURL *urlRequest = [NSURL URLWithString:fullUrl];
    
    [_skillImageView setImageWithURLRequest:[NSURLRequest requestWithURL:urlRequest] placeholderImage:[UIImage imageNamed:@"default_seller_post"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        _skillImageView.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"fail to download image");
    }];

    
    
}




@end
