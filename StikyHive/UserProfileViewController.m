//
//  UserProfileViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 23/10/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "UserProfileViewController.h"
#import "WebDataInterface.h"
#import "ViewControllerUtil.h"
#import "LocalDataInterface.h"

@interface UserProfileViewController ()

@property (nonatomic, strong) NSString *stkId;
@property (nonatomic, strong) NSArray *seeAllArray;
@property (nonatomic, strong) NSDictionary *beeInfoDic;
@property (nonatomic, strong) NSArray *buyerMarketArray;
@property (nonatomic, strong) UIView *tabView;
@property (nonatomic, strong) UIButton *skillBtn;
@property (nonatomic, strong) UIButton *experienceBtn;
@property (nonatomic, strong) UIButton *educationBtn;
@property (nonatomic, strong) UIButton *documentBtn;
@property (nonatomic, strong) UIButton *activityBtn;
@property (nonatomic, strong) UIButton *postBtn;

@end

@implementation UserProfileViewController


- (void)setStkID:(NSString *)stkid
{
    _stkId = stkid;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    
//    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _contentScrollView.alwaysBounceVertical = YES;
    _contentScrollView.delegate = self;
    
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0];

    
    NSString *stkid = [LocalDataInterface retrieveStkid];
    
    NSLog(@"stkid ---- %@",_stkId);
    
    [WebDataInterface getStikyBeeInfo:_stkId completion:^(NSObject *obj, NSError *err) {
        
        [WebDataInterface getSellAll:0 catId:0 stkid:_stkId actionMaker:stkid completion:^(NSObject *obj2, NSError *err2) {
            
            [WebDataInterface getBuyerMarketByStkid:_stkId limit:0 completion:^(NSObject *obj3, NSError *err3) {
                
                
                _beeInfoDic = (NSDictionary *)obj;
                NSLog(@"stiky bee info -------- %@",_beeInfoDic);
                
                NSDictionary *seeAll = (NSDictionary *)obj2;
                _seeAllArray = seeAll[@"result"];
                NSLog(@"see all  --------------- %@",_seeAllArray);
                
                NSDictionary *buyerMarket = (NSDictionary *)obj3;
                _buyerMarketArray = buyerMarket[@"buyermarkets"];
                NSLog(@"buyer market ----- %@",buyerMarket);
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    
                     [self displayPage];
                    
                    
                });
            }];
        }];
    }];
    
}


- (void)displayPage
{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = self.view.frame.size.width;
    
    
    y = [self displayTitleBg:CGPointMake(x, y) andWidth:width];
    
    y = [self displayTabScrollView:CGPointMake(x, y) andWidth:width];
    
    
    
    
    
    [_contentScrollView setContentSize:CGSizeMake(width, y)];
}


- (CGFloat)displayTitleBg:(CGPoint)point andWidth:(CGFloat)width
{
    CGFloat y = point.y;
//    UIColor *greenColor = [UIColor colorWithRed:18.0/255 green:148.0/255 blue:133.0/255 alpha:1.0];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, y, width, 200)];
    bgImageView.image = [UIImage imageNamed:@"profile_bg - Copy"];
    
    NSDictionary *stikybee = _beeInfoDic[@"stikybee"];
//    NSLog(@"stiky bee ------------- %@",stikybee);
    
    NSString *profileUrl = [WebDataInterface getFullUrlPath:stikybee[@"profilePicture"]];
    UIView *profileView = [ViewControllerUtil getViewWithImageURLNormal:profileUrl xOffset: 100 yOffset:20 width:120.0 heigth:120.0 defaultPhoto:@"Default_profile_small@2x"];
    profileView.layer.cornerRadius = 120.0/2;
    profileView.layer.masksToBounds = YES;
    profileView.layer.borderColor = [UIColor whiteColor].CGColor;
    profileView.layer.borderWidth = 2.5;
    CGPoint center = profileView.center;
    center.x = bgImageView.center.x;
    profileView.center = center;
    
    UILabel *discLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, profileView.frame.origin.y+profileView.frame.size.height+15, 300, 40)];
//    discLabel.text = stikybee[@"description"];
    discLabel.text = @"description";
    discLabel.textAlignment = NSTextAlignmentCenter;
    CGPoint discCenter = discLabel.center;
    discCenter.x = bgImageView.center.x;
    discLabel.center = discCenter;
    
    // discription web view
    
    UIWebView *discWebView = [[UIWebView alloc] initWithFrame:CGRectMake(40, profileView.frame.origin.y+profileView.frame.size.height + 15, 300, 2)];
    discWebView.scrollView.contentInset = UIEdgeInsetsMake(0, -8, discWebView.frame.size.height, -8);
    discWebView.userInteractionEnabled = NO;
    discWebView.delegate = self;
    discWebView.opaque = NO;
    discWebView.backgroundColor = [UIColor clearColor];
    
    
    UIFont *font14 = [UIFont fontWithName:@"Open Sans" size:14];
    NSString *fontFormat = @"<span style=\"font-family: %@; font-size: %i\">%@</span>";
    
    NSString *discString = stikybee[@"description"];
    NSString *discHtml = discString != (id)[NSNull null] ? [NSString stringWithFormat:fontFormat,font14.fontName,(int)font14.pointSize,discString] : @"";
    
    [discWebView loadHTMLString:discHtml baseURL:nil];
    
    
    
//    UIButton *followBtn = [[UIButton alloc] initWithFrame:CGRectMake(width-155, bgImageView.frame.size.height-50, 130, 30)];
//    [followBtn setTitle:@"Follow" forState:UIControlStateNormal];
//    [followBtn setTitleColor:greenColor forState:UIControlStateNormal];
//    followBtn.layer.borderColor = greenColor.CGColor;
//    followBtn.layer.borderWidth = 2;
//    followBtn.layer.cornerRadius = 5;
//    followBtn.layer.masksToBounds = YES;
    
    
    [bgImageView addSubview:profileView];
    [bgImageView addSubview:discWebView];
//    [bgImageView addSubview:discLabel];
//    [bgImageView addSubview:followBtn];
    
    [bgImageView addSubview:discWebView];   ///???? two??
    
    
    [_contentScrollView addSubview:bgImageView];
    
    y = y + bgImageView.frame.size.height;
    
    
    
    // ------------------------------------------------------------------
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, y, width, 60)];
    iconImageView.image = [UIImage imageNamed:@"profile_yellow_bg"];
    
    CGFloat iconViewWidth = iconImageView.frame.size.width/4;
    CGFloat iconViewHeight = iconImageView.frame.size.height;
    
    // icon view
    UIView *contactView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iconViewWidth, iconViewHeight)];
//    contactView.backgroundColor = [UIColor redColor];
    UIButton *contactBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 15, 35, 30)];
    [contactBtn setImage:[UIImage imageNamed:@"profile_addcontact"] forState:UIControlStateNormal];
    CGPoint contactBtnCenter = contactBtn.center;
    contactBtnCenter.x = contactView.center.x;
    contactBtn.center = contactBtnCenter;
    [contactView addSubview:contactBtn];
    
    
    UIView *tocolonyView = [[UIView alloc] initWithFrame:CGRectMake(iconViewWidth, 0, iconViewWidth, iconViewHeight)];
//    tocolonyView.backgroundColor = [UIColor blueColor];
    UIButton *tocolonyBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 15, 38, 30)];
    [tocolonyBtn setImage:[UIImage imageNamed:@"profile_addtocolony"] forState:UIControlStateNormal];
    CGPoint tocoBtnCenter = tocolonyBtn.center;
    tocoBtnCenter.x = iconViewWidth/2;
    tocolonyBtn.center = tocoBtnCenter;
//    CGPoint tocolonyBtnCenter = tocolonyBtn.center;
//    tocolonyBtnCenter.x = tocolonyView.center.x;
//    tocolonyBtn.center = tocolonyBtnCenter;
    [tocolonyView addSubview:tocolonyBtn];
    
    
    UIView *chatView = [[UIView alloc] initWithFrame:CGRectMake(iconViewWidth*2, 0, iconViewWidth, iconViewHeight)];
//    chatView.backgroundColor = [UIColor greenColor];
    UIButton *chatBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 15, 33, 30)];
    [chatBtn setImage:[UIImage imageNamed:@"profile_chat"] forState:UIControlStateNormal];
    CGPoint chatBtnCenter = chatBtn.center;
    chatBtnCenter.x = iconViewWidth/2;
    chatBtn.center = chatBtnCenter;
    [chatView addSubview:chatBtn];
    
    
    
    UIView *callView = [[UIView alloc] initWithFrame:CGRectMake(iconViewWidth*3, 0, iconViewWidth, iconViewHeight)];
    UIButton *callBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 15, 25, 30)];
    [callBtn setImage:[UIImage imageNamed:@"profile_call"] forState:UIControlStateNormal];
    CGPoint callBtnCenter = callBtn.center;
    callBtnCenter.x = iconViewWidth/2;
    callBtn.center = callBtnCenter;
    [callView addSubview:callBtn];

    
    
    
    
    
    [iconImageView addSubview:contactView];
    [iconImageView addSubview:tocolonyView];
    [iconImageView addSubview:chatView];
    [iconImageView addSubview:callView];
    
    
    [_contentScrollView addSubview:iconImageView];
    
    y = y + iconImageView.frame.size.height;
    
    return y;
}



- (CGFloat)displayTabScrollView:(CGPoint)point andWidth:(CGFloat)width
{
    CGFloat y = point.y;
    CGFloat height = 50;
    CGFloat x = 0;
    
    UIColor *greenColor = [UIColor colorWithRed:18.0/255 green:148.0/255 blue:133.0/255 alpha:1.0];
    UIColor *greyColor = [UIColor colorWithRed:109.0/255 green:110.0/255 blue:113.0/255 alpha:1.0];
    
    UIScrollView *tabScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, width, height)];
    tabScrollView.delegate = self;
    tabScrollView.alwaysBounceHorizontal = YES;
    tabScrollView.showsHorizontalScrollIndicator = NO;
    
    _skillBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, 80, height)];
    [_skillBtn setTitle:@"SKILLS" forState:UIControlStateNormal];
    [_skillBtn setTitleColor:greenColor forState:UIControlStateNormal];
    _skillBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:15];
    [_skillBtn addTarget:self action:@selector(skillTabTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    x = x+_skillBtn.frame.size.width;
    
    _postBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, 80, height)];
    [_postBtn setTitle:@"POSTS" forState:UIControlStateNormal];
    [_postBtn setTitleColor:greyColor forState:UIControlStateNormal];
    _postBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:15];
    [_postBtn addTarget:self action:@selector(postsTabTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    x = x+_postBtn.frame.size.width;
    
    _experienceBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, 130, height)];
    [_experienceBtn setTitle:@"EXPERIENCE" forState:UIControlStateNormal];
    [_experienceBtn setTitleColor:greyColor forState:UIControlStateNormal];
    _experienceBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:15];
    [_experienceBtn addTarget:self action:@selector(experienceTabTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    x = x+_experienceBtn.frame.size.width;
    
    _educationBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, 120, height)];
    [_educationBtn setTitle:@"EDUCATION" forState:UIControlStateNormal];
    [_educationBtn setTitleColor:greyColor forState:UIControlStateNormal];
    _educationBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:15];
    [_educationBtn addTarget:self action:@selector(educationTabTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    x = x+_educationBtn.frame.size.width;
    
    
    
    _documentBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, 130, height)];
    [_documentBtn setTitle:@"DOCUMENTS" forState:UIControlStateNormal];
    [_documentBtn setTitleColor:greyColor forState:UIControlStateNormal];
    _documentBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:15];
    [_documentBtn addTarget:self action:@selector(documentTabTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    x = x + _documentBtn.frame.size.width;
    
    _activityBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, 110, height)];
    [_activityBtn setTitle:@"ACTIVITY" forState:UIControlStateNormal];
    [_activityBtn setTitleColor:greyColor forState:UIControlStateNormal];
    _activityBtn.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:15];
    [_activityBtn addTarget:self action:@selector(activityTabTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    x = x +_activityBtn.frame.size.width;
    
    
   
    tabScrollView.contentSize = CGSizeMake(x, height);
    
    [tabScrollView addSubview:_skillBtn];
    [tabScrollView addSubview:_experienceBtn];
    [tabScrollView addSubview:_educationBtn];
    [tabScrollView addSubview:_documentBtn];
    [tabScrollView addSubview:_activityBtn];
    [tabScrollView addSubview:_postBtn];
    
    [_contentScrollView addSubview:tabScrollView];
    
    
    y = y + tabScrollView.frame.size.height;
    
    
    _tabView = [[UIView alloc] initWithFrame:CGRectMake(0, y, width, 600)];
    _tabView.backgroundColor = [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0];
    
    [self skillTab:_seeAllArray isSkill:YES];
    

    
    [_contentScrollView addSubview:_tabView];

    
    y = y + _tabView.frame.size.height;
    
    return y;
}

- (void)skillTab:(NSArray *)seeAllArray isSkill:(BOOL)isSkill
{
    CGFloat y = 0;
    CGFloat width = self.view.frame.size.width;
    
    for (UIView *view in [_tabView subviews])
    {
        [view removeFromSuperview];
    }
    

    
    UIColor *greenColor = [UIColor colorWithRed:18.0/255 green:148.0/255 blue:133.0/255 alpha:1.0];
    
    if (seeAllArray != (id)[NSNull null])
    {
        for (int i = 0; i < seeAllArray.count; i++)
        {
            NSDictionary *object = seeAllArray[i];
        
        
            UIView *skillView = [[UIView alloc] initWithFrame:CGRectMake(20, y+5, width-40, 240)];
            skillView.backgroundColor = [UIColor whiteColor];
        
            UIImageView *picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, skillView.frame.size.width, 180)];
//        picImageView.image = [ViewControllerUtil getImageWithPath:url];
            picImageView.contentMode = UIViewContentModeScaleAspectFit;
            
            
            NSString *price = object[@"price"];
            NSString *rateName = object[@"rateName"];
            
            if (price != (id)[NSNull null] && rateName !=(id)[NSNull null])
            {
            
                UIView *rateView = [[UIView alloc] initWithFrame:CGRectMake(picImageView.frame.size.width-100, picImageView.frame.size.height -50, 100, 30)];
                rateView.backgroundColor = [UIColor colorWithRed:81.0/255 green:81.0/255 blue:81.0/255 alpha:0.8];
                
                
                UILabel *dollarLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 6, 15, 15)];
                dollarLabel.text = @"S$";
                dollarLabel.font = [UIFont systemFontOfSize:11];
                dollarLabel.textColor = [UIColor whiteColor];
                [dollarLabel sizeToFit];
                
                
                UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(dollarLabel.frame.origin.x+dollarLabel.frame.size.width, 5, 50, 20)];
                priceLabel.text = price;
                priceLabel.font = [UIFont systemFontOfSize:15];
                priceLabel.textColor = [UIColor whiteColor];
                [priceLabel sizeToFit];
                
                UILabel *rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.frame.origin.x+priceLabel.frame.size.width, 6, 40, 15)];
                rateLabel.text = [NSString stringWithFormat:@" /%@",rateName];
                rateLabel.font = [UIFont systemFontOfSize:11];
                rateLabel.textColor = [UIColor whiteColor];
                [rateLabel sizeToFit];
                
                [rateView addSubview:dollarLabel];
                [rateView addSubview:priceLabel];
                [rateView addSubview:rateLabel];
//                rateLabel.textColor = [UIColor whiteColor];
//            
//                rateLabel.text = [NSString stringWithFormat:@"S$%@/%@",price,rateName];
            
            
                [picImageView addSubview:rateView];
                
            }

        
            if (isSkill)
            {
            
                NSString *thumbLocation = object[@"thumbnailLocation"];
                NSString *location = object[@"location"];
        
                if (thumbLocation != (id)[NSNull null])
                {

                    NSString *thumUrl = [WebDataInterface getFullUrlPath:thumbLocation];
            
                    picImageView.image = [ViewControllerUtil getImageWithPath:thumUrl];
                
//                  UIImage *image = [ViewControllerUtil getImageWithPath:thumUrl];
//            
//                  if (!image)
//                  {
//                      image = [UIImage imageNamed:@"Default_skill_photo@2x"];
//                  }
//                  else
//                  {
//                      picImageView.image = image;
//                  }
            
            
            
                    UIImageView *playIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_play@2x"]];
                    [playIconView setCenter:picImageView.center];
                    [picImageView addSubview:playIconView];
            
                }
                else if (location != (id)[NSNull null])
                {
                    NSString *url = [WebDataInterface getFullUrlPath:location];
                    picImageView.image = [ViewControllerUtil getImageWithPath:url];
                }
                else
                {
                    picImageView.image = [UIImage imageNamed:@"Default_skill_photo@2x"];
                }
            
            
            }
            else
            {
                NSString *location = object[@"location"];

                if (location != (id)[NSNull null])
                {
                    NSString *url = [WebDataInterface getFullUrlPath:location];
                    picImageView.image = [ViewControllerUtil getImageWithPath:url];
                }
                else
                {
                    picImageView.image = [UIImage imageNamed:@"Default_skill_photo@2x"];
                }
            
            }
        
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, picImageView.frame.size.height+5, 250, 25)];
        nameLabel.text = object[@"name"];
        nameLabel.textColor = greenColor;
        nameLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:16];
        
        
        UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,nameLabel.frame.origin.y+ nameLabel.frame.size.height+5, 95, 15)];
        typeLabel.font = [UIFont systemFontOfSize:12];
//        typeLabel.font = [UIFont fontWithName:@"OpenSans-LightItalic" size:13];
        
        NSString *type = object[@"type"];
        NSInteger typeInt = [type integerValue];
        if (typeInt == 1)
        {
            typeLabel.text = @"Professional Skill";
        }
        else
        {
            typeLabel.text = @"Raw Talent";
        }
        
        if (isSkill)
        {
  
            UIButton *bookmarkBtn = [[UIButton alloc] initWithFrame:CGRectMake(skillView.frame.size.width-40, picImageView.frame.size.height, 23, 27)];
            [bookmarkBtn setImage:[UIImage imageNamed:@"profile_bookmark"] forState:UIControlStateNormal];
            
        
            CGFloat rateX = typeLabel.frame.origin.x+typeLabel.frame.size.width + 5;
            CGFloat rateY = typeLabel.frame.origin.y + 3;
        
            NSString *ratingString = object[@"rating"];
        
            if (ratingString !=(id)[NSNull null])
            {
                NSInteger rating = [ratingString integerValue];
            
//              CGFloat rateX = typeLabel.frame.origin.x+typeLabel.frame.size.width + 5;
//              CGFloat rateY = typeLabel.frame.origin.y + 3;
            
                for (int i = 0; i < rating; i++)
                {
                
                    UIImageView *rateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(rateX, rateY, 11, 11)];
                    rateImageView.image = [UIImage imageNamed:@"review_filled"];
                
                    [skillView addSubview:rateImageView];
                
                    rateX = rateX+rateImageView.frame.size.width;
                }
            
                int ratInt = [ratingString intValue];
            
                if (rating < 5)
                {
                
                    for (int i = ratInt; i < 5; i++)
                    {
                        UIImageView *rateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(rateX, rateY, 11, 11)];
                        rateImageView.image = [UIImage imageNamed:@"review_empty"];
                    
                        [skillView addSubview:rateImageView];
                    
                        rateX = rateX+rateImageView.frame.size.width;
                    }
                
                }

            }
            else
            {
//              CGFloat rateX = typeLabel.frame.origin.x+typeLabel.frame.size.width + 5;
//              CGFloat rateY = typeLabel.frame.origin.y + 3;
            
                for (int i = 0; i < 5; i++)
                {
                    UIImageView *rateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(rateX, rateY, 11, 11)];
                    rateImageView.image = [UIImage imageNamed:@"review_empty"];
                
                    [skillView addSubview:rateImageView];
                
                    rateX = rateX+rateImageView.frame.size.width;
                }

            }
        
        
            UILabel *reviewLabel = [[UILabel alloc] initWithFrame:CGRectMake(rateX+8, rateY-2, 100, 15)];
            reviewLabel.text = [NSString stringWithFormat:@"%@ Reviews",object[@"reviewCount"]];
            reviewLabel.font = [UIFont systemFontOfSize:13];
        
        
            rateX = rateX+reviewLabel.frame.size.width+10;
        
        
            UILabel *likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-100, rateY, 80, 15)];
            likeLabel.font = [UIFont systemFontOfSize:13];
            
            NSString *likeCountString = object[@"likeCount"];
            
            if (likeCountString != (id)[NSNull null])
            {
                likeLabel.text = [NSString stringWithFormat:@"%@ Likes",likeCountString];
            
            }
            else
            {
                likeLabel.text = @"0 Likes";
            }
        
            UIImageView *likeImage = [[UIImageView alloc] initWithFrame:CGRectMake(width-likeLabel.frame.size.width-40, rateY, 15, 15)];
        
            NSString *likeIdString = object[@"likeId"];
            NSInteger likeId = [likeIdString integerValue];
        
            if (likeId != 0) {
                likeImage.image = [UIImage imageNamed:@"like_filled"];
            }
            else
            {
                likeImage.image = [UIImage imageNamed:@"like"];
            }
            
            
            
            [skillView addSubview:bookmarkBtn];
            [skillView addSubview:reviewLabel];
            [skillView addSubview:likeImage];
            [skillView addSubview:likeLabel];
            
        }
        
        
        [skillView addSubview:picImageView];
        [skillView addSubview:nameLabel];
        [skillView addSubview:typeLabel];
 
        [_tabView addSubview:skillView];
        
        
        y = y + skillView.frame.size.height+20;
    
    }
    
    
//    UIButton * addSkillBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, y+10, 150, 40)];
//    [addSkillBtn setTitle:@"Add Skill" forState:UIControlStateNormal];
//    addSkillBtn.backgroundColor = greenColor;
//    addSkillBtn.layer.cornerRadius = 5;
//    addSkillBtn.layer.masksToBounds = YES;
//    CGPoint buttonCenter = addSkillBtn.center;
//    buttonCenter.x = _tabView.center.x;
//    addSkillBtn.center = buttonCenter;
//    
//    
//    [_tabView addSubview:addSkillBtn];
//    
//    y = y + addSkillBtn.frame.size.height+30;

    }
    else
    {
        
        
    }
    
    CGRect tabViewFrame = _tabView.frame;
    tabViewFrame.size.height = y;
    _tabView.frame = tabViewFrame;
    
    [_contentScrollView setContentSize:CGSizeMake(width, y+310)];
    
}

- (void)experienceTab:(NSArray *)jobhistoryArray isExperience:(BOOL)isExperience
{
    for (UIView *view in [_tabView subviews])
    {
        [view removeFromSuperview];
    }
    
    CGFloat y = 0;
    CGFloat width = self.view.frame.size.width;
    UIColor *greenColor = [UIColor colorWithRed:18.0/255 green:148.0/255 blue:133.0/255 alpha:1.0];

//    _tabView.backgroundColor = [UIColor yellowColor];
    
//    NSArray *jobHistoryArray = _beeInfoDic[@"jobhistory"];
    
    if (jobhistoryArray != (id)[NSNull null])
    {
 
        for (int i =0; i < jobhistoryArray.count; i++)
        {
        
            NSDictionary *object = jobhistoryArray[i];
            UIView *experienceView = [[UIView alloc] initWithFrame:CGRectMake(0, y, width, 200)];
        
            NSDateFormatter *formate = [[NSDateFormatter alloc] init];
            NSString *fromDateString = object[@"fromDate"];
            NSString *toDate = object[@"toDate"];
        
            if (toDate == (id)[NSNull null])
            {
                NSDate *today = [NSDate date];
                [formate setDateFormat:@"MMM yyyy"];
                toDate = [formate stringFromDate:today];
            
                [formate setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
                NSDate *fromDateDt = [formate dateFromString:fromDateString];
                [formate setDateFormat:@"MMM yyyy"];
                fromDateString = [formate stringFromDate:fromDateDt];
            }
            else
            {
                [formate setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
                NSDate *fromDateDt = [formate dateFromString:fromDateString];
                NSDate *toDateDt = [formate dateFromString:toDate];
                [formate setDateFormat:@"MMM yyyy"];
                fromDateString = [formate stringFromDate:fromDateDt];
                toDate = [formate stringFromDate:toDateDt];
            }
        
            NSString *companyNameString = @"";
            NSString *jobTitleString = @"";
            NSString *countryString = @"";

        
            if (isExperience)
            {
                companyNameString = object[@"companyName"];
                jobTitleString = object[@"jobtitle"];
                countryString = object[@"countryName"];
            }
            else
            {
                companyNameString = object[@"institute"];
                jobTitleString = object[@"qualification"];
                countryString = object[@"countryName"];
            }
        
            NSString *otherInfoString = object[@"otherInfo"];
        
            CGFloat viewY = 20;
            CGFloat viewX = 30;
        
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewX, viewY, 300, 15)];
            dateLabel.font = [UIFont systemFontOfSize:13];
            dateLabel.text = [NSString stringWithFormat:@"%@ - %@",fromDateString,toDate];
        
            viewY = viewY + dateLabel.frame.size.height + 5;
        
            UILabel *companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewX, viewY, 300, 19)];
            companyLabel.text = [NSString stringWithFormat:@"%@, %@",companyNameString,countryString];
            companyLabel.textColor = greenColor;
        
            viewY += companyLabel.frame.size.height +5;
        
            UILabel *jobTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewX, viewY, 300, 19)];
            jobTitleLabel.text = jobTitleString;
        
            viewY += jobTitleLabel.frame.size.height + 10;
        
            UIWebView *infoWebView = [[UIWebView alloc] initWithFrame:CGRectMake(viewX, viewY, width-60, 2)];
            infoWebView.scrollView.contentInset = UIEdgeInsetsMake(0, -8, infoWebView.frame.size.height, -8);
            infoWebView.userInteractionEnabled = NO;
            infoWebView.delegate = self;
            infoWebView.opaque = NO;
            infoWebView.backgroundColor = [UIColor clearColor];
        
            UIFont *font14 = [UIFont fontWithName:@"Open Sans" size:14];
            NSString *fontFormat = @"<span style=\"font-family: %@; font-size: %i\">%@</span>";
        
            NSString *discHtml = otherInfoString != (id)[NSNull null] ? [NSString stringWithFormat:fontFormat,font14.fontName,(int)font14.pointSize,otherInfoString] : @"";
        
            [infoWebView loadHTMLString:discHtml baseURL:nil];
        
            viewY += infoWebView.frame.size.height + 30;
        
            UIColor *lineColor = [UIColor colorWithRed:215.0/255 green:217.0/255 blue:218.0/255 alpha:1.0];
        
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(viewX, viewY, width - 60, 1)];
            CGPoint center = lineView.center;
            center.x = self.view.center.x;
            lineView.center = center;
            [lineView setBackgroundColor:lineColor];

        
        
            [experienceView addSubview:dateLabel];
            [experienceView addSubview:companyLabel];
            [experienceView addSubview:jobTitleLabel];
            [experienceView addSubview:infoWebView];
            [experienceView addSubview:lineView];
        
            CGRect experFrame = experienceView.frame;
            experFrame.size.height = viewY+2;
            experienceView.frame = experFrame;
        
            [_tabView addSubview:experienceView];
        
            y = y + experienceView.frame.size.height;
        
        }
        
    }
    
    CGRect tabViewFrame = _tabView.frame;
    tabViewFrame.size.height = y;
    _tabView.frame = tabViewFrame;
    
    [_contentScrollView setContentSize:CGSizeMake(width, _tabView.frame.size.height+310)];
    
}

- (void)documentTab:(NSArray *)documentArray
{
    for (UIView *view in [_tabView subviews])
    {
        [view removeFromSuperview];
    }
    
    CGFloat y = 0;
    CGFloat x = 20;
    CGFloat width = self.view.frame.size.width;
    
    if (documentArray != (id)[NSNull null])
    {
        
        for (int i = 0; i < documentArray.count; i++)
        {
            
            NSDictionary *objcet = documentArray[i];
            
            NSString *nameString = objcet[@"name"];
            NSString *dateString = objcet[@"createDate"];
            
            NSDateFormatter *formate = [[NSDateFormatter alloc] init];
            [formate setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
            NSDate *fromDateDt = [formate dateFromString:dateString];
            [formate setDateFormat:@"dd MMM yyyy"];
            NSString *date = [formate stringFromDate:fromDateDt];
            
            UIView *docuView = [[UIView alloc] initWithFrame:CGRectMake(x, y+10, width - 40, 80)];
            docuView.backgroundColor = [UIColor whiteColor];
            
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, docuView.frame.size.width-20, 20)];
            nameLabel.text = nameString;
            nameLabel.numberOfLines = 0;
            [nameLabel sizeToFit];
            
            
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, nameLabel.frame.origin.y+nameLabel.frame.size.height+5, 100, 20)];
            dateLabel.text = date;
//            [dateLabel sizeToFit];
            
            
            
            [docuView addSubview:nameLabel];
            [docuView addSubview:dateLabel];
            [docuView sizeToFit];
            [_tabView addSubview:docuView];
            
            y = y+docuView.frame.size.height +20;
        
        }
        
    }
    
    CGRect tabViewFrame = _tabView.frame;
    tabViewFrame.size.height = y;
    _tabView.frame = tabViewFrame;
    
    [_contentScrollView setContentSize:CGSizeMake(width, _tabView.frame.size.height+310)];

    
}

- (void)postsTabTapped:(UITapGestureRecognizer *)sender
{
    UIColor *greenColor = [UIColor colorWithRed:18.0/255 green:148.0/255 blue:133.0/255 alpha:1.0];
    UIColor *greyColor = [UIColor colorWithRed:109.0/255 green:110.0/255 blue:113.0/255 alpha:1.0];
    
    [_experienceBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_skillBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_educationBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_documentBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_activityBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_postBtn setTitleColor:greenColor forState:UIControlStateNormal];


    [self skillTab:_buyerMarketArray isSkill:NO];
    
}

- (void)documentTabTapped:(UITapGestureRecognizer *)sender
{
    UIColor *greenColor = [UIColor colorWithRed:18.0/255 green:148.0/255 blue:133.0/255 alpha:1.0];
    UIColor *greyColor = [UIColor colorWithRed:109.0/255 green:110.0/255 blue:113.0/255 alpha:1.0];
    
    [_experienceBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_skillBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_educationBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_documentBtn setTitleColor:greenColor forState:UIControlStateNormal];
    [_activityBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_postBtn setTitleColor:greyColor forState:UIControlStateNormal];

    
    [self documentTab:_beeInfoDic[@"document"]];
}

- (void)activityTabTapped:(UITapGestureRecognizer *)sender
{
    UIColor *greenColor = [UIColor colorWithRed:18.0/255 green:148.0/255 blue:133.0/255 alpha:1.0];
    UIColor *greyColor = [UIColor colorWithRed:109.0/255 green:110.0/255 blue:113.0/255 alpha:1.0];
    
    [_experienceBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_skillBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_educationBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_documentBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_activityBtn setTitleColor:greenColor forState:UIControlStateNormal];
    [_postBtn setTitleColor:greyColor forState:UIControlStateNormal];

}

- (void)experienceTabTapped:(UITapGestureRecognizer *)sender
{
    UIColor *greenColor = [UIColor colorWithRed:18.0/255 green:148.0/255 blue:133.0/255 alpha:1.0];
    UIColor *greyColor = [UIColor colorWithRed:109.0/255 green:110.0/255 blue:113.0/255 alpha:1.0];
    
    [_experienceBtn setTitleColor:greenColor forState:UIControlStateNormal];
    [_skillBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_educationBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_documentBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_activityBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_postBtn setTitleColor:greyColor forState:UIControlStateNormal];
    
    
    NSArray *jobHistoryArray = _beeInfoDic[@"jobhistory"];
    
    [self experienceTab:jobHistoryArray isExperience:YES];
}

- (void)educationTabTapped:(UITapGestureRecognizer *)sender
{
    UIColor *greenColor = [UIColor colorWithRed:18.0/255 green:148.0/255 blue:133.0/255 alpha:1.0];
    UIColor *greyColor = [UIColor colorWithRed:109.0/255 green:110.0/255 blue:113.0/255 alpha:1.0];
    
    [_experienceBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_skillBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_educationBtn setTitleColor:greenColor forState:UIControlStateNormal];
    [_documentBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_activityBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_postBtn setTitleColor:greyColor forState:UIControlStateNormal];

    
    NSArray *educationArray = _beeInfoDic[@"education"];
    
    [self experienceTab:educationArray isExperience:NO];
}


- (void)skillTabTapped:(UITapGestureRecognizer *)sender
{
    UIColor *greenColor = [UIColor colorWithRed:18.0/255 green:148.0/255 blue:133.0/255 alpha:1.0];
    UIColor *greyColor = [UIColor colorWithRed:109.0/255 green:110.0/255 blue:113.0/255 alpha:1.0];
    
    [_experienceBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_skillBtn setTitleColor:greenColor forState:UIControlStateNormal];
    [_educationBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_documentBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_activityBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_postBtn setTitleColor:greyColor forState:UIControlStateNormal];

                                                          
    [self skillTab:_seeAllArray isSkill:YES];
    
}


- (void)webViewDidFinishLoad:(UIWebView *)awebView
{
    CGRect frame = awebView.frame;
    NSUInteger contentHeight = [[awebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.scrollHeight;"]] intValue];
    awebView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, contentHeight);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
