//
//  MyRequestViewController.m
//  StikyHive
//
//  Created by User on 17/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "MyRequestViewController.h"
#import "WebDataInterface.h"
#import "LocalDataInterface.h"
#import "MyRequest.h"
#import "UIView+RNActivityView.h"
#import "AttachmentViewController.h"
#import "RequestPostTableViewController.h"

@interface MyRequestViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyRequestViewController{
    
    NSMutableArray *_myRequests;
}

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
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
    [WebDataInterface getUrgentRequest:0 stkid:[LocalDataInterface retrieveStkid] completion:^(NSObject *obj, NSError *error){
        
        //we need to run it on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error == nil){
                
                NSDictionary *dic = (NSDictionary *)obj;
                
                _myRequests = nil;
                _myRequests = [[NSMutableArray alloc] init];
                
                for(NSDictionary *data in dic[@"result"]){
                    
                    [_myRequests addObject:[MyRequest createMyRequestFromDictionary:data]];
                }
                
                [_tableView reloadData];
                
                
            }
            
            [self.view hideActivityView];
        });
        
    }];
}

-(Request *)requestByIndexPath:(NSIndexPath *)indexPath{
    
    Request *request = [_myRequests objectAtIndex:indexPath.row];
    
    return request;
}

#pragma mark - UITableViewDataSource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_myRequests) {
        
        return _myRequests.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"MyRequestCell";
    
    MyRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil){
        
        cell = [[MyRequestCell alloc] init];
    }
    
    MyRequest *myRequest = [_myRequests objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = myRequest.title;
    cell.descLabel.text = myRequest.desc;
    cell.delegate = self;
    [cell displayProfilePictureWithURL:myRequest.profilePicture];
    
    return cell;
}

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"select row at %li in section %li", (long)indexPath.row, (long)indexPath.section);
    
    Request *request = [_myRequests objectAtIndex:indexPath.row];
    
    RequestPostTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RequestPostTableViewController"];
    
    controller.request = request;
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - MyRequestCell delegate
- (void)myRequestCellDidTapPersonAvatar:(MyRequestCell *)requestCell{
    
    NSLog(@"my request on person avatar");
}

- (void)myRequestCellDidTapImageAttachment:(MyRequestCell *)requestCell{
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:requestCell];
    
    MyRequest *myRequest = (MyRequest *)[self requestByIndexPath:indexPath];
    
    AttachmentViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AttachmentViewController"];
    
    controller.attachmentPhotoURL = myRequest.photoLocation;
    
    [self.navigationController pushViewController:controller animated:YES];
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
