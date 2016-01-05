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
#import "ViewControllerUtil.h"

@interface JobHistoryViewController ()

@property (nonatomic, strong) NSArray *historyArray;

@end

@implementation JobHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _jobTableView.delegate = self;
    _jobTableView.dataSource = self;
    
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
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    NSString *fromDateString = job[@"fromDate"];
    NSString *toDate = job[@"toDate"];

    if (toDate == (id)[NSNull null]) {
        NSDate *today = [NSDate date];
        [formate setDateFormat:@"MMM yyyy"];
        toDate = [formate stringFromDate:today];
        
        [formate setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        NSDate *fromDateDt = [formate dateFromString:fromDateString];
        [formate setDateFormat:@"MMM yyyy"];
        fromDateString = [formate stringFromDate:fromDateDt];

    }
    else
    {
        [formate setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        NSDate *fromDateDt = [formate dateFromString:fromDateString];
        NSDate *toDateDt = [formate dateFromString:toDate];
        [formate setDateFormat:@"MMM yyyy"];
        fromDateString = [formate stringFromDate:fromDateDt];
        toDate = [formate stringFromDate:toDateDt];
    }
    
    
    cell.countryLabel.text = [NSString stringWithFormat:@"%@, %@",job[@"companyName"],job[@"countryName"]];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",job[@"jobtitle"]];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@ - %@",fromDateString,toDate];
    
    NSLog(@"");
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - JobHistoryCell delegate
- (void)onEdit:(JobHistoryCell *)cell
{
    
}

- (void)onDelete:(JobHistoryCell *)cell
{
    
}

- (IBAction)addNewBtnTapped:(id)sender
{
    
//
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"add_job_view_controller"];
    [self.navigationController pushViewController:vc animated:YES];

    
}
@end
