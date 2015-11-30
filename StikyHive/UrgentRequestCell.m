//
//  RequestCell.m
//  StikyHive
//
//  Created by User on 13/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "UrgentRequestCell.h"
#import "WebDataInterface.h"
#import "ViewControllerUtil.h"
#import "UIImageView+AFNetworking.h"

@interface UrgentRequestCell ()

@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;

@end

@implementation UrgentRequestCell{
    
    //determine if it is initialized
    BOOL _isInit;

}

@synthesize phoneButton = _phoneButton;
@synthesize chatButton = _chatButton;


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - IBAction
- (IBAction)didTapImageAttachment:(id)sender{
    
    if([self.delegate respondsToSelector:@selector(urgentRequestCellDidTapImageAttachment:)]){
        
        [self.delegate urgentRequestCellDidTapImageAttachment:self];
    }
}

- (IBAction)didTapVoiceCommunication:(id)sender{
    
    if([self.delegate respondsToSelector:@selector(urgentRequestCellDidTapVoiceCommunication:)]){
        
        [self.delegate urgentRequestCellDidTapVoiceCommunication:self];
    }
}

- (IBAction)didTapChat:(id)sender{
    
    if([self.delegate respondsToSelector:@selector(urgentRequestCellDidTapChat:)]){
        [self.delegate urgentRequestCellDidTapChat:self];
    }
}

#pragma mark - internal
- (void)didTapPersonAvatar:(UITapGestureRecognizer *)recognizer{
    
    if([self.delegate respondsToSelector:@selector(urgentRequestCellDidTapPersonAvatar:)]){
        
        [self.delegate urgentRequestCellDidTapPersonAvatar:self];
    }
}

#pragma mark - setter
- (void)setIsMyRequest:(BOOL)isMyRequest{
    
    _phoneButton.hidden = isMyRequest;
    _chatButton.hidden = isMyRequest;
}

#pragma mark - override
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if(!_isInit){
        
        //remove all gesture from person's profile picture
        for(UIGestureRecognizer *g in self.avatarImageView.gestureRecognizers){
            
            [self.avatarImageView removeGestureRecognizer:g];
        }
        
        //add gesture to person's profile picture
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapPersonAvatar:)];
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        [self.avatarImageView addGestureRecognizer:tap];
     
        //make person's profile picture circle
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.bounds.size.width/2;
        self.avatarImageView.layer.masksToBounds = YES;
        self.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.avatarImageView.layer.borderWidth = 1;
        self.avatarImageView.userInteractionEnabled = YES;
        
        _isInit = YES;
    }
}


@end
