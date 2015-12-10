//
//  SellingTableViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 9/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "SellingTableViewController.h"
#import "SellingManager.h"

@interface SellingTableViewController ()

@property (nonatomic, assign) NSInteger numberOfRows;
@property (weak, nonatomic) IBOutlet UITableView *sellTableView;

@end

@implementation SellingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SellingManager *smg = [SellingManager sharedSellingManager];
    _numberOfRows = 4;
    if (smg.photoStatus) {
        _numberOfRows = 8;
    }
    
    _sellTableView.delegate = self;
    _sellTableView.dataSource = self;
    
    [_sellTableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewSouceData delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"sellCell";
    
    SellingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell ==  nil) {
        cell = [[SellingCell alloc] init];
    }
    
    cell.delegate = self;
    [cell displayDefaultImage:@"sell_upload_photo"];
    
    return cell;
}

#pragma mark - cell delegate
- (void)SellingCellDidTapImageView:(SellingCell *)cell
{
    [self showCropViewControllerWithOptions:cell.photoImageView andType:2];
    
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
