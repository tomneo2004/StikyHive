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
    
    
    
    NSString *stkid = [LocalDataInterface retrieveStkid];
    
    [WebDataInterface getSellAll:0 catId:0 stkid:@"" actionMaker:stkid completion:^(NSObject *obj, NSError *err)
     {
         NSLog(@"obj ------- %@",obj);
         
         
         NSDictionary *dict = (NSDictionary *)obj;
         NSLog(@"get sell all dict ---- %@",dict);
//         if (<#condition#>) {
//             <#statements#>
//         }
         
         _skillArrays = [[NSMutableArray alloc] init];
         
         
         
         
         
         
         [_sellTableView reloadData];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_skillArrays != nil) {
        return _skillArrays.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"SellAllCell";
    
    SellAllCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[SellAllCell alloc] init];
    }
    
    
    
    
    
    
    
    return cell;
}










@end
