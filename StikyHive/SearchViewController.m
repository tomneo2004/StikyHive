//
//  SearchViewController.m
//  StikyHive
//
//  Created by User on 23/3/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "SearchViewController.h"
#import "UIView+RNActivityView.h"
#import "WebDataInterface.h"
#import "SearchInfo.h"
#import "ViewControllerUtil.h"
#import "UserProfileViewController.h"
#import "SkillPageViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AttachmentViewController.h"


@interface SearchViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *searchTitle;

@end

@implementation SearchViewController{
    
    NSMutableArray *_data;
    BOOL _isloaded;
    MPMoviePlayerViewController *theMoviePlayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isloaded = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    _searchTitle.text = [NSString stringWithFormat:@"Search for %@", _searchKeyword];
    
    if(!_isloaded)
        [self pullData];
}

- (void)pullData{
    
    //show activity
    [self.view showActivityViewWithLabel:@"Refreshing..." detailLabel:@"Fetching data"];
    
    //urgent request of 3 rows of data
    [WebDataInterface getSearchSell:_searchKeyword completion:^(NSObject *obj, NSError *error){
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            NSDictionary *dic = (NSDictionary *)obj;
            if(error == nil && [dic[@"status"] isEqualToString:@"success"]){
            
                _data = [[NSMutableArray alloc] init];
                
                for(NSDictionary *dicData in dic[@"result"]){
                    
                    SearchInfo *info = [SearchInfo createSearchInfoFromDictionary:dicData];
                    
                    [_data addObject:info];
                }
                
                _isloaded = YES;
                
                [_tableView reloadData];
            }
            else{
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No data were found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            [self.view hideActivityView];
            
        });
        
    }];
}

#pragma mark - UITableViewSouceData delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_data != nil){
        
        return _data.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"SearchCell";
    
    SearchCell *searchCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(searchCell == nil){
        
        searchCell = [[SearchCell alloc] init];
    }
    
    SearchInfo *info = [_data objectAtIndex:indexPath.row];
    
    searchCell.delegate = self;
    searchCell.titleLabel.text = info.name;
    [searchCell displayThumbnailImageWithUrl:info.thumbnailLocation];
    [searchCell displayProfilePictureWithURL:info.profilePicture];
    
    if(info.videoUrl != nil){
        
        searchCell.isVideo = YES;
    }
    else{
        
        searchCell.isVideo = NO;
    }
    
    return searchCell;
}

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchInfo *info = (SearchInfo *)[_data objectAtIndex:indexPath.row];
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"skill_page_view_controller"];
    SkillPageViewController *svc = (SkillPageViewController *)vc;
    [svc setSkillID:info.skillId];
    
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)searchCellDidTapPersonAvatar:(SearchCell *)cell{
    
    NSInteger index = [_tableView indexPathForCell:cell].row;
    
    SearchInfo *info = (SearchInfo *)[_data objectAtIndex:index];
    
    //present user profile controller
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"user_profile_view_controller"];
    UserProfileViewController *svc = (UserProfileViewController *)vc;
    [svc setStkID:info.stkId];
    
    [self.navigationController pushViewController:svc animated:YES];

}

- (void)searchCellDidTapThumbnailImage:(SearchCell *)cell{
    
    NSInteger index = [_tableView indexPathForCell:cell].row;
    
    SearchInfo *info = (SearchInfo *)[_data objectAtIndex:index];
    
    if(info.videoUrl != nil){
        
        NSURL *urlString=[NSURL URLWithString:[WebDataInterface getFullUrlPath:info.videoUrl]];
        theMoviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:urlString];
        
        [self presentMoviePlayerViewControllerAnimated:theMoviePlayer];
    }
    else{
        
        AttachmentViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AttachmentViewController"];
        controller.attachmentPhotoURL = info.thumbnailLocation;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
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
