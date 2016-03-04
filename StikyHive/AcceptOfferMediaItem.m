//
//  AcceptOfferMediaItem.m
//  StikyHive
//
//  Created by User on 4/3/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "AcceptOfferMediaItem.h"

#import "JSQMessagesMediaPlaceholderView.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"

#import "UIImage+JSQMessages.h"

@interface AcceptOfferMediaItem ()

@property (nonatomic, strong) UIImageView *cacheImageView;
@property (nonatomic, copy) NSString *htmlString;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation AcceptOfferMediaItem

- (instancetype)initWithHtmlString:(NSString *)htmlString{
    
    self = [super init];
    if(self){
        
        _htmlString = [htmlString stringByReplacingOccurrencesOfString:@"/adaptivePay" withString:@"http://beta.stikyhive.com/adaptivepay"];
    }
    
    return self;
}

- (void)dealloc{
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked){
        
        NSURL *url = request.URL;
        [[UIApplication sharedApplication] openURL:url];
        
        return NO;
        
    }
    
    return YES;
}

- (UIView *)mediaView{
    
    if(self.cacheImageView == nil){
        
        
        CGSize size = [self mediaViewDisplaySize];
        BOOL outgoing = self.appliesMediaViewMaskAsOutgoing;
        UIColor *colorBackground = [UIColor yellowColor];
        //UIColor *colorContent = [UIColor whiteColor];
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [_webView loadHTMLString:_htmlString baseURL:nil];
        _webView.delegate = self;
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
        imageView.backgroundColor = colorBackground;
        imageView.clipsToBounds = YES;
        [imageView addSubview:_webView];
         
        
        [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:imageView isOutgoing:outgoing];
        self.cacheImageView = imageView;
    }
    
    self.cacheImageView.userInteractionEnabled = YES;
    return self.cacheImageView;
}

- (CGSize)mediaViewDisplaySize{
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        return CGSizeMake(220.0f, 100.0f);
    }
    
    return CGSizeMake(220.0f, 100.0f);
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
    
    AcceptOfferMediaItem *item = (AcceptOfferMediaItem *)object;
    
    return [self.htmlString isEqual:item.htmlString];
}

- (NSUInteger)hash{
    
    return super.hash ^ self.htmlString.hash;
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"<%@: htmlString=%@, appliesMediaViewMaskAsOutgoing=%@>",
            [self class], self.htmlString, @(self.appliesMediaViewMaskAsOutgoing)];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _htmlString = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(htmlString))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.htmlString forKey:NSStringFromSelector(@selector(htmlString))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    AcceptOfferMediaItem *copy = [[[self class] allocWithZone:zone] initWithHtmlString:self.htmlString];
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    return copy;
}

@end
