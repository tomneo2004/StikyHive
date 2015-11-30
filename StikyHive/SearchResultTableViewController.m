//
//  SearchResultTableViewController.m
//  StikyHive
//
//  Created by User on 24/11/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "SearchResultTableViewController.h"
#import "SkillInfo.h"
#import "DistanceSkill.h"
#import "DistanceTitle.h"
#import "Helper.h"
#import "ViewControllerUtil.h"
#import "UserProfileViewController.h"

@interface SearchResultTableViewController ()

@end

@implementation SearchResultTableViewController{
    
    NSArray *_searchResult;
}

@synthesize searchResult = _searchResult;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.title = @"Search result";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setter
- (void)setSearchResult:(NSArray *)searchResult{
    
    _searchResult = searchResult;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if(_searchResult != nil){
        
        return _searchResult.count;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(_searchResult != nil){
        
        DistanceSkill *dSkill = [_searchResult objectAtIndex:section];
        
        return dSkill.allSkills.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"SearchResultCell";
    
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell == nil){
        
        cell = [[SearchResultCell alloc] init];
    }
    
    DistanceSkill *dSkill = [_searchResult objectAtIndex:indexPath.section];
    SkillInfo *skillInfo =[dSkill.allSkills objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", skillInfo.firstname, skillInfo.lastname];
    cell.descLabel.text = skillInfo.name;
    cell.distanceLabel.text = skillInfo.distanceToString;
    cell.delegate = self;
    
    [cell displayProfilePictureWithURL:skillInfo.profilePicture];
    
    return cell;
}

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DistanceSkill *dSkill = [_searchResult objectAtIndex:indexPath.section];
    SkillInfo *skillInfo = [dSkill.allSkills objectAtIndex:indexPath.row];
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"user_profile_view_controller"];
    UserProfileViewController *svc = (UserProfileViewController *)vc;
    [svc setStkID:skillInfo.stkId];
    
    [self.navigationController pushViewController:svc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    DistanceTitle *titleView = (DistanceTitle *)[Helper viewFromNib:@"DistanceTitle" atViewIndex:0 owner:self];
    
    DistanceSkill *dSkill = [_searchResult objectAtIndex:section];
    
    titleView.distanceLabel.text = dSkill.distanceToString;
    
    return titleView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    UIView *titleView = [Helper viewFromNib:@"DistanceTitle" atViewIndex:0 owner:self];
    
    return titleView.bounds.size.height;
}

#pragma mark - SearchResultCell delegate
- (void)SearchResultDidTapPhoneCall:(SearchResultCell *)cell{
    
    NSLog(@"Search result phone call");
}

- (void)SearchResultDidTapChat:(SearchResultCell *)cell{
    
    NSLog(@"Search result chat");
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
