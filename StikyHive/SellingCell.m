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
    if ([_delegate respondsToSelector:@selector(SellingCellDidTapImageView:)]) {
        [_delegate SellingCellDidTapImageView:self];
    }
    
}

- (void)displayDefaultImage:(NSString *)defaultImage
{
    _photoImageView.image = [UIImage imageNamed:defaultImage];
}


#pragma mark - override
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!_isInit) {
        
        for (UIGestureRecognizer *g in self.photoImageView.gestureRecognizers) {
            [self.photoImageView removeGestureRecognizer:g];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImageView:)];
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        [self.photoImageView addGestureRecognizer:tap];
        
        
        _isInit = YES;
        
    }
    
    
}

#pragma mark - override
- (void)prepareForReuse
{
    _delegate = nil;
    
}


@end
