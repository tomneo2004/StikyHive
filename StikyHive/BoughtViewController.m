//
//  BoughtViewController.m
//  StikyHive
//
//  Created by User on 8/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "BoughtViewController.h"
#import "BoughtInfo.h"
#import "WebDataInterface.h"
#import "UIView+RNActivityView.h"
#import "LocalDataInterface.h"

@interface BoughtViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BoughtViewController{
    
    NSMutableArray *_boughtInfos;
    NSDateFormatter *_dateFormatter;
    ReadReviewViewController *_readReviewController;
}

@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    [WebDataInterface selectBoughtInfo:[LocalDataInterface retrieveStkid] completion:^(NSObject *obj, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error != nil){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to get data!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                
            }
            else{
                
                NSDictionary *dic = (NSDictionary *)obj;
                
                if(((NSArray *)dic[@"bought"]).count <=0){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No result" message:@"No bought information!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                }
                else{
                    
                    _boughtInfos = [[NSMutableArray alloc] init];
                    
                    for(NSDictionary *data in dic[@"bought"]){
                        
                        BoughtInfo *info = [BoughtInfo createBoughtInfoFromDictionary:data];
                        [_boughtInfos addObject:info];
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

#pragma mark - UITableViewDataSource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_boughtInfos != nil){
    
        return _boughtInfos.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"BoughtCell";
    
    BoughtCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil){
        
        cell = [[BoughtCell alloc] init];
    }
    
    BoughtInfo *info = [_boughtInfos objectAtIndex:indexPath.row];
    
    cell.boughtFromLabel.text = [NSString stringWithFormat:@"%@ %@", info.firstname, info.lastname];
    cell.onLabel.text = [_dateFormatter stringFromDate:info.createDate];
    cell.titleLabel.text = info.skillName;
    cell.priceLabel.text = [NSString stringWithFormat:@"$%.2f %@", info.price, info.rateName];
    cell.rating = info.rating;
    
    if(info.thumbnailLocation != nil)
        [cell displayPhotoWithURL:info.thumbnailLocation];
    else
        [cell displayPhotoWithURL:info.photoLocation];
    
    cell.delegate = self;
    
    return cell;
}

#pragma mark - BoughtCell delegate
- (void)onReadReviewTap:(BoughtCell *)cell{
    
    BoughtInfo *info = [_boughtInfos objectAtIndex:[_tableView indexPathForCell:cell].row];
    
    _readReviewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReadReviewViewController"];
    [_readReviewController presentOverlay:^(OverlayViewController * controller){
    
        _readReviewController.reviewTitle = info.skillName;
        _readReviewController.rating = info.rating;
        _readReviewController.review = info.review;
        _readReviewController.delegate = self;
    }];
}

- (void)onEditReviewTap:(BoughtCell *)cell{
    
}

#pragma mark - ReadReviewController delegate
- (void)onEditTap:(ReadReviewViewController *)controller{
    
    [controller dismissOverlay:^{
    
        _readReviewController = nil;
    }];
}

- (void)onClose{
    
    
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
