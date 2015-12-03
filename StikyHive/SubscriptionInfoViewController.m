//
//  SubscriptionInfoViewController.m
//  StikyHive
//
//  Created by User on 3/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "SubscriptionInfoViewController.h"
#import "WebDataInterface.h"
#import "LocalDataInterface.h"
#import "SubInfo.h"
#import "SubInfoCell.h"
#import "UIView+RNActivityView.h"

@interface SubscriptionInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *stkIdLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SubscriptionInfoViewController{
    
    NSMutableArray *_subInfos;
    NSDateFormatter *_dateFormatter;
}

@synthesize stkIdLabel = _stkIdLabel;
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"dd MMM yyyy"];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    _stkIdLabel.text = [NSString stringWithFormat:@"Your StikyBee ID is STK%@", [LocalDataInterface retrieveStkid]];
    
    [self pullData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    _subInfos = nil;
}

#pragma mark - internal
- (void)pullData{
    
    [self.view showActivityViewWithLabel:@"Refreshing..." detailLabel:@"Fetching data"];
    [WebDataInterface selectSubInfo:[LocalDataInterface retrieveStkid] completion:^(NSObject *obj, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error != nil){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to get data!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                
            }
            else{
                
                NSDictionary *dic = (NSDictionary *)obj;
                
                if(((NSArray *)dic[@"subInfo"]).count <=0){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No result" message:@"No subscription!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                }
                else{
                    
                    _subInfos = [[NSMutableArray alloc] init];
                    
                    for(NSArray *data in dic[@"subInfo"]){
                        
                        SubInfo *info = [SubInfo createSubInfoFromDictionary:data[0]];
                        [_subInfos addObject:info];
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
    
    if(_subInfos != nil){
        
        return _subInfos.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"SubInfoCell";
    
    SubInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil){
        
        cell = [[SubInfoCell alloc] init];
    }
    
    SubInfo *info = [ _subInfos objectAtIndex:indexPath.row];
    
    cell.skillNameLabel.text = info.skillName;
    
    cell.datePostLabel.text = [_dateFormatter stringFromDate:info.issueDate];
    cell.dateExpireLabel.text = [_dateFormatter stringFromDate:info.expireDate];
    
    cell.monthsLeftLabel.text = [NSString stringWithFormat:@"Listing is expiring in %li months", (long)info.duration];
    
    return cell;
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
