//
//  EducationViewController.m
//  StikyHive
//
//  Created by User on 5/1/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "EducationViewController.h"
#import "UIView+RNActivityView.h"
#import "EducationInfo.h"
#import "WebDataInterface.h"
#import "LocalDataInterface.h"

@interface EducationViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EducationViewController{
    
    NSMutableArray *_educationInfos;
     NSDateFormatter *_dateFormatter;
}

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"MMM yyyy"];
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
    [WebDataInterface getStikyBeeInfo:[LocalDataInterface retrieveStkid] completion:^(NSObject *obj, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error != nil){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to get data!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                
            }
            else{
                
                NSDictionary *dic = (NSDictionary *)obj;
                
                if(((NSArray *)dic[@"education"]).count <=0){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No result" message:@"No education information!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                }
                else{
                    
                    _educationInfos = [[NSMutableArray alloc] init];
                    
                    for(NSDictionary *data in dic[@"education"]){
                        
                        EducationInfo *info = [EducationInfo createEducationInfoFromDictionary:data];
                        [_educationInfos addObject:info];
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

#pragma mark - IBAction
- (IBAction)addNewEducation:(id)sender{
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_educationInfos != nil){
        
        return _educationInfos.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"EducationCell";
    
    EducationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil){
        
        cell = [[EducationCell alloc] init];
    }
    
    EducationInfo *info = [_educationInfos objectAtIndex:indexPath.row];
    
    cell.instituteLabel.text = [NSString stringWithFormat:@"%@, %@", info.institute, info.countryName];
    cell.qualificationLabel.text = info.qualification;
    cell.dateLabel.text = [NSString stringWithFormat:@"%@ - %@", [_dateFormatter stringFromDate:info.fromDate], [_dateFormatter stringFromDate:info.toDate]];
    
    return cell;
}

#pragma mark - EducationCell delegate
- (void)onEdit:(EducationCell *)cell{
    
}

- (void)onDelete:(EducationCell *)cell{
    
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
