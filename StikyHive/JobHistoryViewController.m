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
#import "JobInfo.h"

@interface JobHistoryViewController ()


@end

@implementation JobHistoryViewController {
    NSMutableArray *_jobInfoArray;
    NSInteger _tmpDeleteIndex;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _jobTableView.delegate = self;
    _jobTableView.dataSource = self;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.tabBarController.tabBar.hidden = YES;
    
    
    [self.view showActivityViewWithLabel:@"Loading..."];
    
    [WebDataInterface getStikyBeeInfo:[LocalDataInterface retrieveStkid] completion:^(NSObject *obj, NSError *err) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (err != nil)
            {
                [ViewControllerUtil showAlertWithTitle:@"Error" andMessage:@"Unable to get data!"];
            }
            else
            {
                NSDictionary *dict = (NSDictionary *)obj;
                
                NSLog(@"job array dict --- %@",dict);
                
                if ((NSArray *)dict[@"jobhistory"] == (id)[NSNull null])
                {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No result" message:@"No job history information!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
                    
                    
                }
                else
                {
                
                    _jobInfoArray = [[NSMutableArray alloc] init];
                    for (NSDictionary *data in dict[@"jobhistory"])
                    {
                        JobInfo *info = [JobInfo createJobInfoFromDictionary:data];
                        [_jobInfoArray addObject:info];
//                      NSLog(@"job talbe ---- %@",info);
                    }
                
                    [_jobTableView reloadData];
                
                
                    [self.view hideActivityView];
                    
                    return;
                    
                }
  
            }
            
            [self.view hideActivityView];
            
            [self.navigationController popViewControllerAnimated:YES];
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
    if (_jobInfoArray != nil)
    {
        return _jobInfoArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId = @"JobHistoryCell";
    
    JobHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[JobHistoryCell alloc] init];
    }
    
    JobInfo *info = [_jobInfoArray objectAtIndex:indexPath.row];
    
//    NSDictionary *job = _jobInfoArray[indexPath.row];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    NSString *fromDateString = info.originalFromDate;
    NSString *toDate = info.originalToDate;

    if (toDate == (id)[NSNull null])
    {
//        NSDate *today = [NSDate date];
//        [formate setDateFormat:@"MMM yyyy"];
//        toDate = [formate stringFromDate:today];
//        
        [formate setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        NSDate *fromDateDt = [formate dateFromString:fromDateString];
        [formate setDateFormat:@"MMM yyyy"];
        fromDateString = [formate stringFromDate:fromDateDt];
        
        toDate = @"Present";

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
    
    
    cell.countryLabel.text = [NSString stringWithFormat:@"%@, %@",info.companyName,info.countryName];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",info.jobTitle];
    cell.timeLable.text = [NSString stringWithFormat:@"%@ - %@",fromDateString,toDate];
    cell.delegate = self;
    
    
    return cell;
    
}


#pragma mark - JobHistoryCell delegate
- (void)onEdit:(JobHistoryCell *)cell
{
    
    NSInteger index = [_jobTableView indexPathForCell:cell].row;
    JobInfo *jobInfo = [_jobInfoArray objectAtIndex:index];
    
    NSLog(@"job info index --- %@",jobInfo);
    
    AddJobViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"add_job_view_controller"];
    vc.jobInfo = jobInfo;
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onDelete:(JobHistoryCell *)cell
{
    _tmpDeleteIndex = [_jobTableView indexPathForCell:cell].row;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Do you want to delete this job?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alert show];
    
}

- (void)onUpdateJobSuccessful{
    
}

- (void)onAddNewJobSuccessful{
    
}

- (IBAction)addNewBtnTapped:(id)sender
{
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"add_job_view_controller"];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        
        JobInfo *info = [_jobInfoArray objectAtIndex:_tmpDeleteIndex];
        
        [self.view showActivityViewWithLabel:@"Deleting..."];
        [WebDataInterface deleteJob:info.jobId completion:^(NSObject *obj, NSError *err) {
        
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.view hideActivityView];
                
                if(err != nil){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to delete job!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                else{
                    
                    [_jobInfoArray removeObjectAtIndex:_tmpDeleteIndex];
                    [_jobTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_tmpDeleteIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                    
                }
                
            });
            
        }];
    }

}

@end
