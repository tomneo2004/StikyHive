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

@interface CrossPollinateViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation CrossPollinateViewController{
    
    NSMutableArray *_sections;
    UrgentSectionTitle *_urgentSectionTitleView;
    MyRequestSectionTitle *_myRequestSectionTitleView;
}

@synthesize tableView = _tableView;
@synthesize searchBar = _searchBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"My stkid is %@", [LocalDataInterface retrieveStkid]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self pullData];
}

#pragma mark - Internal
- (void)pullData{
    
    _sections = nil;
    _sections = [[NSMutableArray alloc] init];
    
    [self.view showActivityViewWithLabel:@"Refreshing..." detailLabel:@"Fetching data"];
    
    //urgent request for 3 rows of data
    [WebDataInterface getUrgentRequest:3 stkid:@"" completion:^(NSObject *obj, NSError *error){
        
        //we need to run it on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error == nil){
                
                NSDictionary *dic = (NSDictionary *)obj;
                
                NSMutableArray *urgentRequests = [[NSMutableArray alloc] init];
                
                for(NSDictionary *data in dic[@"result"]){
                    
                    [urgentRequests addObject:[UrgentRequest createUrgentRequestFromDictionary:data]];
                }
                
                Section *urgentSection = [[Section alloc] initWithDataArray:urgentRequests];
                
                [_sections addObject:urgentSection];
                
                
                [WebDataInterface getUrgentRequest:3 stkid:[LocalDataInterface retrieveStkid] completion:^(NSObject *obj, NSError *error){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        if(error == nil){
                            
                            NSDictionary *dic = (NSDictionary *)obj;
                            
                            NSMutableArray *myRequests = [[NSMutableArray alloc] init];
                            
                            for(NSDictionary *data in dic[@"result"]){
                                
                                [myRequests addObject:[MyRequest createMyRequestFromDictionary:data]];
                            }
                            
                            Section *myRequestSection = [[Section alloc] initWithDataArray:myRequests];
                            
                            [_sections addObject:myRequestSection];
                            
                            [_tableView reloadData];
                            
                            
                        }
                        
                        [self.view hideActivityView];
                    });
                }];
            }
        });
        
    }];
}

-(Request *)requestByIndexPath:(NSIndexPath *)indexPath{
    
    Section *s = [_sections objectAtIndex:indexPath.section];
    Request *request = [s.dataArray objectAtIndex:indexPath.row];
    
    return request;
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
    
    Request *request = [s.dataArray objectAtIndex:indexPath.row];
    
    if([request isKindOfClass:[UrgentRequest class]]){
        
        static NSString *cellId = @"UrgentRequestCell";
        
        UrgentRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if(cell == nil){
            
            cell = [[UrgentRequestCell alloc] init];
        }
        
        UrgentRequest *urgentRequest = (UrgentRequest *)request;
        
        cell.titleLabel.text = urgentRequest.title;
        cell.descLabel.text = urgentRequest.desc;
        cell.delegate = self;
        [cell displayProfilePictureWithURL:urgentRequest.profilePicture];
        
        return cell;
    }
    
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
    
    RequestPostTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RequestPostTableViewController"];
    
    controller.request = request;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    Section *s = [_sections objectAtIndex:section];
    
    if([s isSectionAClass:[UrgentRequest class]]){
        
        if(_urgentSectionTitleView == nil){
            
            _urgentSectionTitleView = (UrgentSectionTitle *)[Helper viewFromNib:@"UrgentSectionTitle" atViewIndex:0 owner:self];
        }
        
        _urgentSectionTitleView.delegate = self;
        
        return _urgentSectionTitleView;
    }
    
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
    
    if([s isSectionAClass:[UrgentRequest class]]){
        
        if(_urgentSectionTitleView == nil){
            
            _urgentSectionTitleView = (UrgentSectionTitle *)[Helper viewFromNib:@"UrgentSectionTitle" atViewIndex:0 owner:self];
        }
        
        _urgentSectionTitleView.delegate = self;
        
        return _urgentSectionTitleView.bounds.size.height;
    }
    
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
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"user_profile_view_controller"];
    UserProfileViewController *svc = (UserProfileViewController *)vc;
    [svc setStkID:urgentRequest.stkId];
    
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - MyRequestCell delegate
- (void)myRequestCellDidTapPersonAvatar:(MyRequestCell *)requestCell{
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:requestCell];
    
    MyRequest *myRequest = (MyRequest *)[self requestByIndexPath:indexPath];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
