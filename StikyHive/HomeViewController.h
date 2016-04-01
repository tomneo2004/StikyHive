//
//  HomeViewController.h
//  StikyHive
//
//  Created by Koh Quee Boon on 14/8/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchSellViewController.h"

#define DATA_URL_HOST                   @"http://beta.stikyhive.com:81/"


#define PROFILE_IMAGE_WIDTH 40.0
#define PROFILE_IMAGE_HEIGHT 40.0
#define SKILL_IMAGE_WIDTH 240.0
#define SKILL_IMAGE_HEIGHT 135.0
#define SKILL_IMAGE_SPACE 10.0
#define BUYER_IMAGE_WIDTH 160.0
#define BUYER_IMAGE_HEIGHT 160.0
#define BUYER_IMAGE_SPACE 10.0

@interface HomeViewController : SearchSellViewController <UIScrollViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (strong, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *sellerMarketScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *buyersMarketScrollView;

@property (strong, nonatomic) IBOutlet UISearchBar *skillSearchBar;

@property (strong, nonatomic) IBOutlet UIButton *mainStartSellButton;

@property (strong, nonatomic) IBOutlet UILabel *browseLabel;

- (IBAction)pageControl:(UIPageControl *)sender;

- (IBAction)seeAllSellerButtonPressed:(id)sender;

- (IBAction)seeAllByerButtonPressed:(id)sender;

- (IBAction)mainStartButtonPressed:(id)sender;
- (IBAction)startButtonPressed:(id)sender;

- (IBAction)postBuyBtnPressed:(id)sender;

- (IBAction)industryTap:(id)sender;
- (IBAction)rawTalentTap:(id)sender;

@end
