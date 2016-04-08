//
//  SkillPageViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 23/9/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "SkillPageViewController.h"
#import "SkillVideoPlayer.h"
#import "WebDataInterface.h"
#import "ViewControllerUtil.h"
#import "SellerCommViewController.h"
#import "SellerCommTableViewController.h"
#import "PostCommViewController.h"
#import "SellerRevViewController.h"
#import "LocalDataInterface.h"
#import "UIView+RNActivityView.h"
#import <SendGrid/SendGrid.h>
#import <SendGrid/SendGridEmail.h>
#import "UIView+Toast.h"
#import <PDKPin.h>
#import <linkedin-sdk/LISDK.h>
#import "UIView+RNActivityView.h"



@interface SkillPageViewController ()

@property (nonatomic, strong) SkillVideoPlayer *skillVideoPlayer;
@property (nonatomic, strong) UIScrollView *imageScrollView;
@property (nonatomic, strong) UIImageView *scrollImageView;
@property (nonatomic, strong) NSString *Skill_ID;
@property (nonatomic, strong) NSDictionary *skillDict;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *photoScrollView;
@property (nonatomic, strong) UIWebView *skillDescWebView;
@property (nonatomic, strong) UIWebView *sellerDescWebView;
@property (assign, nonatomic) NSInteger numberOfWebViewLoaded;
@property (nonatomic, strong) NSDictionary *commDict;
@property (nonatomic, strong) NSArray *commentsArray;
@property (nonatomic, strong) NSArray *reviewArray;
@property (nonatomic, strong) UIView *commView;
@property (nonatomic, strong) UIButton *commBtn;
@property (nonatomic, strong) UIButton *reviewBtn;
@property (nonatomic, strong) UIView *sellerView;
@property (nonatomic, strong) UIButton *bookmarkBtn;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIWebView *sellerInfoWebView;
@property (nonatomic, strong) NSString *skillHtml;
@property (nonatomic, strong) NSString *sellerHtml;
@property (nonatomic, strong) NSString *sellerInfo;
@property (nonatomic, strong) UIButton *testBtn;

@property (nonatomic, strong) NSString *stkId;
@property (nonatomic, assign) NSInteger skillId;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) NSInteger skillType;
@property (nonatomic, assign) NSInteger catId;
@property (nonatomic, strong) NSString *skillName;
@property (nonatomic, strong) NSString *skillDesc;
@property (nonatomic, strong) NSString *profilePicUrl;
@property (nonatomic, strong) FBSDKShareLinkContent *content;
@property (nonatomic, assign) NSInteger viewCount;
@property (nonatomic, strong) UILabel *viewCountLabel;
@property (nonatomic, strong) UILabel *likeCountLabel;
@property (nonatomic, assign) NSInteger likeId;

@end

@implementation SkillPageViewController



- (void)setSkillID:(NSString *)skillID
{
    _Skill_ID = skillID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Skill Page"];
    
    UIBarButtonItem *chatButton = [ViewControllerUtil createBarButton:@"button_chat_header" onTarget:self
                                                         withSelector:@selector(generalChatPressed)];
    UIBarButtonItem *callButton = [ViewControllerUtil createBarButton:@"button_call_header" onTarget:self
                                                         withSelector:@selector(generalCallPressed)];
    chatButton.imageInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    callButton.imageInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    self.navigationItem.rightBarButtonItems = @[callButton, chatButton];
    
    CGFloat width = self.view.frame.size.width - 40;
    
    _skillVideoPlayer = [[SkillVideoPlayer alloc] init];
    _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, width, 290)];
    
    _contentScrollView.alwaysBounceVertical = YES;
    _contentScrollView.delegate = self;
    
    _skillDescWebView = [[UIWebView alloc] initWithFrame:CGRectMake(25, 350, width, 2)];
    _skillDescWebView.scrollView.contentInset = UIEdgeInsetsMake(0, -8, _skillDescWebView.frame.size.height, -8);
    _skillDescWebView.userInteractionEnabled = NO;
    _skillDescWebView.delegate = self;
    
    _sellerDescWebView = [[UIWebView alloc] initWithFrame:CGRectMake(25, 700, width, 2)];
    _sellerDescWebView.scrollView.contentInset = UIEdgeInsetsMake(0, -8, _sellerDescWebView.frame.size.height, -8);
    _sellerDescWebView.userInteractionEnabled = NO;
    _sellerDescWebView.delegate = self;
    
    _sellerInfoWebView = [[UIWebView alloc] initWithFrame:CGRectMake(30, 800, width, 2)];
    _sellerInfoWebView.scrollView.contentInset = UIEdgeInsetsMake(0, -8, _sellerInfoWebView.frame.size.height, -8);
    _sellerInfoWebView.userInteractionEnabled = NO;
    _sellerInfoWebView.delegate = self;
    _sellerInfoWebView.opaque = NO;
    _sellerInfoWebView.backgroundColor = [UIColor clearColor];

    
//    UIFont *font12 = [UIFont fontWithName:@"Open Sans" size:12];
    UIFont *font14 = [UIFont fontWithName:@"Open Sans" size:14];
    NSString *fontFormat = @"<span style=\"font-family: %@; font-size: %i\">%@</span>";
    
    
    
    NSString *stkid = [LocalDataInterface retrieveStkid];
    NSLog(@"stk id --- skill page ---- %@",stkid);
    NSLog(@"skill id --- skill page --- %@",_Skill_ID);
    
//    [self.view showActivityViewWithLabel:@"Loading..."];
    
    [WebDataInterface getSkillById:_Skill_ID stkid:stkid completion:^(NSObject *obj, NSError *err)
    {
        [WebDataInterface getCommReviewBySkillId:_Skill_ID completion:^(NSObject *obj2, NSError *err2)
         {
             _commDict = (NSDictionary *)obj2;
             _commentsArray = _commDict[@"comments"];
             _reviewArray = _commDict[@"reviews"];
             
        
             NSLog(@"skill by id --- %@",obj);
             NSLog(@"comm review ---- %@",obj2);
             
        
             _skillDict = (NSDictionary *)obj;
        
             if (_skillDict)
             {
                 NSLog(@"skill dict 777 ----- %@",_skillDict);
            
                 dispatch_async(dispatch_get_main_queue(), ^{
        
                     NSString *skillHtmlec = _skillDict[@"resultSkill"][@"summary"];
                     NSString *sellerHtmlec = _skillDict[@"resultSkill"][@"skillDesc"];
                     NSString *sellerInfoec = _skillDict[@"resultSkill"][@"beeInfo"];
                     
                     _stkId = _skillDict[@"resultSkill"][@"stkid"];
                     _skillId = [_skillDict[@"resultSkill"][@"id"] integerValue];
                     _likeCount = ([_skillDict[@"resultSkill"][@"likeCount"] isEqual:[NSNull null]])?0:[_skillDict[@"resultSkill"][@"likeCount"] integerValue];
                     _skillType = [_skillDict[@"resultSkill"][@"type"] integerValue];
                     _catId = [_skillDict[@"resultSkill"][@"catId"] integerValue];
                     _skillName = _skillDict[@"resultSkill"][@"name"];
                     _skillDesc = _skillDict[@"resultSkill"][@"skillDesc"];
                     _profilePicUrl = [WebDataInterface getFullUrlPath:_skillDict[@"resultSkill"][@"profilePicture"]];
                     
                     if(![_skillDict[@"resultSkill"][@"viewCount"] isEqual:[NSNull null]]){
                         
                         _viewCount = [_skillDict[@"resultSkill"][@"viewCount"] integerValue];
                     }
                     else{
                         
                         _viewCount = 0;
                     }
                     
                     _likeId = [_skillDict[@"resultSkill"][@"likeId"] integerValue];

                     _skillHtml = skillHtmlec !=(id)[NSNull null] ? [NSString stringWithFormat:fontFormat, font14.fontName,(int)font14.pointSize,skillHtmlec] : @"";
                     _sellerHtml = sellerHtmlec !=(id)[NSNull null] ? [NSString stringWithFormat:fontFormat, font14.fontName,(int)font14.pointSize,sellerHtmlec] : @"";
                     _sellerInfo = sellerInfoec !=(id)[NSNull null] ? [NSString stringWithFormat:fontFormat, font14.fontName,(int)font14.pointSize,sellerInfoec] : @"";
                
                
                     [_skillDescWebView loadHTMLString:_skillHtml baseURL:nil];
                     [_sellerDescWebView loadHTMLString:_sellerHtml baseURL:nil];
                     [_sellerInfoWebView loadHTMLString:_sellerInfo baseURL:nil];
                
                 });
             }
             
        }];
    }];
    
//    [WebDataInterface getCommReviewBySkillId:_Skill_ID completion:^(NSObject *obj2, NSError *err2)
//    {
//        _commDict = (NSDictionary *)obj2;
//        _commentsArray = _commDict[@"comments"];
//        _reviewArray = _commDict[@"reviews"];
//        
//    }];
    
//    [self.view hideActivityView];
}

- (void)webViewDidFinishLoad:(UIWebView *)awebView
{
    _numberOfWebViewLoaded++;

    CGRect frame = awebView.frame;
    NSUInteger contentHeight = [[awebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.scrollHeight;"]] intValue];
    awebView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, contentHeight);
    
    if (_numberOfWebViewLoaded == 3) {
        [self refreshDisplay:_skillDict];
        _numberOfWebViewLoaded = 0;
    }
}


- (void)refreshDisplay: (NSDictionary *)dict
{
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat vspace = 30;
    CGFloat aspect = 9.0/16;
    CGFloat  width = self.view.frame.size.width;
    
    NSArray *photoArray = _skillDict[@"resultPhoto"];
    
    y = [self displayPhotos:photoArray atStartPoint:CGPointMake(x, y) andWidth:width];
    
    y = [self displayNameBg:_skillDict[@"resultSkill"][@"name"] atStartPoint:CGPointMake(x, y) andWidth:width];
    
    NSArray *videoArray = _skillDict[@"resultVideo"];
    
    y = y + vspace;
    
    y =videoArray.count > 0 ? [self displayVideos:videoArray atStartPoint:CGPointMake(20, y) ofSize:CGSizeMake(width-40, width * aspect) withSpacing:vspace] : y;
    

    y = [self displayCommReviewBtn:_commentsArray reviewArray:_reviewArray atStartPoint:CGPointMake(x, y) andWidth:width];
    
    y = [self displayCommentsView:_commentsArray atStartPoint:CGPointMake(x, y) andWidth:width isComm:YES];
    
    
    y = [self displaySareButton:CGPointMake(x, y) andWidth:width];
    
    NSString *sellerName = [NSString stringWithFormat:@"%@ %@",_skillDict[@"resultSkill"][@"firstname"],_skillDict[@"resultSkill"][@"lastname"]];
    
    y = y + vspace;
    
    y = [self displaySeller:sellerName beeInfo:_skillDict[@"resultSkill"][@"beeInfo"] proLocation:_skillDict[@"resultSkill"][@"profilePicture"] atStartPoint:CGPointMake(x, y) andWidth:width];
    
    
    [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width, y)];
    
    
    
    
    //bottom button ---------- display bottom button
    UIColor *color1 = [UIColor colorWithRed:82.0/255 green:191.0/255 blue:180.0/255 alpha:0.9];
    UIColor *color2 = [UIColor colorWithRed:61.0/255 green:182.0/255 blue:169.0/255 alpha:0.9];
    UIColor *color3 = [UIColor colorWithRed:39.0/255 green:162.0/255 blue:150.0/255 alpha:0.9];
    
    
    //    CGFloat width = self.view.frame.size.width;
    UIButton *emailBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, width/3, 50)];
    emailBtn.backgroundColor = color1;
    [emailBtn setImage:[UIImage imageNamed:@"skillpg_email"] forState:UIControlStateNormal];
    [emailBtn setTitle:@"Email" forState:UIControlStateNormal];
    emailBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 26, 10, 70);
    [emailBtn addTarget:self action:@selector(emailBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *callBtn = [[UIButton alloc] initWithFrame:CGRectMake(width/3, emailBtn.frame.origin.y, emailBtn.frame.size.width, emailBtn.frame.size.height)];
    callBtn.backgroundColor = color2;
    [callBtn setImage:[UIImage imageNamed:@"skillpg-call"] forState:UIControlStateNormal];
    [callBtn setTitle:@"Call" forState:UIControlStateNormal];
    callBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 26, 10, 66);
    
    
    UIButton *chatBtn = [[UIButton alloc] initWithFrame:CGRectMake(emailBtn.frame.size.width*2, emailBtn.frame.origin.y, emailBtn.frame.size.width, emailBtn.frame.size.height)];
    chatBtn.backgroundColor = color3;
    [chatBtn setImage:[UIImage imageNamed:@"skillpg-chat"] forState:UIControlStateNormal];
    [chatBtn setTitle:@"Chat" forState:UIControlStateNormal];
    chatBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 27, 10, 68);
    
    
    [self.view addSubview:emailBtn];
    [self.view addSubview:callBtn];
    [self.view addSubview:chatBtn];
    
}


- (CGFloat)displayPhotos:(NSArray *)photoArray atStartPoint:(CGPoint)point andWidth:(CGFloat)width
{
    CGFloat y = point.y;
    
    _photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(point.x, point.y, width, 250)];
    _photoScrollView.pagingEnabled = YES;
    _photoScrollView.delegate = self;
    _photoScrollView.showsHorizontalScrollIndicator = NO;
    
    NSArray *phoArr = photoArray;
    
    NSLog(@"photo array ------- %@",phoArr);
    
    if (phoArr.count > 0) {

//        UIImageView *imview = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, point.y, width, 290)];
//        imview.image = [UIImage imageNamed:@"default_seller_post"];
//        
//        [_photoScrollView addSubview:imview];
        
        
        CGFloat x = point.x;
        for (int i = 0; i < phoArr.count; i ++)
        {
            UIImageView *imview = [[UIImageView alloc] initWithFrame:CGRectMake(x, point.y, width, 250)];
            NSString *location = phoArr[i][@"location"];
            NSString *url = [WebDataInterface getFullUrlPath:location];
            UIImage *image = [ViewControllerUtil getImageWithPath:url];
            imview.image = image;
            
            [_photoScrollView addSubview:imview];
            
            x = x + width;
            
        }
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.center.x/4 , point.y+210, 320, 36)];
        
        
        CGPoint center = _pageControl.center;
        center.x = _contentScrollView.center.x;
        _pageControl.center = center;
        
        _pageControl.numberOfPages = phoArr.count;
        [_pageControl addTarget:self action:@selector(pageControl:) forControlEvents:UIControlEventValueChanged];
        
        _photoScrollView.contentSize = CGSizeMake(phoArr.count*378, _photoScrollView.frame.size.height);
        
        
    }
    else
    {
        
        UIImageView *imview = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, point.y, width, 250)];
        imview.image = [UIImage imageNamed:@"default_seller_post"];
        
        [_photoScrollView addSubview:imview];
        
        
        
        
        
    }
    
    [_contentScrollView addSubview:_photoScrollView];
    [_contentScrollView addSubview:_pageControl];
    
    return  y + _photoScrollView.frame.size.height;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = _photoScrollView.contentOffset.x/_photoScrollView.frame.size.width;
    _pageControl.currentPage = page;
}

- (void)pageControl:(UIPageControl *)sender
{
    CGFloat x = _pageControl.currentPage * _photoScrollView.frame.size.width;
    [_photoScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
    
}

- (CGFloat)displayNameBg:(NSString *)name atStartPoint:(CGPoint)point andWidth:(CGFloat)width
{
    CGFloat y = point.y;
    
    UIImageView *imView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, width, 125)];
    imView.userInteractionEnabled = YES;
    
    imView.image = [UIImage imageNamed:@"skillpage-bg"];
    
    UIColor *greenbColor = [UIColor colorWithRed:18.0/255 green:148.0/255 blue:133.0/255 alpha:1.0];
    
    /*
    _bookmarkBtn = [[UIButton alloc] initWithFrame:CGRectMake(width-105, 18, 25, 30)];
    [_bookmarkBtn setImage:[UIImage imageNamed:@"bookmark"] forState:UIControlStateNormal];
    [_bookmarkBtn setImage:[UIImage imageNamed:@"bookmark_filled"] forState:UIControlStateSelected];
    [_bookmarkBtn addTarget:self action:@selector(bookmarkBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
     */
    _bookmarkBtn = [[UIButton alloc] initWithFrame:CGRectMake(width-105, 18, 25, 30)];
    [_bookmarkBtn setImage:[UIImage imageNamed:@"icon_eye_open"] forState:UIControlStateNormal];
    //[_bookmarkBtn setImage:[UIImage imageNamed:@"bookmark_filled"] forState:UIControlStateSelected];
    //[_bookmarkBtn addTarget:self action:@selector(bookmarkBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    /*
    UILabel *bmLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-120, 20+_bookmarkBtn.frame.size.height+10, 59, 10)];
    [bmLabel setText:@"Bookmark"];
    bmLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:11];
    [bmLabel setTextColor:greenbColor];
    CGPoint bmLabelCenter = bmLabel.center;
    bmLabelCenter.x = _bookmarkBtn.center.x;
    bmLabel.center = bmLabelCenter;
    bmLabel.textAlignment = NSTextAlignmentCenter;
     */
    
    _viewCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-120, 20+_bookmarkBtn.frame.size.height+10, 59, 10)];
    _viewCountLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:11];
    [_viewCountLabel setTextColor:greenbColor];
    CGPoint vcLabelCenter = _viewCountLabel.center;
    vcLabelCenter.x = _bookmarkBtn.center.x;
    _viewCountLabel.center = vcLabelCenter;
    _viewCountLabel.textAlignment = NSTextAlignmentCenter;
    
    [self updateViewCount];
    
    _likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(width-55, 20, 30, 30)];
    [_likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [_likeBtn setImage:[UIImage imageNamed:@"like_filled"] forState:UIControlStateSelected];
    [_likeBtn addTarget:self action:@selector(likeBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    /*
    UILabel *likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-53, 20+_bookmarkBtn.frame.size.height+10, 50, 10)];
    [likeLabel setText:@"Likes"];
    likeLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:11];;
    [likeLabel setTextColor:greenbColor];
    CGPoint likeLabelCenter = likeLabel.center;
    likeLabelCenter.x = _likeBtn.center.x;
    likeLabel.center = likeLabelCenter;
    likeLabel.textAlignment = NSTextAlignmentCenter;
     */
    
    _likeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-53, 20+_bookmarkBtn.frame.size.height+10, 50, 10)];
    [_likeCountLabel setText:@"Likes"];
    _likeCountLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:11];;
    [_likeCountLabel setTextColor:greenbColor];
    CGPoint likeLabelCenter = _likeCountLabel.center;
    likeLabelCenter.x = _likeBtn.center.x;
    _likeCountLabel.center = likeLabelCenter;
    _likeCountLabel.textAlignment = NSTextAlignmentCenter;
    
    [self updateLikeCount];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 80, 300, 30)];
    [nameLabel setText:name];
//    nameLabel.font = [UIFont systemFontOfSize:17];
    nameLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:19];
    
    [imView addSubview:_bookmarkBtn];
    //[imView addSubview:bmLabel];
    [imView addSubview:_viewCountLabel];
    [imView addSubview:_likeBtn];
    //[imView addSubview:likeLabel];
    [imView addSubview:_likeCountLabel];
    [imView addSubview:nameLabel];
    
    [_contentScrollView addSubview:imView];

    [self displayProfilePicture:_skillDict[@"resultSkill"][@"profilePicture"] atStartPoint:CGPointMake(point.x, y) andWidth:80.0];
    
    y = y + imView.frame.size.height;
    
    // display overview and description --------------
    if (_skillHtml.length > 0)
    {
    
    UILabel *overLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, y + 30, 150, 15)];
    [overLabel setText:@"Overview"];
    [overLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:17]];
    
    y = y + 50;
    
    [_contentScrollView addSubview:overLabel];
        
    }
    
    CGRect frame = _skillDescWebView.frame;
    frame.origin.y = y;
    _skillDescWebView.frame = frame;
    
    [_contentScrollView addSubview:_skillDescWebView];
        
    
    if (_sellerHtml.length > 0)
    {
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, _skillDescWebView.frame.origin.y + _skillDescWebView.frame.size.height +20, 150, 15)];
        [descLabel setText:@"Description"];
        [descLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:17]];
    
        [_contentScrollView addSubview:descLabel];
        
        
        y = y + _skillDescWebView.frame.size.height + 40;
    }
    else
    {
        y = y + _skillDescWebView.frame.size.height ;
    }
    
//    y = y + _skillDescWebView.frame.size.height + 40;
    
    CGRect sellerFrame = _sellerDescWebView.frame;
    sellerFrame.origin.y = y;
    _sellerDescWebView.frame = sellerFrame;
    
    y = y + _sellerDescWebView.frame.size.height;
    
    [_contentScrollView addSubview:_sellerDescWebView];
    
    return y;
}

- (void)updateViewCount{
    
    _viewCountLabel.text = [NSString stringWithFormat:@"%ld Views", _viewCount];
}

- (void)updateLikeCount{
    
    _likeCountLabel.text = [NSString stringWithFormat:@"%ld Likes", _likeCount];
}

- (void)displayProfilePicture:(NSString *)location atStartPoint:(CGPoint)point andWidth:(CGFloat)width
{
    CGFloat y = point.y;
    NSString *profileuRL = [WebDataInterface getFullUrlPath:location];
    
    UIView *profilePhotoView = [ViewControllerUtil getViewWithImageURLNormal:profileuRL xOffset:30 yOffset:y-20 width:width heigth:width defaultPhoto:@"Default_profile_small@2x"];
    profilePhotoView.layer.cornerRadius = width/2;
    profilePhotoView.layer.masksToBounds = YES;
    
    // set border
    profilePhotoView.layer.borderColor = [UIColor whiteColor].CGColor;
    profilePhotoView.layer.borderWidth = 3;
    
    [_contentScrollView addSubview:profilePhotoView];
}


- (CGFloat)displayVideos:(NSArray *)videoArray atStartPoint:(CGPoint)point ofSize:(CGSize)size withSpacing:(CGFloat)space
{
    CGFloat y = point.y;
    
    for (int i = 0; i < videoArray.count; i++)
    {
        NSString *imageLoc = videoArray[i][@"thumbnailLocation"];
        NSString *imageUrl = [WebDataInterface getFullUrlPath:imageLoc];
        NSLog(@"imaage location thumbnail url ----- %@",imageUrl);
        
        UIView *skillVideoView = [ViewControllerUtil getViewWithImageURL:imageUrl xOffset:point.x yOffset:y width:size.width heigth:size.height withTarget:self forSelector:@selector(skillVideoTapped:) andTag:i defaultPhoto:@"Default_skill_photo@2x"];
        
        [_contentScrollView addSubview:skillVideoView];
        UIImageView *playIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_play@2x"]];
        [playIconView setCenter:skillVideoView.center];
        [_contentScrollView addSubview:playIconView];
        y = y + skillVideoView.frame.size.height + space;
    }
    return y;
}


- (CGFloat)displayCommReviewBtn:(NSArray *)commArray reviewArray:(NSArray*)reviewArray atStartPoint:(CGPoint)point andWidth:(CGFloat)width
{
    CGFloat y = point.y;
    UIColor *greyColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0];
    
    _commBtn = [[UIButton alloc] initWithFrame:CGRectMake(point.x, point.y, self.view.frame.size.width/2, 50)];
    [_commBtn setTitle:[NSString stringWithFormat:@"Comments(%lu)",(unsigned long)commArray.count] forState:UIControlStateNormal];
    [_commBtn setBackgroundColor:greyColor];
    [_commBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _commBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Regular" size:16];
    [_commBtn addTarget:self action:@selector(commBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    _reviewBtn = [[UIButton alloc] initWithFrame:CGRectMake(_commBtn.frame.size.width, point.y, _commBtn.frame.size.width, 50)];
    [_reviewBtn setTitle:[NSString stringWithFormat:@"Reviews(%lu)",(unsigned long)reviewArray.count] forState:UIControlStateNormal];
    _reviewBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Regular" size:16];
    [_reviewBtn setBackgroundColor:[UIColor colorWithRed:231.0/255 green:231.0/255 blue:233.0/255 alpha:1.0]];
    [_reviewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_reviewBtn addTarget:self action:@selector(reviewBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [_contentScrollView addSubview:_commBtn];
    [_contentScrollView addSubview:_reviewBtn];
    
    y = y + _commBtn.frame.size.height;

    return y;
}

- (CGFloat)displayCommentsView:(NSArray *)commArray atStartPoint:(CGPoint)point andWidth:(CGFloat)width isComm:(BOOL)isComm
{
    CGFloat y = point.y;
    UIColor *greyColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0];
    UIColor *greenbColor = [UIColor colorWithRed:18.0/255 green:148.0/255 blue:133.0/255 alpha:1.0];
    
    // add comments view elements
    
    if (commArray.count > 0)
    {
        
        NSString *profileUrl = [WebDataInterface getFullUrlPath:commArray[0][@"profilePicture"]];
        
        UIView *profilePhotoView = [ViewControllerUtil getViewWithImageURLNormal:profileUrl xOffset:30 yOffset:30 width:60.0 heigth:60.0 defaultPhoto:@"Default_profile_small@2x"];
        profilePhotoView.layer.cornerRadius = 60.0/2;
        profilePhotoView.layer.masksToBounds = YES;

        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 30+profilePhotoView.frame.size.height+15, 110, 15)];
        nameLabel.text =[NSString stringWithFormat:@"%@ %@",commArray[0][@"firstName"],commArray[0][@"lastName"]];
        nameLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:15];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        CGPoint nameLabelCenter = nameLabel.center;
        nameLabelCenter.x = profilePhotoView.center.x;
        nameLabel.center = nameLabelCenter;
        
        
    
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - 120, 20, 100, 15)];
        // convert date format
        NSString *dateString = commArray[0][@"createDate"];
        NSDateFormatter *formate = [[NSDateFormatter alloc] init];
        [formate setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        NSDate *date = [formate dateFromString:dateString];
        [formate setDateFormat:@"dd MMM yyyy"];
        NSString *finalDate = [formate stringFromDate:date];
        
        dateLabel.textAlignment = NSTextAlignmentLeft;
        dateLabel.text = finalDate;
        dateLabel.textColor = [UIColor lightGrayColor];
        dateLabel.font = [UIFont fontWithName:@"OpenSans-Regular" size:6];
        
    
        
        
        
        UILabel *commText = [[UILabel alloc] initWithFrame:CGRectMake(140, dateLabel.frame.origin.y+dateLabel.frame.size.height +10, 210, 2)];
        commText.numberOfLines = 4;
        commText.text = commArray[0][@"review"];
        [commText sizeToFit];
        commText.font = [UIFont fontWithName:@"OpenSans-Regular" size:15];
        

   
        
        _commView = [[UIView alloc] initWithFrame:CGRectMake(point.x, y, width, 210)];
        [_commView setBackgroundColor:greyColor];

        
        if (isComm == YES)
        {
            UIButton *seeAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, nameLabel.frame.origin.y + 50, 140, 40)];
            [seeAllBtn setTitle:@"See all" forState:UIControlStateNormal];
            [seeAllBtn setTitleColor:greenbColor forState:UIControlStateNormal];
            seeAllBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16];
            seeAllBtn.layer.borderColor = greenbColor.CGColor;
            seeAllBtn.layer.borderWidth = 1.5;
            seeAllBtn.layer.cornerRadius = 5;
            seeAllBtn.layer.masksToBounds = YES;
            [seeAllBtn addTarget:self action:@selector(seeAllTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            
            UIButton *postCommBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, seeAllBtn.frame.origin.y, seeAllBtn.frame.size.width, seeAllBtn.frame.size.height)];
            [postCommBtn setTitle:@"Post Comment" forState:UIControlStateNormal];
            [postCommBtn setTitleColor:greenbColor forState:UIControlStateNormal];
            postCommBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:15];
            postCommBtn.layer.borderColor = greenbColor.CGColor;
            postCommBtn.layer.borderWidth = 1.5;
            postCommBtn.layer.cornerRadius = 5;
            postCommBtn.layer.masksToBounds = YES;
            
            [postCommBtn addTarget:self action:@selector(postCommTapped:) forControlEvents:UIControlEventTouchUpInside];

             [_commView addSubview:seeAllBtn];
             [_commView addSubview:postCommBtn];
        }
        else
        {
            
            UIButton *postCommBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, nameLabel.frame.origin.y + 50, 140, 40)];
            [postCommBtn setTitle:@"See All" forState:UIControlStateNormal];
            [postCommBtn setTitleColor:greenbColor forState:UIControlStateNormal];
            postCommBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16];
            postCommBtn.layer.borderColor = greenbColor.CGColor;
            postCommBtn.layer.borderWidth = 1.5;
            postCommBtn.layer.cornerRadius = 5;
            postCommBtn.layer.masksToBounds = YES;
            
            [postCommBtn addTarget:self action:@selector(reviewSeeAllTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            // set center -------
            CGPoint center = postCommBtn.center;
            center.x = _commView.center.x;
            postCommBtn.center = center;
            
            //yellow review icon
            CGFloat x = 150;
            
            for (int i = 0; i < 5; i++)
            {
                
                UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(x, 30, 15, 15)];
                iconImage.image = [UIImage imageNamed:@"review_filled"];
                
                x = x + iconImage.frame.size.width + 2;
                
                [_commView addSubview:iconImage];
            }
            
            [_commView addSubview:postCommBtn];
        }
    
    [_commView addSubview:profilePhotoView];
    [_commView addSubview:nameLabel];
    [_commView addSubview:commText];
    [_commView addSubview:dateLabel];
   
    [_contentScrollView addSubview:_commView];
    
    return y + _commView.frame.size.height;
        
    }
    else
    {
        UILabel *commLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, 200, 20)];
        commLabel.text = @"No comment yet.";
        
        _commView = [[UIView alloc] initWithFrame:CGRectMake(point.x, y, width, 150)];
        [_commView setBackgroundColor:greyColor];
        
        
        if (isComm) {
            UIButton *postBtn = [[UIButton alloc] initWithFrame:CGRectMake(120, 80, 140, 40)];
            [postBtn setTitle:@"Post Comment" forState:UIControlStateNormal];
            [postBtn setTitleColor:greenbColor forState:UIControlStateNormal];
            postBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16];
            postBtn.layer.borderColor = greenbColor.CGColor;
            postBtn.layer.borderWidth = 1.5;
            postBtn.layer.cornerRadius = 5;
            postBtn.layer.masksToBounds = YES;
            
            // set center
            CGPoint center = postBtn.center;
            center.x = _commView.center.x;
            postBtn.center = center;
            
            [postBtn addTarget:self action:@selector(postCommTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            [_commView addSubview:postBtn];
        }
        else
        {
            CGRect frame = _commView.frame;
            frame.size.height = _commView.frame.size.height -40;
            _commView.frame = frame;
        }
        
        [_commView addSubview:commLabel];
        
        [_contentScrollView addSubview:_commView];
        
        return y + _commView.frame.size.height;
        
    }
}


- (CGFloat)displaySareButton:(CGPoint)point andWidth:(CGFloat)width
{
    
    UIView * aView = [_contentScrollView viewWithTag:100];
    [aView removeFromSuperview];
    aView = [_contentScrollView viewWithTag:101];
    [aView removeFromSuperview];
    aView = [_contentScrollView viewWithTag:102];
    [aView removeFromSuperview];
    aView = [_contentScrollView viewWithTag:103];
    [aView removeFromSuperview];
    
    CGFloat y = point.y;
    
    //    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(20, y, width - 40, 1)];
    //    CGPoint center = lineView.center;
    //    center.x = self.view.center.x;
    //    lineView.center = center;
    //    [lineView setBackgroundColor:[UIColor lightGrayColor]];
//    [self displayLineView:CGPointMake(20, y) andWith:width];
    
    
    //    UIImageView *reportImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width-80, y+23, 60, 45)];
    //    reportImageView.image = [UIImage imageNamed:@"reportabuse.png"];
    
    UIButton *reportButton = [[UIButton alloc] initWithFrame:CGRectMake(width-80, y+23, 60, 45)];
    [reportButton setImage:[UIImage imageNamed:@"reportabuse"] forState:UIControlStateNormal];
    [reportButton addTarget:self action:@selector(reportBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    y = y + 25;
    
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 200, 15)];
    shareLabel.text = @"Share this Skill Page";
    
    y = y + 35;
    
//    UIButton *emailButton = [[UIButton alloc] initWithFrame:CGRectMake(20, y, 40, 40)];
//    //    emailButton.backgroundColor = [UIColor lightGrayColor];
//    [emailButton setImage:[UIImage imageNamed:@"share-email"] forState:UIControlStateNormal];
//    
    CGFloat x = 20;
//
//    UIButton *twitterButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 40, 40)];
//    [twitterButton setImage:[UIImage imageNamed:@"share-twitter"] forState:UIControlStateNormal];
//    x = x + 50;
    
    UIButton *fbButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 40, 40)];
    [fbButton setImage:[UIImage imageNamed:@"share-facebook"] forState:UIControlStateNormal];
    [fbButton addTarget:self action:@selector(shareToFacebook) forControlEvents:UIControlEventTouchUpInside];
    x = x + 50;
    
    UIButton *pintButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 40, 40)];
    [pintButton setImage:[UIImage imageNamed:@"share_linkedin"] forState:UIControlStateNormal];
    [pintButton addTarget:self action:@selector(shareToLinkedIn) forControlEvents:UIControlEventTouchUpInside];
    
    x = x + 50;
    
//    UIButton *googleButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 40, 40)];
//    [googleButton setImage:[UIImage imageNamed:@"share-google"] forState:UIControlStateNormal];
    
    
    
    //    [_contentScrollView addSubview:lineView];
    [_contentScrollView addSubview:reportButton];
    [_contentScrollView addSubview:shareLabel];
//    [_contentScrollView addSubview:emailButton];
//    [_contentScrollView addSubview:twitterButton];
    [_contentScrollView addSubview:fbButton];
    [_contentScrollView addSubview:pintButton];
//    [_contentScrollView addSubview:googleButton];
    reportButton.tag = 100;
    shareLabel.tag = 101;
    fbButton.tag = 102;
    pintButton.tag = 103;
    
    y = y + 70;
    
    
    
    return y;
}

- (void)shareToFacebook{
    
    _content = [[FBSDKShareLinkContent alloc] init];
    _content.contentTitle = _skillName;
    _content.imageURL = [NSURL URLWithString:_profilePicUrl];
    _content.contentURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://beta.stikyhive.com/skillPage?stkid=%@&proOrRawId=%ld&like=%ld&proOrRaw=%ld&catId=%ld", _stkId, _skillId,_likeCount,_skillType,_catId]];
    
    FBSDKShareDialog *dialog=[[FBSDKShareDialog alloc]init];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fbauth2://"]]){
        dialog.mode = FBSDKShareDialogModeNative;
    }
    else {
        dialog.mode = FBSDKShareDialogModeBrowser; //or FBSDKShareDialogModeAutomatic
    }
    dialog.shareContent=_content;
    dialog.delegate=self;
    dialog.fromViewController=self;
    [dialog show];
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share to Facebook" message:@"Share to Facebook successful" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
    _content = nil;
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share to Facebook" message:@"Share to Facebook fail" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
    _content = nil;
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    
    _content = nil;
}

- (void)shareToLinkedIn{
    
    NSString *url = @"https://api.linkedin.com/v1/people/~/shares";
    
    NSString *payload;
    
    NSString *urlStr = [NSString stringWithFormat:@"http://beta.stikyhive.com/skillPage?stkid=%@&proOrRawId=%ld&like=%ld&proOrRaw=%ld&catId=%ld", _stkId, _skillId,_likeCount,_skillType,_catId];
    
    payload = [NSString stringWithFormat:@"{\"comment\":\"%@ %@\",\"visibility\":{ \"code\":\"anyone\" }}", _skillDesc, urlStr];
                         
    if ([LISDKSessionManager hasValidSession]) {
                             [[LISDKAPIHelper sharedInstance] postRequest:url stringBody:payload
                                                                  success:^(LISDKAPIResponse *response) {
                                                                      
                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                      
                                                                          // do something with response
                                                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share to linkedIn" message:@"Share to linkedIn successful" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                                                          [alert show];
                                                                      });
                                                                      
                                                                      
                                                                  }
                                                                    error:^(LISDKAPIError *apiError) {
                                                                        
                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                        
                                                                            // do something with error
                                                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share to linkedIn" message:@"Share to linkedIn fail" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                                                            [alert show];
                                                                        });
                                                                        
                                                                    }];
    }
    else{

        
        [LISDKSessionManager createSessionWithAuth:[NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, LISDK_W_SHARE_PERMISSION, nil] state:nil showGoToAppStoreDialog:YES successBlock:^(NSString *str) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                NSLog(@"%s","success called!");
                LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
                
                [self shareToLinkedIn];
            });
            

        } errorBlock:^(NSError * error) {
            NSLog(@"%s","error called!");
        }];
    }
    /*
    [PDKPin pinWithImageURL:[NSURL URLWithString:_profilePicUrl]
                       link:[NSURL URLWithString:[NSString stringWithFormat:@"http://beta.stikyhive.com/skillPage?stkid=%@&proOrRawId=%ld&like=%ld&proOrRaw=%ld&catId=%ld", _stkId, _skillId,_likeCount,_skillType,_catId]]
         suggestedBoardName:_skillName
                       note:_skillDesc
                withSuccess:^
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Post to Pinterest" message:@"Post to Pinterest successful" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
         [alert show];
     }
                 andFailure:^(NSError *error)
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Post to Pinterest" message:@"Post to Pinterest fail" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
         [alert show];
     }];
     */
}

- (CGFloat)displaySeller:(NSString *)name beeInfo:(NSString *)beeInfo proLocation:(NSString *)profileLocation atStartPoint:(CGPoint)point andWidth:(CGFloat)width
{
    CGFloat y = point.y;
    
    UILabel *sellerLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 100, 20)];
    [sellerLabel setText:@"About Seller"];
    sellerLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:15];

    UILabel *nameLbel = [[UILabel alloc] initWithFrame:CGRectMake(30, sellerLabel.frame.origin.y+sellerLabel.frame.size.height+20, 300, 13)];
    [nameLbel setText:name];
    nameLbel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:17];
    [nameLbel setTextColor:[UIColor colorWithRed:18.0/255 green:148.0/255 blue:133.0/255 alpha:1.0]];

    CGRect frame = _sellerInfoWebView.frame;
    frame.origin.y = nameLbel.frame.origin.y+nameLbel.frame.size.height + 5;
    _sellerInfoWebView.frame = frame;

    NSString *profileuRL = [WebDataInterface getFullUrlPath:profileLocation];
    UIView *profilePhotoView = [ViewControllerUtil getViewWithImageURLNormal:profileuRL xOffset:width-90 yOffset:-20 width:60.0 heigth:60.0 defaultPhoto:@"Default_profile_small@2x"];
    profilePhotoView.layer.cornerRadius = 60.0/2;
    profilePhotoView.layer.masksToBounds = YES;
//     set border
    profilePhotoView.layer.borderColor = [UIColor whiteColor].CGColor;
    profilePhotoView.layer.borderWidth = 1;
    
    _sellerView = [[UIView alloc] initWithFrame:CGRectMake(point.x, y, width, 150)];
    _sellerView.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0];

    [_sellerView addSubview:sellerLabel];
    [_sellerView addSubview:nameLbel];
    [_sellerView addSubview:profilePhotoView];
    [_sellerView addSubview:_sellerInfoWebView];
    
    
    CGRect sellerFrame = _sellerView.frame;
    sellerFrame.size.height = sellerLabel.frame.size.height + nameLbel.frame.size.height + _sellerInfoWebView.frame.size.height + 80;
    _sellerView.frame = sellerFrame;
    
    [_contentScrollView addSubview:_sellerView];
    
    
    
    
    return y + _sellerView.frame.size.height + 50;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    
    [WebDataInterface getCommReviewBySkillId:_Skill_ID completion:^(NSObject *obj, NSError *err)
     {
         _commDict = (NSDictionary *)obj;
         _commentsArray = _commDict[@"comments"];
         _reviewArray = _commDict[@"reviews"];

     }];
    
}

- (void)reviewBtnTapped:(UITapGestureRecognizer *)sender
{
    _commBtn.userInteractionEnabled = NO;
    
    UIColor *greyColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0];
    [_commBtn setBackgroundColor:[UIColor colorWithRed:231.0/255 green:231.0/255 blue:233.0/255 alpha:1.0]];
    [_reviewBtn setBackgroundColor:greyColor];
    
    CGRect frame = _commView.frame;
    frame.size.height = 100;
    _commView.frame = frame;
    
    for (UIView *view in [_commView subviews]) {
        [view removeFromSuperview];
    }
    
    CGFloat y = [self displayCommentsView:_reviewArray atStartPoint:CGPointMake(frame.origin.x, frame.origin.y) andWidth:self.view.frame.size.width isComm:NO];
    
    y = [self displaySareButton:CGPointMake(0, y) andWidth:self.view.frame.size.width];
    
    
    CGRect sellFrame = _sellerView.frame;
    sellFrame.origin.y = y + 30;
    _sellerView.frame = sellFrame;

    
//    [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width, _sellerView.frame.origin.y + _sellerView.frame.size.height +30)];
    
    _commBtn.userInteractionEnabled = YES;
}

- (void)commBtnTapped:(UITapGestureRecognizer *)sender
{
    _reviewBtn.userInteractionEnabled = NO;
    
    UIColor *greyColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0];
    [_commBtn setBackgroundColor:greyColor];
    [_reviewBtn setBackgroundColor:[UIColor colorWithRed:231.0/255 green:231.0/255 blue:233.0/255 alpha:1.0]];
    
    CGRect frame = _commView.frame;
    
    for (UIView *view in [_commView subviews])
    {
        [view removeFromSuperview];
    }
    
    CGFloat y = [self displayCommentsView:_commentsArray atStartPoint:CGPointMake(frame.origin.x, frame.origin.y) andWidth:self.view.frame.size.width isComm:YES];
    
    y = [self displaySareButton:CGPointMake(0, y) andWidth:self.view.frame.size.width];
    
    CGRect sellFrame = _sellerView.frame;
    sellFrame.origin.y = y + 30;
    _sellerView.frame = sellFrame;
    
//    [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width, _sellerView.frame.origin.y + _sellerView.frame.size.height + 30)];
    
    _reviewBtn.userInteractionEnabled = YES;
}

- (void)postCommTapped:(UITapGestureRecognizer *)sender
{
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"post_comments_view_controller"];
    PostCommViewController *svc = (PostCommViewController *)vc;
    [svc setSkillID:_Skill_ID];
    
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)seeAllTapped:(UITapGestureRecognizer *)sender
{
//    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"seller_comments_view_controller"];
//    SellerCommViewController *svc = (SellerCommViewController *)vc;
//    [svc setSkillID:_Skill_ID];
//    
//    [self.navigationController pushViewController:svc animated:YES];
    
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"seller_comments_table_view_controller"];
    SellerCommTableViewController *svc = (SellerCommTableViewController *)vc;
    [svc setSkillID:_Skill_ID];
    
    [self.navigationController pushViewController:svc animated:YES];
}


- (void)reviewSeeAllTapped:(UITapGestureRecognizer *)sender
{
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"seller_review_view_controller"];
    SellerRevViewController *svc = (SellerRevViewController *)vc;
    [svc setSkillID:_Skill_ID];
    
    [self.navigationController pushViewController:svc animated:YES];
}


- (void)likeBtnTapped:(UITapGestureRecognizer *)sender
{
    
    [self.view showActivityViewWithLabel:@"Updating..."];
    if(_likeBtn.selected){
        
        [WebDataInterface saveReview:[NSString stringWithFormat:@"%ld", _likeId] skillId:[NSString stringWithFormat:@"%ld", _skillId] viewCount:@"0" likeCount:@"0" owner:_stkId actionMaker:[LocalDataInterface retrieveStkid] completion:^(NSObject *obj, NSError *error) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(error== nil){
                    
                    _likeCount--;
                    
                    [self updateLikeCount];
                    
                    _likeBtn.selected = !_likeBtn.selected;
                }
                
                [self.view hideActivityView];
            
            });
        }];
        
    }
    else{
        
        [WebDataInterface saveReview:[NSString stringWithFormat:@"%ld", _likeId] skillId:[NSString stringWithFormat:@"%ld", _skillId] viewCount:@"0" likeCount:@"1" owner:_stkId actionMaker:[LocalDataInterface retrieveStkid] completion:^(NSObject *obj, NSError *error) {
        
            dispatch_async(dispatch_get_main_queue(), ^{
            
                if(error== nil){
                    
                    _likeCount++;
                    
                    [self updateLikeCount];
                    
                    _likeBtn.selected = !_likeBtn.selected;
                }
                
                [self.view hideActivityView];
            });
            
        }];
        
        
    }
    
    /*
    _likeBtn.selected = !_likeBtn.selected;
    
    [self updateLikeCount];
     */
}


- (void)skillVideoTapped:(UITapGestureRecognizer *)sender
{
    if (_skillDict)
    {
        NSArray *videoArray = _skillDict[@"resultVideo"];
        NSString *videoLocation = videoArray[sender.view.tag][@"location"];
        NSString *videoUrl = [WebDataInterface getFullUrlPath:videoLocation];
        [_skillVideoPlayer startPlayingVideo:videoUrl onView:self.view];
    }
}

- (void)bookmarkBtnTapped:(UITapGestureRecognizer *)sender
{
    _bookmarkBtn.selected = !_bookmarkBtn.selected;
}

- (void)reportBtnTapped:(UITapGestureRecognizer *)sender
{
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"report_abuse_view_controller"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)emailBtnPressed:(UITapGestureRecognizer *)sender
{
    
    NSLog(@"email pressed");
    
    UIAlertView *emailAlert = [[UIAlertView alloc] initWithTitle:@"Decision" message:@"Are you sure to send email?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [emailAlert show];
    
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //no
        
        
    }else{
        //yes
        
        [self sendEmail];
        
        [self.view makeToast:@"Your Email has been sent" duration:1.0 position:CSToastPositionCenter];
        
    }
}

- (void)sendEmail
{
    // send varification email
    SendGrid *sendgrid = [SendGrid apiUser:@"StikyHive" apiKey:@"stikybee1234567"];
    
    NSString *toEmail = _skillDict[@"resultSkill"][@"email"];
    NSLog(@"to email --- %@",toEmail);
    NSString *name = [NSString stringWithFormat:@"%@ %@",_skillDict[@"resultSkill"][@"firstname"],_skillDict[@"resultSkill"][@"lastname"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    
    SendGridEmail *email = [[SendGridEmail alloc] init];
    email.from = @"stikybee@gmail.com";
    email.to = toEmail;
    email.subject = @"Email";
    email.html = [NSString stringWithFormat:@"<body style='margin: 0px;width:600px;margin:0 auto; background-color: #f9f9f9;'><div style='padding-top: 40px; padding-bottom: 0px;'><div style='text-align: center; padding: 14px;'><img src='http://stikyhive.com/img/stikyhive_mail_logo.png' style='width:40&#37;'/></div><div style='background-image: url(http://stikyhive.com/img/background.png);padding-top:30px;'><div style='text-align: center; padding: 14px;'><span style='text-align: center; color: #fff; font-size: 20px; font-family: sans-serif; text-shadow: 0px 0px 19px #ddd;'>Hi %@!</span></div><div style='text-align: center; padding: 14px;'><img src='http://stikyhive.com/img/honey.png' style='width:40&#37;'/></div><div style='text-align: center; padding: 14px;'><p style='text-align: center; font-size: 20px; margin-top: -3px; font-family: sans-serif; color: #fff;'></p></div><p style='text-align: center; font-size: 20px; margin-top: -3px; font-family: sans-serif; color: #fff;'>Respond to the potential buyer via                                </p><p style='text-align: center; font-size: 17px; margin-top: -3px; font-family: sans-serif; color: #fff;'><div style='text-align: center;padding-bottom:50px;padding-top:10px;'><a href='mailto:%@' style='text-decoration:none;color:#fff;background-color:#00b9b9;border:none;border-radius:3px;font-size:18px;padding:9px 60px 9px 60px' target='_blank'>Respond</a></div></div><div style=' padding-top: 30px; padding-bottom: 25px;'><div style='text-align: center; font-size: 18px; font-family: sans-serif; color: rgb(92, 92, 92);'><a style='display: inline; margin-left: 10px; margin-right: 10px;'>How it works</a> | <a style='display: inline; margin-left: 10px; margin-right: 10px;'>Start buying & selling</a> | <a style='display: inline; margin-left: 10px; margin-right: 10px;'>T&C</a></div><div style='font-family: sans-serif; font-size: 12px; font-weight: 600; padding-top: 26px;'><p style='text-align: center;'>You've received this email as a registered user of StikyHive.</p><p style='text-align: center;   margin-top: -6px;'>If you did not sign up and would like to unsubscribe, please click <a>here</a>.</p></div></div><div style='background-color: #f9f9f9; padding: 16px;'><footer style='text-align: right;  font-size: 13px;'><p><center>View Online</center></p><p><center>&copy;%@ StikyHive Singapore Pte Ltd. All Rights Reserved.</center></p></footer></div></body>",name,toEmail,yearString];
    
    
    email.text = @"hello world";
    
    [sendgrid sendWithWeb:email];
    
}



@end
