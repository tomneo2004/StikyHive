//
//  SellingCell.m
//  StikyHive
//
//  Created by THV1WP15S on 9/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "SellingCell.h"

@implementation SellingCell{
    BOOL _isInit;
}

@synthesize photoImageView = _photoImageView;
@synthesize delegate = _delegate;

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - internal
- (void)didTapImageView:(UITapGestureRecognizer *)sender{
    if ([_delegate respondsToSelector:@selector(SellingCellDidTapImageView:withImageView:)]) {
        [_delegate SellingCellDidTapImageView:self withImageView:_photoImageView];
    }
    
    
}

//- (void)displayDefaultImage:(NSString *)defaultImage
//{
//    _photoImageView.image = [UIImage imageNamed:defaultImage];
//}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(SellingCellTextField:caption:)]) {
        
        NSString *captionText = textField.text;
        
        [_delegate SellingCellTextField:self caption:captionText];
        
    }
    
}


#pragma mark - override
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!_isInit)
    {
        
        for (UIGestureRecognizer *g in self.photoImageView.gestureRecognizers) {
            [self.photoImageView removeGestureRecognizer:g];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImageView:)];
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        [self.photoImageView addGestureRecognizer:tap];
        
        
        _isInit = YES;
    
        _captionTextField.delegate = self;
        
    }
    
}

#pragma mark - override
- (void)prepareForReuse
{
    _delegate = nil;
    
    _photoImageView.image = [UIImage imageNamed:@"sell_upload_photo"];
    
    _captionTextField.text = nil;
    
}


@end
