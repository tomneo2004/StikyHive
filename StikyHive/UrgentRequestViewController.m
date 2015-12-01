//
//  UrgentRequestViewController.m
//  StikyHive
//
//  Created by User on 17/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "UrgentRequestViewController.h"
#import "WebDataInterface.h"
#import "UrgentRequest.h"
#import "UIView+RNActivityView.h"
#import "AttachmentViewController.h"
#import "RequestPostTableViewController.h"
#import "LocalDataInterface.h"
#import "ViewControllerUtil.h"
#import "UserProfileViewController.h"


@interface UrgentRequestViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UrgentRequestViewController{
    
    NSMutableArray *_urgentRequests;
}

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //start pulling data from server
    [self pullData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Internal
- (void)pullData{
    
    [self.view showActivityViewWithLabel:@"Refreshing..." detailLabel:@"Fetching data"];
    
    //urgent request for all rows of data
    [WebDataInterface getUrgentRequest:0 stkid:@"" completion:^(NSObject *obj, NSError *error){
        
        //we need to run it on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error == nil){
                
                NSDictionary *dic = (NSDictionary *)obj;
                
                _urgentRequests = nil;
                _urgentRequests = [[NSMutableArray alloc] init];
                
                for(NSDictionary *data in dic[@"result"]){
                    
                    [_urgentRequests addObject:[UrgentRequest createUrgentRequestFromDictionary:data]];
                }
                
                [_tableView reloadData];
                
                
            }
            
            [self.view hideActivityView];
        });
        
    }];
}

-(Request *)requestByIndexPath:(NSIndexPath *)indexPath{
    
    Request *request = [_urgentRequests objectAtIndex:indexPath.row];
    
    return request;
}

#pragma mark - UITableViewDataSource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_urgentRequests) {
        
        return _urgentRequests.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"UrgentRequestCell";
    
    UrgentRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil){
        
        cell = [[UrgentRequestCell alloc] init];
    }
    
    UrgentRequest *urgentRequest = [_urgentRequests objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = urgentRequest.title;
    cell.descLabel.text = urgentRequest.desc;
    cell.isMyRequest = [urgentRequest.stkId isEqualToString:[LocalDataInterface retrieveStkid]];
    cell.delegate = self;
    [cell displayProfilePictureWithURL:urgentRequest.profilePicture];
    
    return cell;
}

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"select row at %li in section %li", (long)indexPath.row, (long)indexPath.section);
    
    Request *request = [_urgentRequests objectAtIndex:indexPath.row];
    
    RequestPostTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RequestPostTableViewController"];
    
    controller.request = request;
    
    [self.navigationController pushViewController:controller animated:YES];
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
    
    //present user profile controller
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"user_profile_view_controller"];
    UserProfileViewController *svc = (UserProfileViewController *)vc;
    [svc setStkID:urgentRequest.stkId];
    
    [self.navigationController pushViewController:svc animated:YES];
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
