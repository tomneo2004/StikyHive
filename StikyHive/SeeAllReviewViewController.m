//
//  SeeAllReviewViewController.m
//  StikyHive
//
//  Created by User on 21/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "SeeAllReviewViewController.h"
#import "ReviewCell.h"
#import "ReviewInfo.h"

@interface SeeAllReviewViewController ()

@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SeeAllReviewViewController{
    
    NSDateFormatter *_dateFormatter;
}

@synthesize reviewLabel = _reviewLabel;
@synthesize tableView = _tableView;
@synthesize reviewsData = _reviewsData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"dd MMM yyyy"];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    _reviewLabel.text = [NSString stringWithFormat:@"Reviews (%li)", _reviewsData.count];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_reviewsData != nil){
        
        return _reviewsData.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"ReviewCell";
    
    ReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil){
        
        cell = [[ReviewCell alloc] init];
    }
    
    ReviewInfo *reviewInfo = [_reviewsData objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", reviewInfo.firstname, reviewInfo.lastname];
    cell.dateLabel.text = [_dateFormatter stringFromDate:reviewInfo.createDate];
    cell.textView.text = reviewInfo.review;
    cell.rating = reviewInfo.rating;
    [cell displayProfileImageWithURL:reviewInfo.profilePicture];
    
    return cell;
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
