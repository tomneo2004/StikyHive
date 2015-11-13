//
//  CrossPollinateViewController.m
//  StikyHive
//
//  Created by User on 12/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "CrossPollinateViewController.h"
#import "WebDataInterface.h"
#import "Request.h"

@interface CrossPollinateViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CrossPollinateViewController{
    
    NSMutableArray *_urgentRequests;
}

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //request for 3 rows of data
    [WebDataInterface getUrgentRequest:0 stkid:@"" completion:^(NSObject *obj, NSError *error){
        
        //we need to run it on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error == nil){
                
                NSDictionary *dic = (NSDictionary *)obj;
                
                //clean data
                _urgentRequests = nil;
                _urgentRequests = [[NSMutableArray alloc] init];
                
                for(NSDictionary *data in dic[@"result"]){
                    
                    [_urgentRequests addObject:[Request createRequestFromDictionary:data]];
                }
                
                [_tableView reloadData];
            }
        });
        
    }];
    
    
}

#pragma mark - UITableViewSouceData delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_urgentRequests){
        
        return _urgentRequests.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"RequestCell";
    
    RequestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil){
        
        cell = [[RequestCell alloc] init];
    }
    
    Request *urgenRequest = [_urgentRequests objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = urgenRequest.title;
    cell.descLabel.text = urgenRequest.desc;
    cell.delegate = self;
    [cell displayProfilePictureWithURL:urgenRequest.profilePicture withUniqueId:[NSString stringWithFormat:@"%li",urgenRequest.cpId]];
    
    return cell;
}

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"select row at %li", indexPath.row);
}

#pragma mark - RequestCell delegate
- (void)requestCellDidTapImageAttachment:(RequestCell *)requestCell{
    
    NSLog(@"on image attachment");
}

- (void)requestCellDidTapVoiceCommunication:(RequestCell *)requestCell{
    
    NSLog(@"on voice communication");
}

- (void)requestCellDidTapChat:(RequestCell *)requestCell{
    
    NSLog(@"on chat");
}

- (void)requestCellDidTapPersonAvatar:(RequestCell *)requestCell{
    
    NSLog(@"on person avatar");
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
