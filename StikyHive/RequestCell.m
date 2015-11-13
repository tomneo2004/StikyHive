//
//  RequestCell.m
//  StikyHive
//
//  Created by User on 13/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "RequestCell.h"
#import "WebDataInterface.h"
#import "ViewControllerUtil.h"
#import  "ObjectCache.h"

@interface RequestCell ()

@end

@implementation RequestCell{
    
    BOOL _isInit;
    UIView *_profilePhotoView;
}

@synthesize imageContainer = _imageContainer;
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
- (void)displayProfilePictureWithURL:(NSString *)url withUniqueId:(NSString *)uniqueId{
    
    NSString *fullURL = [WebDataInterface getFullUrlPath:url];
    
    _profilePhotoView = [[ObjectCache sharedObjectCache] getObjectForKey:uniqueId];
    
    if(_profilePhotoView != nil){
        
        _profilePhotoView.center = _imageContainer.center;
        [self.contentView addSubview:_profilePhotoView];
    }
    else{
        
        _profilePhotoView = [ViewControllerUtil getViewWithImageURLNormal:fullURL xOffset:0 yOffset:0 width:_imageContainer.bounds.size.width heigth:_imageContainer.bounds.size.height defaultPhoto:@"Default_profile_small@2x"];
        _profilePhotoView.layer.cornerRadius = _profilePhotoView.bounds.size.width/2;
        _profilePhotoView.layer.masksToBounds = YES;
        _profilePhotoView.layer.borderColor = [UIColor whiteColor].CGColor;
        _profilePhotoView.layer.borderWidth = 1;
        _profilePhotoView.center = _imageContainer.center;
        
        [[ObjectCache sharedObjectCache] setObject:_profilePhotoView forKey:uniqueId];
        
        [self.contentView addSubview:_profilePhotoView];
    }
   
    
    _imageContainer.hidden = YES;
}

#pragma mark - IBAction
- (IBAction)didTapImageAttachment:(id)sender{
    
    if([_delegate respondsToSelector:@selector(requestCellDidTapImageAttachment:)]){
        
        [_delegate requestCellDidTapImageAttachment:self];
    }
}

- (IBAction)didTapVoiceCommunication:(id)sender{
    
    if([_delegate respondsToSelector:@selector(requestCellDidTapVoiceCommunication:)]){
        
        [_delegate requestCellDidTapVoiceCommunication:self];
    }
}

- (IBAction)didTapChat:(id)sender{
    
    if([_delegate respondsToSelector:@selector(requestCellDidTapChat:)]){
        [_delegate requestCellDidTapChat:self];
    }
}

#pragma mark - internal
- (void)didTapPersonAvatar:(UITapGestureRecognizer *)recognizer{
    
    if([_delegate respondsToSelector:@selector(requestCellDidTapPersonAvatar:)]){
        
        [_delegate requestCellDidTapPersonAvatar:self];
    }
}

#pragma mark - override
- (void)prepareForReuse{
    
    _delegate = nil;
    [_profilePhotoView removeFromSuperview];
    _profilePhotoView = nil;
}

@end
