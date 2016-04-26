//
//  MySkillViewController.m
//  StikyHive
//
//  Created by User on 17/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "MySkillViewController.h"
#import "UIView+RNActivityView.h"
#import "LocalDataInterface.h"
#import "WebDataInterface.h"
#import "MySkillInfo.h"
#import "SkillViewTableViewController.h"
#import "SkillPageViewController.h"
#import "ViewControllerUtil.h"
#import "SellingViewController.h"

@interface MySkillViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MySkillViewController{
    
    NSMutableArray *_mySkillInfos;
    NSDateFormatter *_dateFormatter;
    NSInteger _tmpDeleteIndex;
}

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"My skill";
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"dd MMM yyyy"];
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
    [WebDataInterface getSellAllMy:0 catId:0 stkid:[LocalDataInterface retrieveStkid] flagMy:YES actionMaker:[LocalDataInterface retrieveStkid] completion:^(NSObject *obj, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error != nil){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to get data!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                
            }
            else{
                
                NSDictionary *dic = (NSDictionary *)obj;
                
                if(((NSArray *)dic[@"result"]).count <=0){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No result" message:@"No skill information!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                }
                else{
                    
                    _mySkillInfos = [[NSMutableArray alloc] init];
                    
                    NSLog(@"skill page result --- %@",dic[@"result"]);
                    
                    for(NSDictionary *data in dic[@"result"]){
                        
                        MySkillInfo *info = [MySkillInfo createMySkillInfoFromDictionary:data];
                        [_mySkillInfos addObject:info];
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
- (IBAction)addSkill:(id)sender{
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"selling_view_controller"];
    [self.navigationController pushViewController:vc animated:YES];
    

}

#pragma mark - UITableViewDataSource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_mySkillInfos != nil){
    
        return _mySkillInfos.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"MySkillCell";
    
    MySkillCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil){
        
        cell = [[MySkillCell alloc] init];
    }
    
    MySkillInfo *info = [_mySkillInfos objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = info.name;
    cell.issueDateLabel.text = [_dateFormatter stringFromDate:info.issueDate];
    cell.expiredDateLabel.text = [_dateFormatter stringFromDate:info.expiredDate];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - MySkillCell delegate
- (void)onEditTap:(MySkillCell *)cell
{
    
    NSInteger index = [_tableView indexPathForCell:cell].row;
    
    MySkillInfo *info = [_mySkillInfos objectAtIndex:index];
    
    
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"selling_view_controller"];
//    SellingViewController *svc = (SellingViewController *)vc;
//    svc.mySkillInfo = info;
    
    ((SellingViewController *)vc).mySkillInfo = info;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onViewTap:(MySkillCell *)cell{
    
    NSInteger index = [_tableView indexPathForCell:cell].row;
    
    MySkillInfo *info = [_mySkillInfos objectAtIndex:index];
    
    /*
    SkillViewTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SkillViewTableViewController"];
    controller.skillId = info.skillId;
    
    [self.navigationController pushViewController:controller animated:YES];
    */
    
    SkillPageViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"skill_page_view_controller"];
    [controller setSkillID:info.skillId];
    [self.navigationController pushViewController:controller animated:YES];
    
    
}

- (void)onDeleteTap:(MySkillCell *)cell{
    
    _tmpDeleteIndex = [_tableView indexPathForCell:cell].row;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Do you want to delete?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
    
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        
        MySkillInfo *info = [_mySkillInfos objectAtIndex:_tmpDeleteIndex];
        
        [self.view showActivityViewWithLabel:@"Refreshing..." detailLabel:@"Fetching data"];
        
        [WebDataInterface deleteSell:[info.skillId integerValue] completion:^(NSObject *obj, NSError *error){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(error != nil){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to delete skill!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                    [self.view hideActivityView];
                    
                    return ;
                }
                else{
                    
                    [_mySkillInfos removeObjectAtIndex:_tmpDeleteIndex];
                    [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_tmpDeleteIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                }
                
                [self.view hideActivityView];
            });
        }];
    }
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
