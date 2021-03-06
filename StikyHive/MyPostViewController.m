//
//  MyPostViewController.m
//  StikyHive
//
//  Created by User on 23/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "MyPostViewController.h"
#import "UIView+RNActivityView.h"
#import "LocalDataInterface.h"
#import "WebDataInterface.h"
#import "MyPostInfo.h"
#import "UIImageView+AFNetworking.h"
#import "BuyerPostViewController.h"
#import "ViewControllerUtil.h"
#import "PostBuyViewController.h"

@interface MyPostViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noPostView;

@end

@implementation MyPostViewController{  
    
    NSMutableArray *_myPostInfos;
    NSDateFormatter *_dateFormatter;
    NSInteger _tmpDeleteIndex;
}

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"My post";
    
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
    [WebDataInterface getBuyerMarketByStkid:[LocalDataInterface retrieveStkid] limit:0 completion:^(NSObject *obj, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error != nil){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to get data!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                
            }
            else{
                
                NSDictionary *dic = (NSDictionary *)obj;
                NSLog(@"buyer market =---- %@",dic);
                
                if(((NSArray *)dic[@"buyermarkets"]).count <=0){
                    
                    /*
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No result" message:@"No post information!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                     */
                    
                    _tableView.hidden = YES;
                    _noPostView.hidden = NO;
                    
                }
                else{
                    
                    _myPostInfos = [[NSMutableArray alloc] init];
                    NSLog(@"buyer market info --- %@",obj);
                    
                    for(NSDictionary *data in dic[@"buyermarkets"]){
                        
                        MyPostInfo *info = [MyPostInfo createMyPostInfoFromDictionary:data];
                        [_myPostInfos addObject:info];
                    }
                    
                    _tableView.hidden = NO;
                    _noPostView.hidden = YES;
                    
                    [_tableView reloadData];
                    
                    [self.view hideActivityView];
                    
                    return;
                }
                
            }
            
            [self.view hideActivityView];
            
            //[self.navigationController popViewControllerAnimated:YES];
            
        });
    }];
}

#pragma mark - IBAction
- (IBAction)addPost:(id)sender{
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"post_buy_view_controller"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_myPostInfos != nil){
        
        return _myPostInfos.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"MyPostCell";
    
    MyPostCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil){
        
        cell = [[MyPostCell alloc] init];
    }
    
    MyPostInfo *info = [_myPostInfos objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = info.name;
    cell.postDateLabel.text = [_dateFormatter stringFromDate:info.issueDate];
    cell.expiredDateLabel.text = [_dateFormatter stringFromDate:info.expiredDate];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - MySkillCell delegate
- (void)onEditTap:(MyPostCell *)cell{
    
    NSInteger index = [_tableView indexPathForCell:cell].row;
    
    MyPostInfo *info = [_myPostInfos objectAtIndex:index];
    
    NSLog(@"my post info ---- %@",[_myPostInfos objectAtIndex:index]);
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"post_buy_view_controller"];
    PostBuyViewController *svc = (PostBuyViewController *)vc;
    [svc setBuyerId:[info.postId integerValue]];
    svc.myPostInfo = info;
    
    [self.navigationController pushViewController:svc animated:YES];
    
    
}

- (void)onViewTap:(MyPostCell *)cell{
    
    NSInteger index = [_tableView indexPathForCell:cell].row;
    
    MyPostInfo *info = [_myPostInfos objectAtIndex:index];
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"buyer_post_view_controlller"];
    BuyerPostViewController *svc = (BuyerPostViewController *)vc;
    [svc setBuyerId:[info.postId integerValue]];
    [svc setPictureLocation:info.location];
    
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)onDeleteTap:(MyPostCell *)cell{
    
    
    _tmpDeleteIndex = [_tableView indexPathForCell:cell].row;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Do you want to delete?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        
        MyPostInfo *info = [_myPostInfos objectAtIndex:_tmpDeleteIndex];
        
        [self.view showActivityViewWithLabel:@"Refreshing..." detailLabel:@"Fetching data"];
        
        [WebDataInterface deleteBuyerPost:[info.postId integerValue] stkid:[LocalDataInterface retrieveStkid] limit:0 completion:^(NSObject *obj, NSError *error){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(error != nil){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to delete post!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                    [self.view hideActivityView];
                    
                    return ;
                }
                else{
                    
                    [_myPostInfos removeObjectAtIndex:_tmpDeleteIndex];
                    [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_tmpDeleteIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                    if(_myPostInfos.count <= 0){
                        
                        _tableView.hidden = YES;
                        _noPostView.hidden = NO;
                    }
                    
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
