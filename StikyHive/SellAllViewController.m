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
    
    [WebDataInterface getSellAllSkills:8 catId:0 completion:^(NSObject *obj, NSError *err) {
//        NSLog(@"obj ------- %@",obj);
//        NSLog(@"err ----- %@",err);
      
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            NSDictionary *dict = (NSDictionary *)obj;
            NSLog(@"get sell all dict ---- %@",dict);

            
            if (err == nil && [dict[@"status"] isEqualToString:@"success"])
            {
                _skillArrays = [[NSMutableArray alloc] init];
                
                _skillArrays = dict[@"result"];
                
                
                _isLoaded = YES;
                NSLog(@"skill array ---- %@",_skillArrays);
                NSLog(@"skill array count --- %lu",(unsigned long)_skillArrays.count);
                
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







@end
