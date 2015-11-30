//
//  CrossPollinateViewController.m
//  StikyHive
//
//  Created by User on 12/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "CrossPollinateViewController.h"
#import "WebDataInterface.h"
#import "LocalDataInterface.h"
#import "Helper.h"
#import "UrgentRequest.h"
#import "MyRequest.h"
#import "Section.h"
#import "AttachmentViewController.h"
#import "UIView+RNActivityView.h"
#import "ViewControllerUtil.h"
#import "UserProfileViewController.h"
#import "RequestPostTableViewController.h"
#import "SkillInfo.h"
#import "DistanceSkill.h"
#import "SearchResultTableViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface CrossPollinateViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIImageView *postARequestImageView;

@end

@implementation CrossPollinateViewController{
    
    //contain Section, look Section class
    NSMutableArray *_sections;
    
    //the title View for urgent section in table view
    UrgentSectionTitle *_urgentSectionTitleView;
    
    //the title View for my request section in table view
    MyRequestSectionTitle *_myRequestSectionTitleView;
    
    //user's geo location
    CLLocation *_myLocation;
}

@synthesize tableView = _tableView;
@synthesize searchBar = _searchBar;
@synthesize postARequestImageView = _postARequestImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"My stkid is %@", [LocalDataInterface retrieveStkid]);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postRequest:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    
    [_postARequestImageView addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //pull data from server
    [self pullData];
}

#pragma mark - Internal
- (void)postRequest:(UIGestureRecognizer *)recognizer{

    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PrepareRequestViewController"];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pullData{
    
    //remove old data
    _sections = nil;
    _sections = [[NSMutableArray alloc] init];
    
    //show activity
    [self.view showActivityViewWithLabel:@"Refreshing..." detailLabel:@"Fetching data"];
    
    //urgent request of 3 rows of data
    [WebDataInterface getUrgentRequest:3 stkid:@"" completion:^(NSObject *obj, NSError *error){
        
        //we need to run it on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error == nil){
                
                NSDictionary *dic = (NSDictionary *)obj;
                
                NSMutableArray *urgentRequests = [[NSMutableArray alloc] init];
                
                for(NSDictionary *data in dic[@"result"]){
                    
                    [urgentRequests addObject:[UrgentRequest createUrgentRequestFromDictionary:data]];
                }
                
                //use section to hold all urgent requests
                Section *urgentSection = [[Section alloc] initWithDataArray:urgentRequests];
                
                [_sections addObject:urgentSection];
                
                //my request of 3 row of data
                [WebDataInterface getUrgentRequest:3 stkid:[LocalDataInterface retrieveStkid] completion:^(NSObject *obj, NSError *error){
                    
                    //we need to run it on main thread
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        if(error == nil){
                            
                            NSDictionary *dic = (NSDictionary *)obj;
                            
                            NSMutableArray *myRequests = [[NSMutableArray alloc] init];
                            
                            for(NSDictionary *data in dic[@"result"]){
                                
                                [myRequests addObject:[MyRequest createMyRequestFromDictionary:data]];
                            }
                            
                            //use section to hold all my requests
                            Section *myRequestSection = [[Section alloc] initWithDataArray:myRequests];
                            
                            [_sections addObject:myRequestSection];
                            
                            //reload table view
                            [_tableView reloadData];
                            
                            
                        }
                        
                        //hide activity
                        [self.view hideActivityView];
                    });
                }];
            }
        });
        
    }];
}

/**
 * Get request by IndexPath
 */
-(Request *)requestByIndexPath:(NSIndexPath *)indexPath{
    
    Section *s = [_sections objectAtIndex:indexPath.section];
    Request *request = [s.dataArray objectAtIndex:indexPath.row];
    
    return request;
}

- (void)beginSearchNearbyWithKeyword:(NSString *)keyword{
    
    if(keyword != nil && keyword.length > 0){
        
        [self.view showActivityViewWithLabel:@"Searching..."];
        
        //if user's geo location is nil we need to get user's location first
        if(_myLocation == nil){
            
            //get user's geo location
            [WebDataInterface getMyLocation:[LocalDataInterface retrieveStkid] completion:^(NSObject *obj, NSError *error){
                
                //we need to run it on main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(error == nil){
                        
                        NSDictionary *dic = (NSDictionary *)obj;
                        NSDictionary *result = [dic objectForKey:@"result"];
                        
                        //use CLLocation to hold info about user geo location
                        _myLocation = [[CLLocation alloc] initWithLatitude:[[result objectForKey:@"xCoord"] doubleValue] longitude:[[result objectForKey:@"yCoord"] doubleValue]];
                        
                        //start search nearby skill
                        [self doSearchNearbyWithKeyword:keyword];
                    }
                    else{
                        
                        [self.view hideActivityView];
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to get geo location" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                        [alert show];
                    }
                });
                
            }];
        }
        else{
            
            [self doSearchNearbyWithKeyword:keyword];
        }
        
    }
}

- (void)doSearchNearbyWithKeyword:(NSString *)keyword{
    
    //search nearby skill
    [WebDataInterface searchNearByCp:[LocalDataInterface retrieveStkid] skillname:keyword completion:^(NSObject *obj, NSError *error){
        
        //we need to run it on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error == nil){
                
                NSDictionary *dic = (NSDictionary *)obj;
                NSDictionary *result = [dic objectForKey:@"result"];
                
                //create DistanceSkill that are categorized by 500, 1000, 2000, 3000, 4000 and 5000 meters
                DistanceSkill *dSkill500 = [DistanceSkill createDistanceSkillWithDistance:500.0f];
                DistanceSkill *dSkill1000 = [DistanceSkill createDistanceSkillWithDistance:1000.0f];
                DistanceSkill *dSkill2000 = [DistanceSkill createDistanceSkillWithDistance:2000.0f];
                DistanceSkill *dSkill3000 = [DistanceSkill createDistanceSkillWithDistance:3000.0f];
                DistanceSkill *dSkill4000 = [DistanceSkill createDistanceSkillWithDistance:4000.0f];
                DistanceSkill *dSkill5000 = [DistanceSkill createDistanceSkillWithDistance:5000.0f];
                NSMutableArray *distSkills = [[NSMutableArray alloc] initWithObjects:
                                              dSkill500,
                                              dSkill1000,
                                              dSkill2000,
                                              dSkill3000,
                                              dSkill4000,
                                              dSkill5000,
                                              nil];
                
                int resultCount = 0;
                
                //for each nearby skills we found, put them into right DistanceSkill
                for (NSDictionary *data in result) {
                    
                    SkillInfo *info = [SkillInfo createSkillInfoFromDictionary:data];
                    
                    float dist = [self calculateGEODistFromLocation:_myLocation toLocation:info.geoLocation];
                    [info setDistanceFromFinder:dist];
                    
                    if(dist <= 500){
                        
                        [dSkill500 addSkill:info];
                        resultCount++;
                    }
                    else if(dist <=1000){
                        
                        [dSkill1000 addSkill:info];
                        resultCount++;
                    }
                    else if(dist <= 2000){
                        
                        [dSkill2000 addSkill:info];
                        resultCount++;
                    }
                    else if(dist <= 3000){
                        
                        [dSkill3000 addSkill:info];
                        resultCount++;
                    }
                    else if(dist <=4000){
                        
                        [dSkill4000 addSkill:info];
                        resultCount++;
                    }
                    else if(dist <= 5000){
                        
                        [dSkill5000 addSkill:info];
                        resultCount++;
                    }
                }
                
                if(resultCount > 0){
                    
                    NSMutableArray *removedObj = [[NSMutableArray alloc] init];
                    
                    //check if DistanceSkill has no skill and put into removed array
                    for(DistanceSkill *dSkill in distSkills){
                        
                        if(dSkill.allSkills.count <= 0){
                            
                            [removedObj addObject:dSkill];
                        }
                    }
                    
                    //remove empty DistanceSkill
                    for(DistanceSkill *empty in removedObj){
                        
                        [distSkills removeObject:empty];
                    }
                    
                    //present SearchResult controller
                    SearchResultTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultTableViewController"];
                    controller.searchResult = distSkills;
                    [self.navigationController pushViewController:controller animated:YES];
                    
                    [self.view hideActivityView];
                }
                else{
                    
                    [self.view hideActivityView];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No result" message:@"No search result were found" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];
                    
                }
                
            }
            else{
                
                [self.view hideActivityView];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to search" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
        });
        
        
    }];
}

/**
 * Calculate distance of two geo location
 */
- (float)calculateGEODistFromLocation:(CLLocation *)fromLocation toLocation:(CLLocation *)toLocation{
    
    return (float)[fromLocation distanceFromLocation:toLocation];
}


#pragma mark - UITableViewSouceData delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if(_sections){
        
        return _sections.count;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    Section *s = [_sections objectAtIndex:section];
    
    if(s){
        
        return s.dataArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Section *s = [_sections objectAtIndex:indexPath.section];
    
    //use Request type to determine which cell need to present
    Request *request = [s.dataArray objectAtIndex:indexPath.row];
    
    //if cell is UrgentRequest
    if([request isKindOfClass:[UrgentRequest class]]){
        
        static NSString *cellId = @"UrgentRequestCell";
        
        UrgentRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if(cell == nil){
            
            cell = [[UrgentRequestCell alloc] init];
        }
        
        UrgentRequest *urgentRequest = (UrgentRequest *)request;
        
        cell.titleLabel.text = urgentRequest.title;
        cell.descLabel.text = urgentRequest.desc;
        cell.isMyRequest = [urgentRequest.stkId isEqualToString:[LocalDataInterface retrieveStkid]];
        cell.delegate = self;
        [cell displayProfilePictureWithURL:urgentRequest.profilePicture];
        
        return cell;
    }
    
    //if cell is MyRequest
    if([request isKindOfClass:[MyRequest class]]){
        
        static NSString *cellId = @"MyRequestCell";
        
        MyRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if(cell == nil){
            
            cell = [[MyRequestCell alloc] init];
        }
        
        MyRequest *myRequest = (MyRequest *)request;
        
        cell.titleLabel.text = myRequest.title;
        cell.descLabel.text = myRequest.desc;
        cell.delegate = self;
        [cell displayProfilePictureWithURL:myRequest.profilePicture];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"select row at %li in section %li", (long)indexPath.row, (long)indexPath.section);
    
    Section *s = [_sections objectAtIndex:indexPath.section];
    Request *request = [s.dataArray objectAtIndex:indexPath.row];
    
    //Present request post controller
    RequestPostTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RequestPostTableViewController"];
    
    controller.request = request;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    Section *s = [_sections objectAtIndex:section];
    
    //if section is UrgentRequest
    if([s isSectionAClass:[UrgentRequest class]]){
        
        if(_urgentSectionTitleView == nil){
            
            _urgentSectionTitleView = (UrgentSectionTitle *)[Helper viewFromNib:@"UrgentSectionTitle" atViewIndex:0 owner:self];
        }
        
        _urgentSectionTitleView.delegate = self;
        
        return _urgentSectionTitleView;
    }
    
    //if section is MyRequest
    if([s isSectionAClass:[MyRequest class]]){
        
        if(_myRequestSectionTitleView == nil){
            
            _myRequestSectionTitleView = (MyRequestSectionTitle *)[Helper viewFromNib:@"MyRequestSectionTitle" atViewIndex:0 owner:self];
        }
        
        _myRequestSectionTitleView.delegate = self;
        
        return _myRequestSectionTitleView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    Section *s = [_sections objectAtIndex:section];
    
    //if section is UrgentRequest
    if([s isSectionAClass:[UrgentRequest class]]){
        
        if(_urgentSectionTitleView == nil){
            
            _urgentSectionTitleView = (UrgentSectionTitle *)[Helper viewFromNib:@"UrgentSectionTitle" atViewIndex:0 owner:self];
        }
        
        _urgentSectionTitleView.delegate = self;
        
        return _urgentSectionTitleView.bounds.size.height;
    }
    
    //if section is MyRequest
    if([s isSectionAClass:[MyRequest class]]){
        
        if(_myRequestSectionTitleView == nil){
            
            _myRequestSectionTitleView = (MyRequestSectionTitle *)[Helper viewFromNib:@"MyRequestSectionTitle" atViewIndex:0 owner:self];
        }
        
        _myRequestSectionTitleView.delegate = self;
        
        return _myRequestSectionTitleView.bounds.size.height;
    }
    
    return 0;
}

#pragma mark - UrgentRequestCell delegate
- (void)urgentRequestCellDidTapImageAttachment:(UrgentRequestCell *)requestCell{
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:requestCell];
    
    UrgentRequest *urgentRequest = (UrgentRequest *)[self requestByIndexPath:indexPath];
    
    //present attachment controller with photo url
    AttachmentViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AttachmentViewController"];
    
    controller.attachmentPhotoURL = urgentRequest.photoLocation;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)urgentRequestCellDidTapVoiceCommunication:(UrgentRequestCell *)requestCell{
    
    NSLog(@"urgent on voice communication");
}

- (void)urgentRequestCellDidTapChat:(UrgentRequestCell *)requestCell{
    
    NSLog(@"urgent on chat");
}

- (void)urgentRequestCellDidTapPersonAvatar:(UrgentRequestCell *)requestCell{
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:requestCell];
    
    UrgentRequest *urgentRequest = (UrgentRequest *)[self requestByIndexPath:indexPath];
    
    //present user profile controller
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"user_profile_view_controller"];
    UserProfileViewController *svc = (UserProfileViewController *)vc;
    [svc setStkID:urgentRequest.stkId];
    
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - MyRequestCell delegate
- (void)myRequestCellDidTapPersonAvatar:(MyRequestCell *)requestCell{
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:requestCell];
    
    MyRequest *myRequest = (MyRequest *)[self requestByIndexPath:indexPath];
    
    //present user profile controller
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"user_profile_view_controller"];
    UserProfileViewController *svc = (UserProfileViewController *)vc;
    [svc setStkID:myRequest.stkId];
    
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)myRequestCellDidTapImageAttachment:(MyRequestCell *)requestCell{
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:requestCell];
    
    MyRequest *myRequest = (MyRequest *)[self requestByIndexPath:indexPath];
    
    AttachmentViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AttachmentViewController"];
    
    controller.attachmentPhotoURL = myRequest.photoLocation;
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UrgentSectionTitle delegate
- (void)urgentSectionSeeAll{
    
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"UrgentRequestViewController"];
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma markl - MyRequestSectionTitle delegate
- (void)myRequestSectionSeeAll{
    
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MyRequestViewController"];
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UISearchBar delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    [self beginSearchNearbyWithKeyword:searchBar.text];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end