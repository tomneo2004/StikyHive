//
//  JobHistoryViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 5/1/16.
//  Copyright (c) 2016 Stiky Hive. All rights reserved.
//

#import "JobHistoryViewController.h"
#import "WebDataInterface.h"
#import "LocalDataInterface.h"
#import "UIView+RNActivityView.h"

@interface JobHistoryViewController ()

@property (nonatomic, strong) NSArray *historyArray;

@end

@implementation JobHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view showActivityViewWithLabel:@"Loading..."];
    
    [WebDataInterface getStikyBeeInfo:[LocalDataInterface retrieveStkid] completion:^(NSObject *obj, NSError *err) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (err == nil) {
                NSDictionary *dict = (NSDictionary *)obj;
                
                _historyArray = dict[@"jobhistory"];
                
                
                [_jobTableView reloadData];
                
            }
            
            [self.view hideActivityView];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _historyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"JobHistoryCell";
    
    JobHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[JobHistoryCell alloc] init];
    }
    
    NSDictionary *job = _historyArray[indexPath.row];
//    job[@"companyName"] job[@"countryName"]
//    job[@"jobtitle"]
//    job[@"fromDate"] job[@"toDate"]
    
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)addNewBtnTapped:(id)sender {
}
@end
