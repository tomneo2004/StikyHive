//
//  OfferMediaItem.m
//  StikyHive
//
//  Created by User on 1/3/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "OfferMediaItem.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"

#import "UIImage+JSQMessages.h"

#define hSpace 10
#define vSpace 8
#define iconWidth 20
#define acceptBtnWidth 40
#define cancelBtnWidth 40
#define btnSpace 5


@interface OfferMediaItem ()

@property (nonatomic, strong) UIImageView *cacheImageView;
@property (nonatomic, strong) UIImageView *stikypayIconView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *acceptOfferBtn;
@property (nonatomic, strong) UIButton *cancelOfferBtn;

@end

@implementation OfferMediaItem

- (instancetype)initWithOfferId:(NSInteger)mOfferId withOfferStatus:(NSInteger)mOfferStatus withPrice:(double)mPrice withOfferName:(NSString *)mOfferName withOfferRate:(NSString *)mOfferRate{
    
    self = [super init];
    if(self){
        
        _offerId = mOfferId;
        _offerStatus = mOfferStatus;
        _price = mPrice;
        _offerName = mOfferName;
        _offerRate = mOfferRate;
        _fullString = [NSString stringWithFormat:@"$%.2f for %@ %@", mPrice, mOfferName, mOfferRate];
        _isOfferInteract = NO;
        
        
    }
    
    return self;
}

- (void)dealloc{
    
}

- (UIView *)mediaView{
    
    if(self.cacheImageView == nil){
        
        
        
        CGSize size = [self mediaViewDisplaySize];
        BOOL outgoing = self.appliesMediaViewMaskAsOutgoing;
        UIColor *colorBackground = [UIColor yellowColor];
        UIColor *colorContent = [UIColor whiteColor];
        
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.text = _fullString;
        _label.font = [UIFont systemFontOfSize:17];
        _label.numberOfLines = 0;
        
        CGSize labelSize = [self getSizeForString:_fullString withMaxWidth:size.width/3*2  withMaxHeight:size.height withFont:_label.font];
        _label.frame = CGRectMake(hSpace, vSpace, labelSize.width, labelSize.height);
        
        
        
        
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
        imageView.backgroundColor = colorBackground;
        imageView.clipsToBounds = YES;
        [imageView addSubview:_label];
        
        
        if(_offerStatus == 0){
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_offer_stikypay"]];
            icon.contentMode = UIViewContentModeScaleAspectFit;
            icon.frame = CGRectMake(_label.frame.origin.x+_label.frame.size.width/2, _label.frame.origin.y+_label.frame.size.height, _label.frame.size.width/2, iconWidth);
            [imageView addSubview:icon];
        }
        
        if(!_isOfferInteract){
            
            _cancelOfferBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _cancelOfferBtn.frame = CGRectMake(_label.frame.origin.x+_label.frame.size.width, size.height/2-cancelBtnWidth/2, cancelBtnWidth, cancelBtnWidth);
            [_cancelOfferBtn setImage:[[UIImage imageNamed:@"icon_offer_decline"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [_cancelOfferBtn addTarget:self action:@selector(onCancelOffer) forControlEvents:UIControlEventTouchUpInside];
            _cancelOfferBtn.userInteractionEnabled = YES;

            
            _acceptOfferBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _acceptOfferBtn.frame = CGRectMake(_cancelOfferBtn.frame.origin.x+cancelBtnWidth+btnSpace, size.height/2-acceptBtnWidth/2, acceptBtnWidth, acceptBtnWidth);
            [_acceptOfferBtn setImage:[[UIImage imageNamed:@"icon_offer_accept"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            [_acceptOfferBtn addTarget:self action:@selector(onAcceptOffer) forControlEvents:UIControlEventTouchUpInside];
            _acceptOfferBtn.userInteractionEnabled = YES;

            
            [imageView addSubview:_cancelOfferBtn];
            [imageView addSubview:_acceptOfferBtn];
        }
        
        [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:imageView isOutgoing:outgoing];
        self.cacheImageView = imageView;
    }
    
    self.cacheImageView.userInteractionEnabled = YES;
    return self.cacheImageView;
}

- (void)updateView{
    
    if(_isOfferInteract == YES){
        
        [_cancelOfferBtn removeFromSuperview];
        [_acceptOfferBtn removeFromSuperview];
        
        if(self.cacheImageView != nil){
            
            CGRect oFrame = self.cacheImageView.frame;
            
            oFrame.size.width = [[UIScreen mainScreen] bounds].size.width/3*2;
            
            self.cacheImageView.frame = oFrame;
        }
    }
}

- (void)onAcceptOffer{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:acceptOfferNotification object:self];
    
    _isOfferInteract = YES;
    
    [self updateView];
}

- (void)onCancelOffer{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:cancelOfferNotification object:self];
    
    _isOfferInteract = YES;
    
    [self updateView];
}

- (CGSize)getSizeForString:(NSString *)string withMaxWidth:(CGFloat)mWidth withMaxHeight:(CGFloat)mHeight withFont:(UIFont *)font{
    
    CGSize maximumLabelSize = CGSizeMake(mWidth, mHeight);
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    NSDictionary *attr = @{NSFontAttributeName: font};
    CGRect labelBounds = [_fullString boundingRectWithSize:maximumLabelSize options:options attributes:attr context:nil];
    
    return CGSizeMake(ceilf(labelBounds.size.width), ceilf(labelBounds.size.height));
}

- (CGSize)mediaViewDisplaySize{
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        return CGSizeMake(220.0f, 40.0f);
    }
    
    //return CGSizeMake([[UIScreen mainScreen] bounds].size.width/3*2, 300.0f);
    if(_offerStatus == 0){
        
        return CGSizeMake([[UIScreen mainScreen] bounds].size.width/3*2 + acceptBtnWidth + cancelBtnWidth+btnSpace, vSpace*2 +[self getSizeForString:_fullString withMaxWidth:([[UIScreen mainScreen] bounds].size.width/3*2)/3*2 withMaxHeight:9999 withFont:[UIFont systemFontOfSize:17]].height+iconWidth);
    }
    else{
        
        return CGSizeMake([[UIScreen mainScreen] bounds].size.width/3*2 + acceptBtnWidth + cancelBtnWidth+btnSpace, vSpace*2 +[self getSizeForString:_fullString withMaxWidth:([[UIScreen mainScreen] bounds].size.width/3*2)/3*2 withMaxHeight:9999 withFont:[UIFont systemFontOfSize:17]].height);
    }
    
}

- (NSUInteger)mediaHash{
    
    return self.hash;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object{
    
    if (![super isEqual:object])
    {
        return NO;
    }
    
    OfferMediaItem *item = object;
    
    return (_offerId == item.offerId);
}

- (NSUInteger)hash{
    
    return super.hash ^ _offerId;
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"<%@: offerId=%li, appliesMediaViewMaskAsOutgoing=%@>",
            [self class], (long)self.offerId, @(self.appliesMediaViewMaskAsOutgoing)];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _offerId = [[aDecoder decodeObjectForKey:NSStringFromSelector(@selector(offerId))] integerValue];
        _offerStatus = [[aDecoder decodeObjectForKey:NSStringFromSelector(@selector(offerStatus))] integerValue];
        _price = [[aDecoder decodeObjectForKey:NSStringFromSelector(@selector(price))] doubleValue];
        _offerName = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(offerName))];
        _offerRate = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(offerRate))];
        _isOfferInteract = [[aDecoder decodeObjectForKey:NSStringFromSelector(@selector(isOfferInteract))] boolValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.offerId] forKey:NSStringFromSelector(@selector(offerId))];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.offerStatus] forKey:NSStringFromSelector(@selector(offerStatus))];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.price] forKey:NSStringFromSelector(@selector(price))];
    [aCoder encodeObject:self.offerName forKey:NSStringFromSelector(@selector(offerName))];
    [aCoder encodeObject:self.offerRate forKey:NSStringFromSelector(@selector(offerRate))];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isOfferInteract] forKey:NSStringFromSelector(@selector(isOfferInteract))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    
    OfferMediaItem *copy = [[[self class] allocWithZone:zone] initWithOfferId:self.offerId withOfferStatus:self.offerStatus withPrice:self.price withOfferName:self.offerName withOfferRate:self.offerRate];
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    return copy;
}

@end
