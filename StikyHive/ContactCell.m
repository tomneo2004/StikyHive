//
//  ContactCell.m
//  StikyHive
//
//  Created by User on 4/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "ContactCell.h"
#import "WebDataInterface.h"
#import "UIImageView+AFNetworking.h"

@implementation ContactCell{
    
    //determine if it is initialized
    BOOL _isInit;
}

@synthesize avatarImageView = _avatarImageView;
@synthesize nameLabel = _nameLabel;
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
    
    //get full url
    NSString *fullURL = [WebDataInterface getFullUrlPath:url];
    
    //url request
    NSURL *requestURL = [NSURL URLWithString:fullURL];
    
    //start download image
    [_avatarImageView setImageWithURLRequest:[NSURLRequest requestWithURL:requestURL] placeholderImage:[UIImage imageNamed:@"Default_profile_small@2x"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
        
        //set image
        _avatarImageView.image = image;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        
        
    }];
    
}

#pragma mark - IBAction
- (IBAction)phoneTap:(id)sender{
    
    if([_delegate respondsToSelector:@selector(onPhoneCallTap:)]){
        
        [_delegate onPhoneCallTap:self];
    }
}

- (IBAction)chatTap:(id)sender{
    
    if([_delegate respondsToSelector:@selector(onChatTap:)]){
        
        [_delegate onChatTap:self];
    }
}

#pragma mark - override
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if(!_isInit){
        
        //make person's profile picture circle
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.bounds.size.width/2;
        self.avatarImageView.layer.masksToBounds = YES;
        self.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.avatarImageView.layer.borderWidth = 1;
        self.avatarImageView.userInteractionEnabled = YES;
        
        _isInit = YES;
    }
}

- (void)prepareForReuse{
    
    _delegate = nil;
    
    //tell download image to cancel
    [_avatarImageView cancelImageRequestOperation];
}

@end
