//
//  SeeAllCommentViewController.m
//  StikyHive
//
//  Created by User on 21/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "SeeAllCommentViewController.h"
#import "CommentCell.h"
#import "CommentInfo.h"

@interface SeeAllCommentViewController ()

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SeeAllCommentViewController{
    
    NSDateFormatter *_dateFormatter;
}

@synthesize commentLabel = _commentLabel;
@synthesize tableView = _tableView;
@synthesize commentsData = _commentsData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"dd MMM yyyy"];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    _commentLabel.text = [NSString stringWithFormat:@"Comments (%li)", _commentsData.count];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)postComment:(id)sender{
    
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_commentsData != nil){
        
        return _commentsData.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"CommentCell";
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil){
        
        cell = [[CommentCell alloc] init];
    }
    
    CommentInfo *commentInfo = [_commentsData objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", commentInfo.firstname, commentInfo.lastname];
    cell.dateLabel.text = [_dateFormatter stringFromDate:commentInfo.createDate];
    cell.reviewTextView.text = commentInfo.review;
    [cell displayProfileImageWithURL:commentInfo.profilePicture];
    
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
