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
#import "Helper.h"

@interface EducationViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EducationViewController{
    
    BOOL _shouldUpdate;
    NSMutableArray *_educationInfos;
     NSDateFormatter *_dateFormatter;
    NSInteger _tmpDeleteIndex;
    EmptyEducationView *_emptyView;
}

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Education";
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"MMM yyyy"];
    
    _shouldUpdate = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if(_shouldUpdate)
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
                
                if([((NSArray *)dic[@"education"]) isEqual:[NSNull null]] || ((NSArray *)dic[@"education"]).count <= 0){
                    
                    /*
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No result" message:@"No education information!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                     */
                    
                    [self showEmptyView];
                    
                    return;
                    
                }
                else{
                    
                    [self hideEmptyView];
                    
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

- (void)showEmptyView{
    
    if(_emptyView == nil){
        
        _emptyView = (EmptyEducationView *)[Helper viewFromNib:@"EmptyEducationView" atViewIndex:0 owner:self];
    }
    
    _emptyView.delegate = self;
    
    _emptyView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [self.view addSubview:_emptyView];
}

- (void)hideEmptyView{
    
    if(_emptyView != nil){
        
        [_emptyView removeFromSuperview];
        
        _emptyView = nil;
    }
}

#pragma mark - IBAction
- (IBAction)addNewEducation:(id)sender{
    
    EditEducationTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"EditEducationTableViewController"];
    controller.eduInfo = nil;
    controller.delegate = self;
    
    [self.navigationController pushViewController:controller animated:YES];
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
    cell.delegate = self;
    
    return cell;
}

#pragma mark - EducationCell delegate
- (void)onEdit:(EducationCell *)cell{
    
    NSInteger index = [_tableView indexPathForCell:cell].row;
    EducationInfo *info = [_educationInfos objectAtIndex:index];
    
    EditEducationTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"EditEducationTableViewController"];
    controller.eduInfo = info;
    controller.delegate = self;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onDelete:(EducationCell *)cell{
    
    _tmpDeleteIndex = [_tableView indexPathForCell:cell].row;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Do you want to delete this education?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alert show];
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        
        EducationInfo *info = [_educationInfos objectAtIndex:_tmpDeleteIndex];
        
        [self.view showActivityViewWithLabel:@"Deleting..."];
        [WebDataInterface deleteEducation:info.educationId completion:^(NSObject *obj, NSError *error){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(error != nil){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to delete education!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                else{
                    
                    [_educationInfos removeObjectAtIndex:_tmpDeleteIndex];
                    [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_tmpDeleteIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                
            });
            
        }];
    }
}

#pragma mark - EditEducationTableViewController delegate
- (void)onUpdateEducationSuccessful{
    
    [self pullData];
}

- (void)onAddNewEducationSuccessful{
    
    [self pullData];
}

#pragma mark - UINavigationViewController delegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if([fromVC isKindOfClass:[EditEducationTableViewController class]])
        _shouldUpdate = NO;
    
    return nil;
}

#pragma mark - EmptyEducationViewDelegate
- (void)onAddInfoTap{
    
    [self addNewEducation:nil];
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
