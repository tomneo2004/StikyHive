//
//  SearchSellViewController.m
//  StikyHive
//
// Super class for HomeViewController, NotificationsViewController, CrossPollinateViewController,
// ProfileViewController, TransactionViewController
//
//  Created by Koh Quee Boon on 9/6/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "SearchSellViewController.h"
#import "UserSkillViewController1.h"
#import "SellerCollectionViewController.h"
#import "PushNotificationDataInterface.h"
#import "LocalDataInterface.h"
#import "WebDataInterface.h"
#import "ViewControllerUtil.h"
#import "ChatListViewController.h"

@interface SearchSellViewController ()

@property (nonatomic, strong) UILabel *chatBadge;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation SearchSellViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *chatButton = [ViewControllerUtil createBarButton:@"button_chat_header" onTarget:self withSelector:@selector(chatPressed)];
//    UIBarButtonItem *callButton = [ViewControllerUtil createBarButton:@"button_call_header" onTarget:self withSelector:@selector(callPressed)];
    
    chatButton.imageInsets = UIEdgeInsetsMake(0, 10, 0, -10);
//    callButton.imageInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    self.navigationItem.rightBarButtonItems = @[chatButton];
    
    _chatBadge = [ViewControllerUtil createBadgeWithText:@"0" atX:300 andY:5];
    [self.navigationController.navigationBar addSubview:_chatBadge];
    [_chatBadge setHidden:YES];

    [PushNotificationDataInterface addMessageObserver:self andSelector:@selector(apsMessageReceived:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self refreshBadge];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_chatBadge setHidden:YES];
}

- (void)apsMessageReceived:(NSNotification*)notification
{
    [self refreshBadge];
}

// Change the badge number on the Chat button
- (void)refreshBadge
{
    NSInteger count = [LocalDataInterface obtainNewNotificationCount];
    _chatBadge.text = [NSString stringWithFormat:@"%ld", count];
    [_chatBadge setHidden:count == 0 && self.navigationItem.rightBarButtonItems.count == 2];
}

// Invoked by the subclasses HomeViewController, NotificationsViewController,
// CrossPollinateViewController, ProfileViewController, TransactionViewController.
- (void)addSearchDelegate:(UISearchBar *)searchBar
{
    _searchBar = searchBar;
    
    UIColor *searchBarBorderColor = [UIColor colorWithRed:236.0/255 green:240.0/255 blue:248.0/255 alpha:1.0];
    searchBar.layer.borderColor = searchBarBorderColor.CGColor;
    searchBar.layer.borderWidth = 1.0;

    _searchBar.delegate = self;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)]];
}

// Invoked by the subclasses HomeViewController, NotificationsViewController,
// CrossPollinateViewController, ProfileViewController, TransactionViewController.
- (void)prepareStartSelling
{
    UIViewController *vc = ![ViewControllerUtil isLoggedIn] ?
        [ViewControllerUtil instantiateEntryView] :
        [UserSkillViewController1 instantiateForInfo:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Search Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [SellerCollectionViewController setSearchText:searchBar.text];
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"seller_view_controller"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO];
    [searchBar endEditing:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO];
}



- (IBAction)callPressed
{
    NSLog(@"Call Pressed");
}

- (IBAction)chatPressed
{
    NSLog(@"chat pressed");
    
    ChatListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"chat_list_view_controller"];
    [self.navigationController pushViewController:controller animated:YES];
    
    
//    UIViewController *vc = ![ViewControllerUtil isLoggedIn] ? [ViewControllerUtil instantiateEntryView] :
//    [ViewControllerUtil instantiateViewController:@"chat_list_view_controller"];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tapDetected:(UITapGestureRecognizer *)sender
{
    [_searchBar resignFirstResponder];
}

@end
