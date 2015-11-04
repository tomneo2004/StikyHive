//
//  SellerCommTableViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 9/10/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "SellerCommTableViewController.h"
#import "WebDataInterface.h"
#import "ViewControllerUtil.h"
#import "PostCommViewController.h"

@interface SellerCommTableViewController ()
@property (nonatomic, strong) NSString *skillId;
@property (nonatomic, strong) NSDictionary *commDict;
@property (nonatomic, strong) NSArray *commentsArray;

@end

@implementation SellerCommTableViewController

static NSString *CellIndentifier = @"seller_comm_cell";


- (void)setSkillID:(NSString *)skillID
{
    _skillId = skillID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _commTableView.delegate = self;
    _commTableView.dataSource = self;
    _commTableView.allowsSelection = NO;
    
     UIColor *greenbColor = [UIColor colorWithRed:18.0/255 green:148.0/255 blue:133.0/255 alpha:1.0];
    
    [_postBtn setTitleColor:greenbColor forState:UIControlStateNormal];
    _postBtn.layer.borderColor = greenbColor.CGColor;
    _postBtn.layer.borderWidth = 1.5;
    _postBtn.layer.cornerRadius = 5;
    _postBtn.layer.masksToBounds = YES;


    self.commTableView.estimatedRowHeight = 130.0;
    self.commTableView.rowHeight = UITableViewAutomaticDimension;
    

    [WebDataInterface getCommReviewBySkillId:_skillId completion:^(NSObject *obj, NSError *err)
     {
         _commDict = (NSDictionary *)obj;

             if (_commDict) {
                   dispatch_async(dispatch_get_main_queue(), ^{
                 
                   _commentsArray = _commDict[@"comments"];
                 
                   [self.commTableView reloadData];
                   NSInteger commNum = _commentsArray.count;
                   _titleLabel.text = [NSString stringWithFormat:@"Comments(%ld)",(long)commNum];
                 
             });
         }
     }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [_commTableView dequeueReusableCellWithIdentifier:CellIndentifier forIndexPath:indexPath];
    
    NSDictionary *commObj = _commentsArray[indexPath.row];
    
    UIImageView *profileImageView = (UIImageView *)[cell viewWithTag:SELLER_COMMENTS_TAG_PROFILE_IMAGE];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:SELLER_COMMENTS_TAG_NAME_LABEL];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:SELLER_COMMENTS_TAG_DATE_LABEL];
    UILabel *commLabel = (UILabel *)[cell viewWithTag:SELLER_COMMENTS_TAG_COMMENT_LABEL];
    
    
    NSString *dateString = commObj[@"createDate"];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate *date = [formate dateFromString:dateString];
    [formate setDateFormat:@"dd MMM yyyy"];
    NSString *finalDate = [formate stringFromDate:date];
    
    dateLabel.textAlignment = NSTextAlignmentLeft;
    
    
    nameLabel.text = [NSString stringWithFormat:@"%@ %@",commObj[@"firstName"],commObj[@"lastName"]];
    dateLabel.text = finalDate;
    commLabel.text = commObj[@"review"];
    NSString *profileLocation = commObj[@"profilePicture"];
    
    if (profileLocation != (id)[NSNull null])
    {
        NSString *profileUrl = [WebDataInterface getFullUrlPath:profileLocation];
        profileImageView.image = [ViewControllerUtil getImageWithPath:profileUrl];
    }
    else
    {
        profileImageView.image = [UIImage imageNamed:@"Default_profile_small@2x"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


- (IBAction)postBtnPressed:(id)sender
{
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"post_comments_view_controller"];
    PostCommViewController *svc = (PostCommViewController *)vc;
    [svc setSkillID:_skillId];
    
    [self.navigationController pushViewController:svc animated:YES];

}

- (void)viewWillAppear:(BOOL)animated
{
    _postBtn.hidden = YES;
    
    [WebDataInterface getCommReviewBySkillId:_skillId completion:^(NSObject *obj, NSError *err)
     {
         _commDict = (NSDictionary *)obj;
         
         if (_commDict) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 _commentsArray = _commDict[@"comments"];
                 
                 [self.commTableView reloadData];
                 
                 NSInteger commNum = _commentsArray.count;
                 _titleLabel.text = [NSString stringWithFormat:@"Comments(%ld)",(long)commNum];
                 _postBtn.hidden = NO;
                 
                
             });
         }
     }];

}


@end
