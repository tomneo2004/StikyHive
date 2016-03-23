//
//  SearchCell.m
//  StikyHive
//
//  Created by User on 23/3/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "SearchCell.h"
#import "WebDataInterface.h"

@interface SearchCell ()

@property (weak, nonatomic) IBOutlet UIImageView *videoPlayerImageView;

@end


@implementation SearchCell{
    
    //determine if it is initialized
    BOOL _isInit;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayThumbnailImageWithUrl:(NSString *)url{
    
    //url request
    NSURL *requestURL = [NSURL URLWithString:[WebDataInterface getFullUrlPath:url]];
    
    //start download image
    [_thumbnailImageView setImageWithURLRequest:[NSURLRequest requestWithURL:requestURL] placeholderImage:[UIImage imageNamed:@"Default_buyer_post"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
        
        //set image
        _thumbnailImageView.image = image;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        
        
    }];
}

- (void)displayProfilePictureWithURL:(NSString *)url{
    
    //url request
    NSURL *requestURL = [NSURL URLWithString:[WebDataInterface getFullUrlPath:url]];
    
    //start download image
    [_avatarImageView setImageWithURLRequest:[NSURLRequest requestWithURL:requestURL] placeholderImage:[UIImage imageNamed:@"Default_profile_small@2x"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
        
        //set image
        _avatarImageView.image = image;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        
        
    }];
}

- (void)didTapPersonAvatar:(UITapGestureRecognizer *)recognizer{
    
    if([_delegate respondsToSelector:@selector(searchCellDidTapPersonAvatar:)]){
        
        [_delegate searchCellDidTapPersonAvatar:self];
    }
}

- (void)didTapThumbImage:(UITapGestureRecognizer *)recognizer{
    
    if([_delegate respondsToSelector:@selector(searchCellDidTapThumbnailImage:)]){
        
        [_delegate searchCellDidTapThumbnailImage:self];
    }
}

#pragma mark - override
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if(!_isInit){
        
        //remove all gesture from person's profile picture
        for(UIGestureRecognizer *g in _avatarImageView.gestureRecognizers){
            
            [_avatarImageView removeGestureRecognizer:g];
        }
        
        //add gesture to person's profile picture
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapPersonAvatar:)];
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        [_avatarImageView addGestureRecognizer:tap];
        
        //make person's profile picture circle
        _avatarImageView.layer.cornerRadius = self.avatarImageView.bounds.size.width/2;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _avatarImageView.layer.borderWidth = 1;
        _avatarImageView.userInteractionEnabled = YES;
        
        for(UIGestureRecognizer *k in _thumbnailImageView.gestureRecognizers){
            
            [_thumbnailImageView removeGestureRecognizer:k];
        }
        
        UITapGestureRecognizer *ttap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapThumbImage:)];
        [ttap setNumberOfTapsRequired:1];
        [ttap setNumberOfTouchesRequired:1];
        [_thumbnailImageView addGestureRecognizer:ttap];
        
        _isInit = YES;
    }
}

#pragma mark - override
- (void)prepareForReuse{
    
    _delegate = nil;
    
    //tell download image to cancel
    [_avatarImageView cancelImageRequestOperation];
    [_thumbnailImageView cancelImageRequestOperation];
}

- (void)setIsVideo:(BOOL)isVideo{
    
    _isVideo = isVideo;
    
    if(_isVideo){
        
        [_videoPlayerImageView setHidden:NO];
    }
    else{
        
        [_videoPlayerImageView setHidden:YES];
    }
}

@end
