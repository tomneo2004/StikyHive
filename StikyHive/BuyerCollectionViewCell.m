//
//  BuyerCollectionViewCell.m
//  StikyHive
//
//  Created by User on 15/4/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "BuyerCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface BuyerCollectionViewCell()


@end

@implementation BuyerCollectionViewCell

- (void)displayImageWithURL:(NSString *)url{
    
    [_imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] placeholderImage:[UIImage imageNamed:@"Default_buyer_post"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        _imageView.image = image;
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
    }];
}

- (void)prepareForReuse{
    
    [_imageView cancelImageRequestOperation];
}

@end
