//
//  ITTableViewController.m
//  StikyHive
//
//  Created by User on 1/4/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "ITTableViewController.h"
#import "WebDataInterface.h"
#import "UIView+RNActivityView.h"
#import "ITCell.h"
#import "SearchViewController.h"

@interface ITTableViewController ()

@end

@implementation ITTableViewController{
    
    NSMutableArray *_dataArray;
    BOOL _isLoaded;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];
    _isLoaded = NO;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if(_catToShow == industry){
    
        if(self.navigationController){
            
            self.title = @"Industry Professional";
        }
    }
    else if(_catToShow == talent){
        
        if(self.navigationController){
            
            self.title = @"Raw Talent";
        }
    }
    
    if(!_isLoaded){
        
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [self.view showActivityViewWithLabel:@"Loading..."];
        
        //Type = 1
        if(_catToShow == industry){
            
            [WebDataInterface getITListWithcompletion:^(NSObject *obj, NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(error != nil){
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No data found!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                        
                        if(self.navigationController){
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        
                        [self.view hideActivityView];
                    }
                    else{
                        
                        NSDictionary *dic = (NSDictionary *)obj;
                        
                        [_dataArray removeAllObjects];
                        
                        for(NSDictionary *dicData in dic[@"skills"] ){
                            
                            if([dicData[@"type"] integerValue] == 1){
                                
                                [_dataArray addObject:[dicData copy]];
                            }
                        }
                        
                        _isLoaded = YES;
                        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
                        [self.tableView reloadData];
                        
                        [self.view hideActivityView];
                    }
                });
                
            }];
        }
        else if(_catToShow == talent){//Type = 2
            
            [WebDataInterface getITListWithcompletion:^(NSObject *obj, NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(error != nil){
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                        
                        if(self.navigationController){
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        
                        [self.view hideActivityView];
                    }
                    else{
                        
                        NSDictionary *dic = (NSDictionary *)obj;
                        
                        [_dataArray removeAllObjects];
                        
                        for(NSDictionary *dicData in dic[@"skills"] ){
                            
                            if([dicData[@"type"] integerValue] == 2){
                                
                                [_dataArray addObject:[dicData copy]];
                            }
                        }
                        
                        _isLoaded = YES;
                        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
                        [self.tableView reloadData];
                        
                        [self.view hideActivityView];
                    }
                });
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    
    if(_dataArray != nil){
        
        return _dataArray.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"ITCell";
    
    ITCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    if(cell == nil){
        
        cell = [[ITCell alloc] init];
    }
    
    // Configure the cell...
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    
    cell.label.text = dic[@"name"];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    
    NSLog(@"did tap %@", dic[@"name"]);
    
    SearchViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    controller.searchByCatId = YES;
    controller.catIdToSearch = [dic[@"id"] integerValue];
    controller.searchKeyword = dic[@"name"];
    
    [self.navigationController pushViewController:controller animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
