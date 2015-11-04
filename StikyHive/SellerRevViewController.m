//
//  SellerRevViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 14/10/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "SellerRevViewController.h"
#import "WebDataInterface.h"
#import "ViewControllerUtil.h"

@interface SellerRevViewController ()

@property (nonatomic, strong) NSString *skillId;
@property (nonatomic, strong) NSArray *reviewArray;
@property (nonatomic, strong) UILabel *reviewLabel;

@end

@implementation SellerRevViewController

static NSString *CellIndentifier = @"seller_review_cell";

- (void)setSkillID:(NSString *)skillID
{
    _skillId = skillID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _reviewTableView.delegate = self;
    _reviewTableView.dataSource = self;
    _reviewTableView.allowsSelection = NO;
    
    
    self.reviewTableView.estimatedRowHeight = 130.0;
    self.reviewTableView.rowHeight = UITableViewAutomaticDimension;
    
    [WebDataInterface getCommReviewBySkillId:_skillId completion:^(NSObject *obj, NSError *err) {
        
        NSDictionary *dict = (NSDictionary *)obj;
        
        if (dict) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _reviewArray = dict[@"reviews"];
                
                [self.reviewTableView reloadData];
                
                NSInteger reviewNum = _reviewArray.count;
                
                _titleLabel.text = [NSString stringWithFormat:@"Reviews (%ld)",(long)reviewNum];
                
            });
        }
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [WebDataInterface getCommReviewBySkillId:_skillId completion:^(NSObject *obj, NSError *err) {
       
        NSDictionary *dict = (NSDictionary *)obj;
        
        if (dict) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _reviewArray = dict[@"reviews"];
                
                [self.reviewTableView reloadData];
                
                NSInteger reviewNum = _reviewArray.count;
                
                _titleLabel.text = [NSString stringWithFormat:@"Reviews (%ld)",(long)reviewNum];
                
            });
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _reviewArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [_reviewTableView dequeueReusableCellWithIdentifier:CellIndentifier forIndexPath:indexPath];
    
    NSDictionary *reviewObj = _reviewArray[indexPath.row]; 
    
    UIImageView *profileImageView = (UIImageView *)[cell viewWithTag:SELLER_REVIEW_TAG_PROFILE_IMAGE];
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:SELLER_REVIEW_TAG_NAME_LABEL];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:SELLER_REVIEW_TAG_DATE_LABEL];
    _reviewLabel = (UILabel *)[cell viewWithTag:SELLER_REVIEW_TAG_REVIEW_LABEL];
    
    NSString *dateString = reviewObj[@"createDate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    NSString *finalDate = [dateFormatter stringFromDate:date];
    dateLabel.textAlignment = NSTextAlignmentLeft;
    
    nameLabel.text = [NSString stringWithFormat:@"%@ %@",reviewObj[@"firstName"],reviewObj[@"lastName"]];
    dateLabel.text = finalDate;
    _reviewLabel.text = reviewObj[@"review"];
    [_reviewLabel sizeToFit];
    NSString *profileLocation = reviewObj[@"profilePicture"];
    
    if (profileLocation != (id)[NSNull null]) {
        NSString *profileUrl = [WebDataInterface getFullUrlPath:profileLocation];
        profileImageView.image = [ViewControllerUtil getImageWithPath:profileUrl];
    }
    else
    {
        profileImageView.image = [UIImage imageNamed:@"Default_profile_small@2x"];
    }
    
    
    CGFloat x = 134;
    
    for (int i = 0; i < 5; i++) {
        
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(x, 10, 15, 15)];
        iconImage.image = [UIImage imageNamed:@"review_filled"];
        
        x = x + iconImage.frame.size.width + 2;
        
        [cell addSubview:iconImage];
        
    }
    

    
    
    
    
    return cell;
}

@end
