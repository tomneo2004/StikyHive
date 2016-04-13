//
//  ChatListViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 18/1/16.
//  Copyright (c) 2016 Stiky Hive. All rights reserved.
//

#import "ChatListViewController.h"
#import "WebDataInterface.h"
#import "LocalDataInterface.h"
#import "ViewControllerUtil.h"
#import "UIView+RNActivityView.h"
#import "ChatMessagesViewController.h"

@interface ChatListViewController ()

@property (nonatomic, strong) NSArray *contactsList;

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _chatTableView.delegate = self;
    _chatTableView.dataSource = self;
    [self setTitle:@"Stiky Chat"];
    
    _chatTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero]; //Remove empty cells in UITableView
    
    }


- (void)viewWillAppear:(BOOL)animated
{
    
    [self.view showActivityViewWithLabel:@"Loading..."];
    
    [WebDataInterface checkLastMessage:[LocalDataInterface retrieveStkid] completion:^(NSObject *obj, NSError *err) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *dict = (NSDictionary *)obj;
            if (dict && [dict[@"status"] isEqualToString:@"success"])
            {
                
                _contactsList = dict[@"contacts"];
                
                NSLog(@"contacts list --- %@",_contactsList);
                
                [_chatTableView reloadData];
                
//                [self.view hideActivityView];
//                
//                return;
                
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No data were found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                
                [self.navigationController popViewControllerAnimated:YES];

            }
            
            
            [self.view hideActivityView];
        });
        
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 


#pragma mark - table view datasource -- delegate 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contactsList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChatCell"];
    }
    
    NSDictionary *dict = _contactsList[indexPath.row];
    
    UIImageView *headImageView = (UIImageView *)[cell viewWithTag:CHAT_TABLE_VIEW_IMAGE_VIEW_TAG];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:CHAT_TABLE_VIEW_NAME_LABEL_TAG];
    UILabel *msgLabel = (UILabel *)[cell viewWithTag:CHAT_TABLE_VIEW_MSG_LABLE_TAG];
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:CHAT_TABLE_VIEW_TIME_LABLE_TAG];
    
    
    NSString *url = [WebDataInterface getFullUrlPath:dict[@"profilePicture"]];
    headImageView.image = [ViewControllerUtil getImageWithPath:url];
    
    NSString *updateString = dict[@"updateDate"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate *updateDate = [formatter dateFromString:updateString];
    
    NSString *updateDay= @"";
    
    BOOL today = [[NSCalendar currentCalendar] isDateInToday:updateDate];
    
    if (today)
    {
        [formatter setDateFormat:@"hh:mm a"];
        updateDay = [formatter stringFromDate:updateDate];
    }
    else
    {
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
         updateDay = [formatter stringFromDate:updateDate];
    }
    
    nameLabel.text = [NSString stringWithFormat:@"%@ %@",dict[@"firstname"],dict[@"lastname"]];
    msgLabel.text = [dict[@"message"] isEqual:[NSNull null]]?@"":dict[@"message"];
    timeLabel.text = updateDay;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *dict = _contactsList[indexPath.row][@"toStikyBee"];
    
    NSString *toStikyBee = _contactsList[indexPath.row][@"chatStkid"];
    
    NSString *fullName = [NSString stringWithFormat:@"%@ %@",_contactsList[indexPath.row][@"firstname"],_contactsList[indexPath.row][@"lastname"]];
    
    NSArray *beeInfo = [NSArray arrayWithObjects:_contactsList[indexPath.row][@"chatStkid"],fullName,_contactsList[indexPath.row][@"profilePicture"], nil];
    
    [self showChatMessagesView:toStikyBee infoArray:beeInfo];
    //    chat_messages_view_controller
    
//    ChatMessagesViewController *cmvc = [ChatMessagesViewController messagesViewController];
//    [self.navigationController pushViewController:cmvc animated:YES];
//    
    
    
    NSLog(@"select chat --- %@",toStikyBee);

}

- (void)showChatMessagesView:(NSString *)userID infoArray:(NSArray *)infoArray
{
    [ChatMessagesViewController setToStikyBee:userID];
    
    
    [ChatMessagesViewController setToStikyBeeInfoArray:infoArray];
    
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
