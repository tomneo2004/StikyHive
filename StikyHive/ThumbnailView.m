//
//  AvatarView.m
//  StikyHive
//
//  Created by User on 28/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "ThumbnailView.h"
#import "UIImageView+AFNetworking.h"

@implementation ThumbnailView{
    
    UIImageView *_imageView;
    CGFloat _width;
    CGFloat _height;
    NSString *_defaultPhotoName;
}

#pragma mark - public interface
- (void)setImageViewTag:(NSInteger)tag{
    
    _imageView.tag = tag;
}

- (void)setTapTarget:(id)target andAction:(SEL)action{
    
    for(UIGestureRecognizer *g in [_imageView gestureRecognizers]){
        
        [_imageView removeGestureRecognizer:g];
    }
    
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target action:action]];
}

- (void)displayImageWithURL:(NSURL *)imageURL withWidth:(CGFloat)width withHeight:(CGFloat)height withDefaultPhotoName:(NSString *)defaultPhotoName{
    
    _width = width;
    _height = height;
    _defaultPhotoName = defaultPhotoName;
    
    __weak typeof (UIImageView) *weakUIImageView = _imageView;
    
    [_imageView setImageWithURLRequest:[NSURLRequest requestWithURL:imageURL] placeholderImage:[UIImage imageNamed:_defaultPhotoName] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        weakUIImageView.image = image;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        
        _imageView.image = [UIImage imageNamed:_defaultPhotoName];
    }];
}

/*
#pragma mark - internal
- (void)renderImageWithImage:(UIImage *)image WithWidth:(CGFloat)rw andHeight:(CGFloat)rh{
    
    CGRect rect = CGRectMake(0,0,rw,rh);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIGraphicsEndImageContext();
}
 */

#pragma mark - override
- (id)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        [self addSubview:_imageView];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
