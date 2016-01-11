//
//  MyProfileViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 13/11/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "MyProfileViewController.h"
#import "ViewControllerUtil.h"
#import "LocalDataInterface.h"
#import "WebDataInterface.h"
#import "UIView+RNActivityView.h"

@interface MyProfileViewController ()


@property (nonatomic, strong) NSString *myStkid;
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
@property (nonatomic, strong) NSDictionary *buyerMarket;
@property (nonatomic, strong) NSArray *savedDocuArray;;
@property (nonatomic, strong) NSMutableArray *locationDocu;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIScrollView *tabScrollView;



@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _contentScrollView.alwaysBounceVertical = YES;
    _contentScrollView.delegate = self;
    
//    ///////
//    
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    
//    [dateFormat setDateFormat:@"YYYY-MM-dd"];
//    
//    NSDate *dateString = [dateFormat dateFromString:@"1990-03-18"];
//    NSString *date = [dateFormat stringFromDate:dateString];
//    
//    [WebDataInterface updateProfile:@"15AAAAHV" fname:@"dfdf" lname:@"sdfe" description:@"df" dob:date address:@"dfsd" countryISO:@"dfd" postalcode:@"dfdfd" completion:^(NSObject *obj, NSError *err) {
//        
//        NSLog(@"obj --- %@",obj);
//        NSLog(@"err --- %@",err);
//    }];
//    //////
    
    self.view.backgroundColor = [UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0];
    
    _myStkid = [LocalDataInterface retrieveStkid];
    
    [self pullData];
    
}

- (void)pullData
{
    
    [self.view showActivityViewWithLabel:@"Loading..."];
    
    [WebDataInterface getStikyBeeInfo:_myStkid completion:^(NSObject *obj, NSError *err) {
        
        [WebDataInterface getSellAll:0 catId:0 stkid:_myStkid actionMaker:_myStkid completion:^(NSObject *obj2, NSError *err2) {
            
            [WebDataInterface getBuyerMarketByStkid:_myStkid limit:0 completion:^(NSObject *obj3, NSError *err3) {
                
                [WebDataInterface getSavedDocument:_myStkid completion:^(NSObject *obj4, NSError *err4) {
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (err != nil || err2 != nil || err3 != nil || err4 != nil)
                        {
//                            [ViewControllerUtil showAlertWithTitle:@"" andMessage:@""];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"no data" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Reload", nil];
                            [alert show];
                        }
                        else
                        {
                            _beeInfoDic = (NSDictionary *)obj;
                            NSLog(@"stiky bee info -------- %@",_beeInfoDic);
                            
                            NSDictionary *seeAll = (NSDictionary *)obj2;
                            _seeAllArray = seeAll[@"result"];
                            NSLog(@"see all  --------------- %@",_seeAllArray);
                            
                            _buyerMarket = (NSDictionary *)obj3;
                            _buyerMarketArray = _buyerMarket[@"buyermarkets"];
                            NSLog(@"buyer market ----- %@",_buyerMarket);
                            
                            NSDictionary *dict = (NSDictionary *)obj4;
                            _savedDocuArray = dict[@"documents"];
                            
                            NSLog(@"get saved document --- %@",_savedDocuArray);
                            
                            
                            
                            [self displayPage];
                            
                            
                            
                        }
                        
                        [self.view hideActivityView];
                    });
                    
                }];
            }];
        }];
    }];

    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self pullData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.y < -150 && !_refreshControl.refreshing)
//    {
//        [_refreshControl beginRefreshing];
//        
//        
//        [_tabView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        [_contentScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        
//        [self pullData];
//        
//        [_refreshControl endRefreshing];
//        
//    }
//}


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
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(point.x, y, width, 200)];
    bgImageView.image = [UIImage imageNamed:@"profile_bg - Copy"];
    
    NSDictionary *stikybee = _beeInfoDic[@"stikybee"];
    
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
    
    _tabScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, width, height)];
    _tabScrollView.delegate = self;
    _tabScrollView.alwaysBounceHorizontal = YES;
    _tabScrollView.showsHorizontalScrollIndicator = NO;
    
    
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
    
    
    
    _tabScrollView.contentSize = CGSizeMake(x, height);
    
    [_tabScrollView addSubview:_skillBtn];
    [_tabScrollView addSubview:_experienceBtn];
    [_tabScrollView addSubview:_educationBtn];
    [_tabScrollView addSubview:_documentBtn];
    [_tabScrollView addSubview:_activityBtn];
    [_tabScrollView addSubview:_postBtn];
    
    [_contentScrollView addSubview:_tabScrollView];
    
    
    y = y + _tabScrollView.frame.size.height;
    
    
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
    
    if (seeAllArray.count > 0)
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
//                    picImageView.image = [ViewControllerUtil getImageWithPath:thumUrl];
                    UIImage *image = [ViewControllerUtil getImageWithPath:thumUrl];
                    
                    if (image)
                    {
                        picImageView.image = image;
                    }
                    else
                    {
                        picImageView.image = [UIImage imageNamed:@"default_seller_post"];
                    }
                                        
                    
                    
                    UIImageView *playIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_play@2x"]];
                    [playIconView setCenter:picImageView.center];
                    [picImageView addSubview:playIconView];
                    
                }
                else if (location != (id)[NSNull null])
                {
                    NSString *url = [WebDataInterface getFullUrlPath:location];
//                    picImageView.image = [ViewControllerUtil getImageWithPath:url];
                    UIImage *image = [ViewControllerUtil getImageWithPath:url];
                    if (image)
                    {
                        picImageView.image = image;
                    }
                    else
                    {
                        picImageView.image = [UIImage imageNamed:@"default_seller_post"];
                    }
                    
                    
                }
                else
                {
                    picImageView.image = [UIImage imageNamed:@"default_seller_post"];
                }
                
                
            }
            else
            {
                NSString *location = object[@"location"];
                
                if (location != (id)[NSNull null])
                {
                    NSString *url = [WebDataInterface getFullUrlPath:location];
//                    picImageView.image = [ViewControllerUtil getImageWithPath:url];
                    UIImage *image = [ViewControllerUtil getImageWithPath:url];
                    if (image)
                    {
                        picImageView.image = image;
                    }
                    else
                    {
                        picImageView.image = [UIImage imageNamed:@"default_seller_post"];
                    }
                }
                else
                {
                    picImageView.image = [UIImage imageNamed:@"default_seller_post"];
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
                
                //            UIButton *bookmarkBtn = [[UIButton alloc] initWithFrame:CGRectMake(skillView.frame.size.width-40, picImageView.frame.size.height, 23, 27)];
                //            [bookmarkBtn setImage:[UIImage imageNamed:@"profile_bookmark"] forState:UIControlStateNormal];
                
                
                CGFloat rateX = typeLabel.frame.origin.x+typeLabel.frame.size.width + 5;
                CGFloat rateY = typeLabel.frame.origin.y + 3;
                
                NSString *ratingString = object[@"rating"];
                
                if (ratingString !=(id)[NSNull null])
                {
                    NSInteger rating = [ratingString integerValue];
                    
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
                
                
                
                //            [skillView addSubview:bookmarkBtn];
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
        
        
    }
    else
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, y+30, 170, 100)];
        imageView.image = [UIImage imageNamed:@"looking"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, imageView.frame.origin.y+imageView.frame.size.height+10, 200, 30)];
        
        label.textColor = [UIColor colorWithRed:217.0/255 green:187.0/255 blue:21.0/255 alpha:1.0];
        label.textAlignment = NSTextAlignmentCenter;
        
        //        [label sizeToFit];
        
        CGPoint imageCenter = imageView.center;
        imageCenter.x = _tabView.center.x;
        imageView.center = imageCenter;
        CGPoint labelCenter = label.center;
        labelCenter.x = _tabView.center.x;
        label.center = labelCenter;
        
        if (isSkill)
        {
            label.text = @"No skills yet!";
        }
        else
        {
            label.text = @"No posts yet!";
        }
        
        
        [_tabView addSubview:imageView];
        [_tabView addSubview:label];
//        [_tabView addSubview:addBtn];
        
        y = label.frame.origin.y+label.frame.size.height + 20;
        
    }
    
    
//    [self addEditBtn:CGPointMake(20, y)]; // -------------------------
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, y+20, 150, 50)];
    [addBtn setTitle:@"Add/Edit" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.backgroundColor = greenColor;
    addBtn.layer.cornerRadius = 5;
    addBtn.layer.masksToBounds = YES;
    CGPoint addCenter = addBtn.center;
    addCenter.x = _tabView.center.x;
    addBtn.center = addCenter;
    
    if (isSkill) {
        [addBtn addTarget:self action:@selector(addSkillTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [addBtn addTarget:self action:@selector(addBuyerTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [_tabView addSubview:addBtn];

    
    y = y + 80;
    
    
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
    else
    {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, y+30, 170, 100)];
        imageView.image = [UIImage imageNamed:@"looking"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, imageView.frame.origin.y+imageView.frame.size.height+10, 200, 30)];
        
        label.textColor = [UIColor colorWithRed:217.0/255 green:187.0/255 blue:21.0/255 alpha:1.0];
        label.textAlignment = NSTextAlignmentCenter;
        
        //        [label sizeToFit];
        
        CGPoint imageCenter = imageView.center;
        imageCenter.x = _tabView.center.x;
        imageView.center = imageCenter;
        CGPoint labelCenter = label.center;
        labelCenter.x = _tabView.center.x;
        label.center = labelCenter;
        
        if (isExperience)
        {
            label.text = @"No experience yet!";
        }
        else
        {
            label.text = @"No education yet!";
        }
        
        
        [_tabView addSubview:imageView];
        [_tabView addSubview:label];
        
        y = label.frame.origin.y+label.frame.size.height +20;
        
    }
    
    
//    [self addEditBtn:CGPointMake(20, y + 20)];
//    UIColor *greenColor = [UIColor colorWithRed:18.0/255 green:148.0/255 blue:133.0/255 alpha:1.0];
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, y+20, 150, 50)];
    [addBtn setTitle:@"Add/Edit" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.backgroundColor = greenColor;
    addBtn.layer.cornerRadius = 5;
    addBtn.layer.masksToBounds = YES;
    CGPoint addCenter = addBtn.center;
    addCenter.x = _tabView.center.x;
    addBtn.center = addCenter;
    
    
    [_tabView addSubview:addBtn];
    
    
    if (isExperience) {
        [addBtn addTarget:self action:@selector(jobAddBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [addBtn addTarget:self action:@selector(educationAddBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    

    
    y = y +80;
    
    
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
            
            NSString *location = objcet[@"location"];
            
            
            
            UIButton *saveBtn= [[UIButton alloc] initWithFrame:CGRectMake(docuView.frame.size.width-40, 10, 30, 30)];
            
            
            //check document is saved or not
            if (_savedDocuArray.count > 0)
            {
                for (NSDictionary *dictionary in _savedDocuArray)
                {
                    
                    NSString *locationDict = dictionary[@"location"];
                    
                    if ([location isEqualToString:locationDict])
                    {
                        [saveBtn setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
                        saveBtn.userInteractionEnabled = NO;
                        break;
                        
                    }
                    else
                    {
                        
                        [saveBtn setImage:[UIImage imageNamed:@"icon_doc_save"] forState:UIControlStateNormal];
                        //            [_saveBtn setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateSelected];
                        [saveBtn addTarget:self action:@selector(saveBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
                        saveBtn.tag = i;
                        
                        //                        NSLog(@"save button tag --- %ld",(long)saveBtn.tag);
                        
                        
                    }
                    
                }
                
            }
            else
            {
                [saveBtn setImage:[UIImage imageNamed:@"icon_doc_save"] forState:UIControlStateNormal];
                //            [_saveBtn setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateSelected];
                [saveBtn addTarget:self action:@selector(saveBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
                saveBtn.tag = i;
                
                //                NSLog(@"save button tag --- %ld",(long)saveBtn.tag);
                
            }
            
            
            //            NSLog(@"save button tag --- %ld",(long)saveBtn.tag);
            
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, docuView.frame.size.width-saveBtn.frame.size.width-15, 20)];
            nameLabel.text = nameString;
            nameLabel.numberOfLines = 0;
            [nameLabel sizeToFit];
            
            
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, nameLabel.frame.origin.y+nameLabel.frame.size.height+5, 100, 20)];
            dateLabel.text = date;
            //            [dateLabel sizeToFit];
            
            
            CGRect docuFrame = docuView.frame;
            docuFrame.size.height = nameLabel.frame.size.height+dateLabel.frame.size.height+25;
            docuView.frame = docuFrame;
            
            CGPoint btnCenter = saveBtn.center;
            btnCenter.y = docuView.frame.size.height/2;
            saveBtn.center = btnCenter;
            
//            NSString *stkid = [LocalDataInterface retrieveStkid];
////            if (stkid != _stkId)
////            {
////                [docuView addSubview:saveBtn];
////            }
            
            [docuView addSubview:nameLabel];
            [docuView addSubview:dateLabel];
            [docuView sizeToFit];
            [_tabView addSubview:docuView];
            
            y = y+docuView.frame.size.height +20;
            
        }
        
    }
    else
    {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, y+30, 170, 100)];
        imageView.image = [UIImage imageNamed:@"looking"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, imageView.frame.origin.y+imageView.frame.size.height+10, 200, 30)];
        
        label.textColor = [UIColor colorWithRed:217.0/255 green:187.0/255 blue:21.0/255 alpha:1.0];
        label.textAlignment = NSTextAlignmentCenter;
        
        //        [label sizeToFit];
        
        CGPoint imageCenter = imageView.center;
        imageCenter.x = _tabView.center.x;
        imageView.center = imageCenter;
        CGPoint labelCenter = label.center;
        labelCenter.x = _tabView.center.x;
        label.center = labelCenter;
        
        
        label.text = @"No document yet!";
        
        
        [_tabView addSubview:imageView];
        [_tabView addSubview:label];
        
        y = label.frame.origin.y+label.frame.size.height +20;
        
        
    }
    
    [self addEditBtn:CGPointMake(x, y)];
    
    y = y + 50;
    
    
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
    
    
    
    if ([_buyerMarket[@"status"] isEqualToString:@"fail"])
    {
        for (UIView *view in [_tabView subviews])
        {
            [view removeFromSuperview];
        }
        
        CGFloat y = 0;
        CGFloat x = 20;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, y+30, 170, 100)];
        imageView.image = [UIImage imageNamed:@"looking"];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, imageView.frame.origin.y+imageView.frame.size.height+20, 200, 30)];
        
        label.textColor = [UIColor colorWithRed:217.0/255 green:187.0/255 blue:21.0/255 alpha:1.0];
        label.textAlignment = NSTextAlignmentCenter;
        
        //        [label sizeToFit];
        CGPoint imageCenter = imageView.center;
        imageCenter.x = _tabView.center.x;
        imageView.center = imageCenter;
        CGPoint labelCenter = label.center;
        labelCenter.x = _tabView.center.x;
        label.center = labelCenter;
        
        
        label.text = @"No posts yet!";
        
        [_tabView addSubview:imageView];
        [_tabView addSubview:label];
        
        
        y = label.frame.origin.y+label.frame.size.height + 20;
        
        [self addEditBtn:CGPointMake(x, y)];
        
        
        y = y + 50;
        
        
        CGRect tabViewFrame = _tabView.frame;
        tabViewFrame.size.height = y;
        _tabView.frame = tabViewFrame;
        
        [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width, _tabView.frame.size.height+310)];
        
    }
    else
    {
        [self skillTab:_buyerMarketArray isSkill:NO];
    }
    
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
    
    // no activity yet!
    for (UIView *view in [_tabView subviews])
    {
        [view removeFromSuperview];
    }
    
    CGFloat y = 0;
    CGFloat x = 20;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 30, 200, 30)];
    
    label.textColor = [UIColor colorWithRed:217.0/255 green:187.0/255 blue:21.0/255 alpha:1.0];
    label.textAlignment = NSTextAlignmentCenter;
    
    //        [label sizeToFit];
    CGPoint labelCenter = label.center;
    labelCenter.x = _tabView.center.x;
    label.center = labelCenter;
    label.text = @"No activity yet!";
    
    [_tabView addSubview:label];
    
    
    y = 50;
    
    
    CGRect tabViewFrame = _tabView.frame;
    tabViewFrame.size.height = y;
    _tabView.frame = tabViewFrame;
    
    [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width, _tabView.frame.size.height+310)];
    
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
    [self.view showActivityViewWithLabel:@"Loading.."];
    
    UIColor *greenColor = [UIColor colorWithRed:18.0/255 green:148.0/255 blue:133.0/255 alpha:1.0];
    UIColor *greyColor = [UIColor colorWithRed:109.0/255 green:110.0/255 blue:113.0/255 alpha:1.0];
    
    [_experienceBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_skillBtn setTitleColor:greenColor forState:UIControlStateNormal];
    [_educationBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_documentBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_activityBtn setTitleColor:greyColor forState:UIControlStateNormal];
    [_postBtn setTitleColor:greyColor forState:UIControlStateNormal];
    
    
    [self skillTab:_seeAllArray isSkill:YES];
    
    [self.view hideActivityView];
    
}

- (void)saveBtnTapped:(UIButton *)sender
{
    
    NSDictionary *obj = _beeInfoDic[@"document"][sender.tag];
    NSString *name = obj[@"name"];
    NSString *location = obj[@"location"];
    NSString *stkid = [LocalDataInterface retrieveStkid];
    
    [WebDataInterface insertSavedDocument:stkid name:name location:location completion:^(NSObject *obj, NSError *err) {
        
        NSDictionary *dict = (NSDictionary *)obj;
        
        
        if ([dict[@"status"] isEqualToString:@"success"]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                [sender setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
                sender.userInteractionEnabled = NO;
                
            });
            
        }
        
    }];
    
   
}


- (void)webViewDidFinishLoad:(UIWebView *)awebView
{
    CGRect frame = awebView.frame;
    NSUInteger contentHeight = [[awebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.scrollHeight;"]] intValue];
    awebView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, contentHeight);
}





- (void)addEditBtn:(CGPoint)point
{
    UIColor *greenColor = [UIColor colorWithRed:18.0/255 green:148.0/255 blue:133.0/255 alpha:1.0];
    
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, point.y, 100, 30)];
    [addBtn setTitle:@"Add/Edit" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.backgroundColor = greenColor;
    addBtn.layer.cornerRadius = 5;
    addBtn.layer.masksToBounds = YES;
    CGPoint addCenter = addBtn.center;
    addCenter.x = _tabView.center.x;
    addBtn.center = addCenter;

    [_tabView addSubview:addBtn];
    
}

- (void)jobAddBtnPressed:(UITapGestureRecognizer *)sender
{
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"job_history_view_controller"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)educationAddBtnPressed:(UITapGestureRecognizer *)sender
{
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"EducationViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addSkillTapped:(UITapGestureRecognizer *)sender
{
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"my_skill_view_controller"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addBuyerTapped:(UITapGestureRecognizer *)sender
{
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"my_post_view_controller"];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
