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

@interface SellAllViewController ()

@end

@implementation SellAllViewController{
    NSMutableArray *_skillArrays;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _sellTableView.delegate = self;
    _sellTableView.dataSource = self;
    
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    NSString *stkid = [LocalDataInterface retrieveStkid];
    
//    [self.view showActivityViewWithLabel:@"Loading..."];
    
    [WebDataInterface getSellAllSkills:0 catId:0 completion:^(NSObject *obj, NSError *err) {
        NSLog(@"obj ------- %@",obj);
        NSLog(@"err ----- %@",err);
        
        NSDictionary *dict = (NSDictionary *)obj;
        NSLog(@"get sell all dict ---- %@",dict);
        //         if (<#condition#>) {
        //             <#statements#>
        //         }
        
        
        _skillArrays = [[NSMutableArray alloc] init];
        
        _skillArrays = dict[@"result"];
        
        
        NSLog(@"skill array ---- %@",_skillArrays);
        NSLog(@"skill array count --- %lu",(unsigned long)_skillArrays.count);
        
        [_sellTableView reloadData];
        

    }];
    
//    [WebDataInterface getSellAll:@"" catId:0 stkid:@"" actionMaker:stkid completion:^(NSObject *obj, NSError *err)
//     {
//         
//         
////         [self.view hideActivityView];
//     }];
    

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










@end
