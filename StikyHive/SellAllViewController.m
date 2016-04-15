//
//  SellAllViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 23/3/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "SellAllViewController.h"
#import "LocalDataInterface.h"
#import "WebDataInterface.h"
#import "UIView+RNActivityView.h"
#import "SearchViewController.h"
#import "ActionSheetPicker.h"
#import "ViewControllerUtil.h"
#import "SkillPageViewController.h"
#import "UserProfileViewController.h"


@interface SellAllViewController ()

@end

@implementation SellAllViewController{
    NSMutableArray *_skillArrays;
    BOOL _isLoaded;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _sellTableView.delegate = self;
    _sellTableView.dataSource = self;
    
    _skillSearchBar.delegate = self;
    _isLoaded = NO;
    
}


- (void)viewWillAppear:(BOOL)animated
{
//    NSString *stkid = [LocalDataInterface retrieveStkid];
    if (!_isLoaded) {
        [self pullData];
    }
    

}

- (void)pullData
{
    [self.view showActivityViewWithLabel:@"Loading..." detailLabel:@"Fetching data"];
    
    [WebDataInterface getSellAllSkills:8 catId:1 completion:^(NSObject *obj, NSError *err) {
      
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            NSDictionary *dict = (NSDictionary *)obj;
            NSLog(@"get sell all dict ---- %@",dict);

            
            if (err == nil && [dict[@"status"] isEqualToString:@"success"])
            {
                _skillArrays = [[NSMutableArray alloc] init];
                
                _skillArrays = dict[@"result"];
                
                
                _isLoaded = YES;
                
                [_sellTableView reloadData];

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)filterTap:(id)sender{
    
    [ActionSheetStringPicker showPickerWithTitle:@"Filter" rows:@[@"Professional Skill", @"RawTalent"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
       
        NSInteger result = 0;
        
        if(selectedIndex == 0)
            result = 1;
        else if(selectedIndex == 1)
            result = 0;
       
        [self.view showActivityViewWithLabel:@"Loading..." detailLabel:@"Fetching data"];
        
       [WebDataInterface getSellFilter:result completion:^(NSObject *obj, NSError *error) {
          
           dispatch_async(dispatch_get_main_queue(), ^{
           
               NSDictionary *dict = (NSDictionary *)obj;
               
               if (error == nil && [dict[@"status"] isEqualToString:@"success"])
               {
                   _skillArrays = [[NSMutableArray alloc] init];
                   
                   _skillArrays = dict[@"result"];
                   
                   
                   _isLoaded = YES;
                   
                   [_sellTableView reloadData];
                   
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
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:sender];

}

- (IBAction)sortTap:(id)sender{
    
    [ActionSheetStringPicker showPickerWithTitle:@"Sort" rows:@[@"Latest View", @"Most View"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        if(selectedIndex == 0){
            
            [self pullData];
        }
        else if(selectedIndex == 1){
            
            [self.view showActivityViewWithLabel:@"Loading..." detailLabel:@"Fetching data"];
            
            [WebDataInterface getSellMostViewCompletion:^(NSObject *obj, NSError *error) {
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSDictionary *dict = (NSDictionary *)obj;
                    
                    if (error == nil && [dict[@"status"] isEqualToString:@"success"])
                    {
                        _skillArrays = [[NSMutableArray alloc] init];
                        
                        _skillArrays = dict[@"result"];
                        
                        
                        _isLoaded = YES;
                        
                        [_sellTableView reloadData];
                        
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

        
        
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:sender];

}



#pragma mark - UITableViewDataSource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"return 1 section");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_skillArrays != nil) {
        NSLog(@"row ---- %lu",(unsigned long)_skillArrays.count);
        return _skillArrays.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell for row at index called");
    static NSString *cellId = @"SellAllCell";
    
    SellAllCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[SellAllCell alloc] init];
    }
    
    
    cell.delegate = self;
    NSDictionary *obj = _skillArrays[indexPath.row];
    NSLog(@"skill index ---- %@",obj);
    
    
    cell.titleLabel.text = obj[@"name"];
    
    [cell displayProfileImage:obj[@"profilePicture"]];
    [cell displaySkillImage:obj[@"thumbnailLocation"]];
    
    
    
    return cell;
}

#pragma mark - TableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = [_skillArrays objectAtIndex:indexPath.row];
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"skill_page_view_controller"];
    SkillPageViewController *svc = (SkillPageViewController *)vc;
    [svc setSkillID:[NSString stringWithFormat:@"%ld", [dic[@"skillId"] integerValue]]];
    
    [self.navigationController pushViewController:svc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SellAllCell delegate
- (void)onProfileImageTap:(SellAllCell *)cell{
    
    NSIndexPath *indexPath = [_sellTableView indexPathForCell:cell];
    
    NSDictionary *dic = [_skillArrays objectAtIndex:indexPath.row];
    
    //present user profile controller
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"user_profile_view_controller"];
    UserProfileViewController *svc = (UserProfileViewController *)vc;
    [svc setStkID:dic[@"stkid"]];
    
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    if(searchBar.text != nil && ![searchBar.text isEqualToString:@""]){
        
        SearchViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
        
        controller.searchKeyword = searchBar.text;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    [searchBar resignFirstResponder];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
}







@end
