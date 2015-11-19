//
//  HomeViewController.m
//  StikyHive
//
//  Created by Koh Quee Boon on 14/8/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "HomeViewController.h"
#import "LocalDataInterface.h"
#import "WebDataInterface.h"
#import "ViewControllerUtil.h"
#import "SkillVideoPlayer.h"
#import "SkillPageViewController.h"
#import "BuyerPostViewController.h"
#import "UserProfileViewController.h"

@interface HomeViewController ()

@property (strong, nonatomic) NSArray *imageArray;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) SkillVideoPlayer *skillVideoPlayer;
@property (nonatomic, strong) NSArray *sellerMarket;
@property (nonatomic, strong) NSArray *buyerMarket;
@property (nonatomic, strong) NSDictionary *skillDict;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // set navigation titleview image
    UIImage *logoImage = [UIImage imageNamed:@"hive_icon@2x"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];
    
    UIColor *green = [UIColor colorWithRed:0 green:167.0/255 blue:155.0/255 alpha:1.0];
    UITableView *view = (UITableView *)self.tabBarController.moreNavigationController.topViewController.view;
    view.tintColor = green; // change the icon color
    
    CGFloat width = self.view.frame.size.width;
    
    CGRect startBtnFrame = _mainStartSellButton.frame;
    startBtnFrame.size.width = 60;
    _mainStartSellButton.frame = startBtnFrame;
    CGPoint startBtnCenter = _mainStartSellButton.center;
    startBtnCenter.x = self.view.center.x;
    _mainStartSellButton.center = startBtnCenter;
    
    
    _skillVideoPlayer = [[SkillVideoPlayer alloc] init];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _refreshControl = [[UIRefreshControl alloc] init];
    
    _mainScrollView.alwaysBounceVertical = YES;
    [_mainScrollView addSubview:_refreshControl];
    _mainScrollView.delegate = self;
    [_mainScrollView setContentSize:CGSizeMake(_mainScrollView.frame.size.width,1565)];
    
    [_mainScrollView setContentOffset:CGPointMake(0, -180) animated:YES]; // Force pull to refresh
    
    
    _imageScrollView.pagingEnabled = YES;
    _imageScrollView.showsHorizontalScrollIndicator = NO;
    _imageScrollView.alwaysBounceHorizontal = YES;
    _imageScrollView.delegate = self;
    
    
    
     
    // prepare for the imageview scroll view --- page control
    UIImageView *p1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 290)];
    p1.image = [UIImage imageNamed:@"slide-0820-01"];
    
    UIImageView *p2 = [[UIImageView alloc] initWithFrame:CGRectMake(width, 0, width, 290)];
    p2.image = [UIImage imageNamed:@"slide-0820-02"];
    
    [_imageScrollView addSubview:p1];
    [_imageScrollView addSubview:p2];
    _imageScrollView.contentSize = CGSizeMake(width*2, _imageScrollView.frame.size.height);
    
    
    // Request for the data needed for the home page
    [WebDataInterface getSellAll:8 catId:0 stkid:@"" actionMaker:@"" completion:^(NSObject *obj, NSError *err)
    {
        
        [WebDataInterface getBuyerMarket:@"" limit:8 completion:^(NSObject *obj2, NSError *err2)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 [self dataReceivedSkills:(NSDictionary *)obj];
                 
                 [self dataReceivedBuyers:(NSDictionary *)obj2];

             });
             
             
        }];
       
    }];
    
   
    
 /*
    NSString *emailText = [LocalDataInterface retrieveUsername];
    NSString *passwordText = [LocalDataInterface retrievePassword];
    
    /////// TEST ///
    if (emailText != nil) {
        [WebDataInterface loginWithEmail:emailText password:passwordText completion:^(NSObject *obj, NSError *err)
         {
             dispatch_async(dispatch_get_main_queue(), ^{[self dataReceived:(NSDictionary *)obj];});
         }];
    }
*/
    
}

// For shortening the refresh control distance.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < -150 && !_refreshControl.refreshing)
    {
//        [self.view setUserInteractionEnabled:NO];
        [_refreshControl beginRefreshing];
        _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
        
        [_sellerMarketScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_buyersMarketScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        
        // Request for the seller market data needed for the home page.
        [WebDataInterface getSellAll:8 catId:0 stkid:@"" actionMaker:@"" completion:^(NSObject *obj, NSError *err)
         {
//             [self.view setUserInteractionEnabled:YES];
             
             // Request for the buyer market data needed for the home page
             [WebDataInterface getBuyerMarket:@"" limit:8 completion:^(NSObject *obj2, NSError *err2)
              {
                  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                                 {
                
                                     [self dataReceivedSkills:(NSDictionary *)obj];
                                     
                                     [self dataReceivedBuyers:(NSDictionary *)obj2];
                                     
                                     NSString *currentTimeStamp = [ViewControllerUtil getCurrentDateTimeWithFormat:@"MM d,h:mm a"];
                                     NSString *lastUpdate = [NSString stringWithFormat:@"Last updated on %@",currentTimeStamp];
                                     _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdate];
                                     [_refreshControl endRefreshing];
                                     
//                                     [self.view setUserInteractionEnabled:YES];
                                 });
                  
              }];

             
             
             
//             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
//             {
//                 
//             });
             
         }];
        
        
        
    }
}


- (void)dataReceivedSkills:(NSDictionary *)dict
{
//    NSLog(@"dict ------------------------------------------- %@",dict);
    
    
    if (dict && dict[@"status"])
    {
        
    }
    
    _sellerMarket = dict[@"result"];
    
    
    NSLog(@"selller market --------------------------- %@",_sellerMarket);
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
    for (int i = 0; i < _sellerMarket.count; i ++)
    {
        NSString *title = _sellerMarket[i][@"name"];
        NSString *photo = _sellerMarket[i][@"location"];
        NSString *profile = _sellerMarket[i][@"profilePicture"];
        NSString *vidio = _sellerMarket[i][@"thumbnailLocation"];
        
        NSString *photoUrl = photo!=(id)[NSNull null] ? [WebDataInterface getFullUrlPath:photo] : nil;
        NSString *profileUrl = profile!=(id)[NSNull null] ? [WebDataInterface getFullUrlPath:profile] : nil;
        NSString *thumnailUrl = vidio!=(id)[NSNull null] ? [WebDataInterface getFullUrlPath:vidio] : nil;
        
        NSString *displayImageUrl = thumnailUrl ? thumnailUrl : photoUrl;
        
        
        CGFloat x1 = SKILL_IMAGE_SPACE + i*(SKILL_IMAGE_WIDTH+SKILL_IMAGE_SPACE);
        CGFloat y1 = 0;
        CGFloat w1 = SKILL_IMAGE_WIDTH;
        CGFloat h1 = SKILL_IMAGE_HEIGHT;
        
        UIView *skillPhotoView = [ViewControllerUtil getViewWithImageURL:displayImageUrl xOffset:x1 yOffset:y1 width:w1 heigth:h1 withTarget:self forSelector:@selector(sellerSkillPhotoTapped:) andTag:i defaultPhoto:@"default_seller_post"];
        
        CGFloat x2 = SKILL_IMAGE_SPACE +i*(SKILL_IMAGE_WIDTH+SKILL_IMAGE_SPACE) + SKILL_IMAGE_WIDTH - 1.25*PROFILE_IMAGE_WIDTH;
        CGFloat y2 = SKILL_IMAGE_HEIGHT - PROFILE_IMAGE_HEIGHT/2;
        CGFloat w2 = PROFILE_IMAGE_WIDTH;
        CGFloat h2 = PROFILE_IMAGE_HEIGHT;
        UIView *profilePhotoView = [ViewControllerUtil getViewWithImageURL:profileUrl xOffset:x2 yOffset:y2 width:w2 heigth:h2 withTarget:self forSelector:@selector(sellerProfilePhotoTapped:) andTag:i defaultPhoto:@"Default_profile_small@2x"];
        
        profilePhotoView.layer.cornerRadius = w2/2;
        profilePhotoView.layer.masksToBounds = YES;
        
        UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(x2-w2/10, y2-w2/10, w2+w2/5, h2+w2/5)];
        circleView.backgroundColor = [UIColor whiteColor];
        circleView.layer.cornerRadius = w2/2+w2/10;
        circleView.layer.masksToBounds = YES;
        
        CGFloat x3 = SKILL_IMAGE_SPACE + i*(SKILL_IMAGE_WIDTH+SKILL_IMAGE_SPACE);
        CGFloat y3 = SKILL_IMAGE_HEIGHT + 5;
        CGFloat w3 = SKILL_IMAGE_WIDTH - PROFILE_IMAGE_WIDTH - 5;
        CGFloat h3 = 20;
        UILabel *skillLabel = [ViewControllerUtil getLabelForTitle:title xOffset:x3 yOffset:y3 width:w3 heigth:h3 withTarget:self forSelector:@selector(sellerTitleTapped:) andTag:i];
        skillLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:13];
        
        [_sellerMarketScrollView addSubview:skillPhotoView];
        [_sellerMarketScrollView addSubview:circleView];
        [_sellerMarketScrollView addSubview:profilePhotoView];
        [_sellerMarketScrollView addSubview:skillLabel];
        
        if (vidio!=(id)[NSNull null])
        {
            UIImageView *playIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_play@2x"]];
            [playIconView setCenter:skillPhotoView.center];
            [_sellerMarketScrollView addSubview:playIconView];
        }
        
    }
    
    _sellerMarketScrollView.contentSize = CGSizeMake(_sellerMarket.count *(SKILL_IMAGE_WIDTH + SKILL_IMAGE_SPACE) + SKILL_IMAGE_SPACE, _sellerMarketScrollView.frame.size.height);
    
    
    [_refreshControl endRefreshing];
    
//    [self.view setUserInteractionEnabled:YES];
        
    });
}



- (void)dataReceivedBuyers:(NSDictionary *)dict
{
    
    _buyerMarket = dict[@"buyermarkets"];
    
//    NSLog(@"buyer market id  -------------   %@",_buyerMarket);
    
    UIFont *font = [UIFont systemFontOfSize:12];
    CGFloat y1 = 0;
    CGFloat w1 = BUYER_IMAGE_WIDTH;
    CGFloat h1 = BUYER_IMAGE_HEIGHT;
    CGFloat y2 = BUYER_IMAGE_HEIGHT + 5;
    CGFloat w2 = BUYER_IMAGE_WIDTH;
    CGFloat h2 = 17;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for (int i = 0; i < _buyerMarket.count; i++)
        {
            NSString *title = _buyerMarket[i][@"name"];
            NSString *photoLoction = _buyerMarket[i][@"location"];
            NSString *photoUrl = [NSString stringWithFormat:@"%@%@",DATA_URL_HOST,photoLoction];
            
            CGFloat x1 = BUYER_IMAGE_SPACE + i*(BUYER_IMAGE_WIDTH+BUYER_IMAGE_SPACE);
            
            UIView *subView = [ViewControllerUtil getViewWithImageURL:photoUrl xOffset:x1 yOffset:y1 width:w1 heigth:h1 withTarget:self forSelector:@selector(buyerImageTapped:) andTag:i defaultPhoto:@"Default_buyer_post"];
            
            [_buyersMarketScrollView addSubview:subView];
            
            CGFloat x2 = BUYER_IMAGE_SPACE + i*(BUYER_IMAGE_WIDTH+BUYER_IMAGE_SPACE);
            UILabel *label = [ViewControllerUtil getLabelForTitle:title xOffset:x2 yOffset:y2 width:w2 heigth:h2 withTarget:self forSelector:@selector(buyerTitleTapped:) andTag:i];
            label.font = font;
            [_buyersMarketScrollView addSubview:label];
        
        }
        
        _buyersMarketScrollView.contentSize = CGSizeMake(_buyerMarket.count*(BUYER_IMAGE_WIDTH + BUYER_IMAGE_SPACE) + BUYER_IMAGE_SPACE, _buyersMarketScrollView.frame.size.height);
    
    });
    
}


- (void)dataReceived:(NSDictionary *)dict
{
    
        if (dict && dict[@"status"])
        {
            NSString *statusString = dict[@"status"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([statusString isEqualToString:@"success"])
                {
                    NSDictionary *stikybee = dict[@"stikybee"];
                    NSString *statusStri = stikybee[@"status"];
                    NSInteger statusInt = [statusStri integerValue];
                
                    if (statusInt == 0)
                    {
                        UIViewController *vc = [ViewControllerUtil instantiateViewController:@"user_verification_view_controller"];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else if (statusInt == 1)
                    {
                        UIViewController *vc = [ViewControllerUtil instantiateViewController:@"user_info_editor_view_controller_1"];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else if (statusInt == 2 || statusInt == 12 || statusInt == 14)
                    {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    else if (statusInt == 11 || statusInt == 13)
                    {
                        UIViewController *vc = [ViewControllerUtil instantiateViewController:@"user_info_editor_view_controller2"];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
//                    else
//                    {
//                    
//                    }
                }
        });
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
    NSString *emailText = [LocalDataInterface retrieveUsername];
    NSString *passwordText = [LocalDataInterface retrievePassword];
    
    /////// TEST ///
    if (emailText != nil)
    {
        [WebDataInterface loginWithEmail:emailText password:passwordText completion:^(NSObject *obj, NSError *err)
         {
             dispatch_async(dispatch_get_main_queue(), ^{[self dataReceived:(NSDictionary *)obj];});
         }];
    }
    else
    {
        UIViewController *vc = [ViewControllerUtil instantiateViewController:@"entry_view_controller"];
        [self.navigationController pushViewController:vc animated:YES];
    }
 
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSInteger pageNumber = roundf(_imageScrollView.contentOffset.x / (_imageScrollView.frame.size.width));
    int page = _imageScrollView.contentOffset.x/_imageScrollView.frame.size.width;
    _pageControl.currentPage = page;
}

- (void)buyerImageTapped:(UIGestureRecognizer *)sender
{
    NSString *photoLocation = _buyerMarket[sender.view.tag][@"location"];
    
    if (photoLocation != (id)[NSNull null]) {
        NSString *photoUrl = [WebDataInterface getFullUrlPath:photoLocation];
        [ViewControllerUtil showFullPhoto:photoUrl onViewController:self];

    }
    
    
}

- (void)buyerTitleTapped:(UIGestureRecognizer *)sender
{
    
    NSString *buyerid = _buyerMarket[sender.view.tag][@"id"];
    NSInteger idInteger = [buyerid integerValue];
    NSString *location = _buyerMarket[sender.view.tag][@"location"];
    
    
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"buyer_post_view_controlller"];
    BuyerPostViewController *svc = (BuyerPostViewController *)vc;
    [svc setBuyerId:idInteger];
    [svc setPictureLocation:location];
    
    [self.navigationController pushViewController:svc animated:YES];

    
}

- (void)sellerSkillPhotoTapped:(UIGestureRecognizer *)sender
{
    NSString *photoLocation = _sellerMarket[sender.view.tag][@"location"];
    NSString *vedioLocation = _sellerMarket[sender.view.tag][@"videoLocation"];
    
    
    if (vedioLocation != (id)[NSNull null])
    {
         NSString *vedioUrl = [WebDataInterface getFullUrlPath:vedioLocation];
        [_skillVideoPlayer startPlayingVideo:vedioUrl onView:self.view];
    }
    else if (photoLocation != (id)[NSNull null])
    {
        NSString *photoUrl = [WebDataInterface getFullUrlPath:photoLocation];
       [ViewControllerUtil showFullPhoto:photoUrl onViewController:self];
    }
}

- (void)sellerProfilePhotoTapped:(UIGestureRecognizer *)sender
{
    
    NSString *stkid =  _sellerMarket[sender.view.tag][@"stkid"];
    
    NSLog(@"home page stkid selected ------ %@",stkid);
    
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"user_profile_view_controller"];
    UserProfileViewController *svc = (UserProfileViewController *)vc;
    [svc setStkID:stkid];
    
    [self.navigationController pushViewController:svc animated:YES];
    
}

- (void)sellerTitleTapped:(UIGestureRecognizer *)sender
{
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"skill_page_view_controller"];
    SkillPageViewController *svc = (SkillPageViewController *)vc;
    [svc setSkillID:_sellerMarket[sender.view.tag][@"skillId"]];
    
    [self.navigationController pushViewController:svc animated:YES];
}



- (IBAction)pageControl:(UIPageControl *)sender
{
    CGFloat x = _pageControl.currentPage * _imageScrollView.frame.size.width;
    [_imageScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (IBAction)seeAllSellerButtonPressed:(id)sender
{
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"seller_view_controller"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)seeAllByerButtonPressed:(id)sender
{
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"buyer_collection_view_controller"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)mainStartButtonPressed:(id)sender
{
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"selling_view_controller"];
    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)startButtonPressed:(id)sender
{
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"selling_view_controller"];
    [self.navigationController pushViewController:vc animated:YES];

}
@end
