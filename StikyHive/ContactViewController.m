//
//  ContactViewController.m
//  StikyHive
//
//  Created by User on 4/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "ContactViewController.h"
#import "ContactInfo.h"
#import "WebDataInterface.h"
#import "UIView+RNActivityView.h"
#import "LocalDataInterface.h"
#import "ChatMessagesViewController.h"

@interface ContactViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ContactViewController{
    
    NSMutableArray *_contactInfos;
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

#pragma mark - internal
- (void)pullData{
    
    [self.view showActivityViewWithLabel:@"Refreshing..." detailLabel:@"Fetching data"];
    [WebDataInterface selectContacts:[LocalDataInterface retrieveStkid] completion:^(NSObject *obj, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error != nil){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to get data!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                
            }
            else{
                
                NSDictionary *dic = (NSDictionary *)obj;
                
                if(((NSArray *)dic[@"resultContacts"]).count <=0){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No result" message:@"No contacts!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                }
                else{
                    
                    _contactInfos = [[NSMutableArray alloc] init];
                    
                    for(NSDictionary *data in dic[@"resultContacts"]){
                        
                        ContactInfo *info = [ContactInfo createContactInfoFromDictionary:data];
                        [_contactInfos addObject:info];
                    }
                    
                    [_tableView reloadData];
                    
                    [self.view hideActivityView];
                    
                    return;
                }
                
            }
            
            [self.view hideActivityView];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        });
    }];
}

#pragma mark - UITableViewDataSource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_contactInfos != nil){
        
        return _contactInfos.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"ContactCell";
    
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil){
        
        cell = [[ContactCell alloc] init];
    }
    
    ContactInfo *info = [_contactInfos objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", info.firstName, info.lastName];
    cell.delegate = self;
    [cell displayProfilePictureWithURL:info.photoPicture];
    
    return cell;
}

#pragma  mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark - ContactCell delegate
- (void)onPhoneCallTap:(ContactCell *)cell{
    
}

- (void)onChatTap:(ContactCell *)cell{
    
     NSInteger index = [_tableView indexPathForCell:cell].row;
    
    ContactInfo *info = [_contactInfos objectAtIndex:index];
    
    [ChatMessagesViewController setToStikyBee:info.stkId];
    ChatMessagesViewController *cmvc = [ChatMessagesViewController messagesViewController];
    [self.navigationController pushViewController:cmvc animated:YES];
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
