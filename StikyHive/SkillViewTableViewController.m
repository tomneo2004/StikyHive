//
//  SkillViewTableViewController.m
//  StikyHive
//
//  Created by User on 17/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import "SkillViewTableViewController.h"
#import "UIView+RNActivityView.h"
#import "WebDataInterface.h"
#import "LocalDataInterface.h"
#import "CommentInfo.h"
#import "ReviewInfo.h"
#import "UIImageView+AFNetworking.h"
#import "SeeAllCommentViewController.h"
#import "SeeAllReviewViewController.h"

@interface SkillViewTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *attachmentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewCountLabel;
@property (weak, nonatomic) IBOutlet UIWebView *overviewWebView;
@property (weak, nonatomic) IBOutlet UIWebView *descWebView;
@property (weak, nonatomic) IBOutlet UIView *commentContainer;
@property (weak, nonatomic) IBOutlet UIView *reviewContainer;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;


@end

@implementation SkillViewTableViewController{
    
    NSString *_skillsId;
    NSString *_ownerStkId;
    NSInteger _viewCount;
    NSInteger _likeCount;
    NSInteger _likeId;
    BOOL _liked;
    NSMutableArray *_comments;
    NSMutableArray *_reviews;
}

@synthesize skillId = _skillId;
@synthesize attachmentImageView = _attachmentImageView;
@synthesize avatarImageView = _avatarImageView;
@synthesize titleLabel = _titleLabel;
@synthesize likeImageView = _likeImageView;
@synthesize likeCountLabel = _likeCountLabel;
@synthesize viewCountLabel = _viewCountLabel;
@synthesize overviewWebView = _overviewWebView;
@synthesize descWebView = _descWebView;
@synthesize commentContainer = _commentContainer;
@synthesize reviewContainer = _reviewContainer;
@synthesize segControl = _segControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [_segControl addTarget:self action:@selector(onSegmentChangeValue:) forControlEvents:UIControlEventValueChanged];
    [_segControl setSelectedSegmentIndex:0];
    _reviewContainer.hidden = YES;
    _commentContainer.hidden = NO;
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    for(UIGestureRecognizer *g in [_likeImageView gestureRecognizers]){
        
        [_likeImageView removeGestureRecognizer:g];
    }
    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLikeTap:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [_likeImageView addGestureRecognizer:tap];
    
    //make person's profile picture circle
    _avatarImageView.layer.cornerRadius = _avatarImageView.bounds.size.width/2;
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatarImageView.layer.borderWidth = 1;
    _avatarImageView.userInteractionEnabled = YES;
    
    [self pullData];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [_attachmentImageView cancelImageRequestOperation];
    [_avatarImageView cancelImageRequestOperation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - internal
- (void)onSegmentChangeValue:(UISegmentedControl *)control{
    
    if((control.selectedSegmentIndex | 0) == 0){
        
        _commentContainer.hidden = NO;
        _reviewContainer.hidden = YES;
    }
    else if((control.selectedSegmentIndex | 0) == 1){
        
        _reviewContainer.hidden = NO;
        _commentContainer.hidden= YES;
    }
    
}

- (void)onLikeTap:(UIGestureRecognizer *)recognizer{

    [self.view showActivityViewWithLabel:@"Updating..."];
    
    //was liked
    if(_liked == YES){
        
        //make it unlike
        [WebDataInterface saveReview:[NSString stringWithFormat:@"%li", _likeId] skillId:_skillsId viewCount:@"0" likeCount:@"0" owner:_ownerStkId actionMaker:[LocalDataInterface retrieveStkid] completion:^(NSObject *object, NSError *error){
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                if(error != nil){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Update fail!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                else{
                    
                    _liked = NO;
                    
                    _likeImageView.image = [UIImage imageNamed:@"like"];
                    
                    _likeCount -= 1;
                    
                    _likeCountLabel.text = [NSString stringWithFormat:@"%li Likes", _likeCount];
                }
                
                [self.view hideActivityView];
            });
            
            
        }];
    }
    else{//was not liked
        
        //make it like
        [WebDataInterface saveReview:[NSString stringWithFormat:@"%li", _likeId] skillId:_skillsId viewCount:@"0" likeCount:@"1" owner:_ownerStkId actionMaker:[LocalDataInterface retrieveStkid] completion:^(NSObject *object, NSError *error){
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                if(error != nil){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Update fail!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                else{
                    
                    _liked = YES;
                    
                    _likeImageView.image = [UIImage imageNamed:@"like_filled"];
                    
                    _likeCount += 1;
                    
                    _likeCountLabel.text = [NSString stringWithFormat:@"%li Likes", _likeCount];
                }
                
                [self.view hideActivityView];
            });
            
        }];
    }
}

- (id)findViewControllerByClass:(Class)controllerClass{
    
    for(UIViewController *c in self.childViewControllers){
        
        if([c isKindOfClass:controllerClass]){
            
            return c;
        }
    }
    
    return nil;
}

- (void)pullData{
    
    if(_skillId == nil || _skillId.length <= 0){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No skill id" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    [self.view showActivityViewWithLabel:@"Refreshing..." detailLabel:@"Fetching data"];
    [WebDataInterface getSkillById:_skillId stkid:[LocalDataInterface retrieveStkid] completion:^(NSObject *obj, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(error != nil){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to get data!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else{
                
                NSDictionary *dic = (NSDictionary *)obj;
                NSDictionary *skillDic = [dic objectForKey:@"resultSkill"];
                NSDictionary *photoDic = [(NSArray *)[dic objectForKey:@"resultPhoto"] firstObject];
                
                if(!skillDic || !photoDic){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No result" message:@"No skill information!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                }
                else{
                    
                    //skillId
                    _skillsId = [skillDic objectForKey:@"id"];
                    
                    //owner stkid
                    _ownerStkId = [skillDic objectForKey:@"stkid"];
                    
                    //likedId
                    _likeId = [[skillDic objectForKey:@"likeId"] integerValue];
                    
                    //skill name
                    _titleLabel.text = [skillDic objectForKey:@"name"];
                    
                    //like count
                    if(![[skillDic objectForKey:@"likeCount"] isEqual:[NSNull null]])
                        _likeCount = [[skillDic objectForKey:@"likeCount"] integerValue];
                    
                    _likeCountLabel.text = [NSString stringWithFormat:@"%li Likes", _likeCount];
                    
                    //view count
                    if(![[skillDic objectForKey:@"viewCount"] isEqual:[NSNull null]])
                        _viewCount = [[skillDic objectForKey:@"viewCount"] integerValue];
                    
                    _viewCountLabel.text = [NSString stringWithFormat:@"%li Views", _viewCount];
                    
                    //liked
                    if([[skillDic objectForKey:@"likeId"] integerValue] > 0 && [[skillDic objectForKey:@"countOfLikeId"] integerValue] > 0){
                        
                        _liked = YES;
                        
                        _likeImageView.image = [UIImage imageNamed:@"like_filled"];
                    }
                    
                    //attachment image view
                    NSURL *attachmentURL = [NSURL URLWithString:[WebDataInterface getFullStoragePath:[photoDic objectForKey:@"location"]]];
                    [_attachmentImageView setImageWithURLRequest:[NSURLRequest requestWithURL:attachmentURL] placeholderImage:[UIImage imageNamed:@"Default_buyer_post"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                        
                        //set image
                        _attachmentImageView.image = image;
                        
                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                        
                        
                    }];
                    
                    //avatar image view
                    NSURL *avatarURL = [NSURL URLWithString:[WebDataInterface getFullStoragePath:[skillDic objectForKey:@"profilePicture"]]];
                    [_avatarImageView setImageWithURLRequest:[NSURLRequest requestWithURL:avatarURL] placeholderImage:[UIImage imageNamed:@"Default_profile_small@2x"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                        
                        //set image
                        _avatarImageView.image = image;
                        
                    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                        
                        
                    }];
                    
                    //overview
                    if(![[skillDic objectForKey:@"summary"] isEqual:[NSNull null]])
                        [_overviewWebView loadHTMLString:[skillDic objectForKey:@"summary"] baseURL:nil];
                    
                    //desc
                    if(![[skillDic objectForKey:@"skillDesc"] isEqual:[NSNull null]])
                        [_descWebView loadHTMLString:[skillDic objectForKey:@"skillDesc"] baseURL:nil];
                    
                    //get comments and review data
                    [WebDataInterface getCommReviewBySkillId:_skillId completion:^(NSObject *object, NSError *error){
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                        
                            if(error != nil){
                                
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to get data!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                [alert show];
                                
                                [self.view hideActivityView];
                                
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            else{
                                
                                NSDictionary *dic = (NSDictionary *)object;
                                
                                _comments = [[NSMutableArray alloc] init];
                                
                                for(NSDictionary *data in dic[@"comments"]){
                                    
                                    CommentInfo *info = [CommentInfo createCommentInfoFromDictionary:data];
                                    [_comments addObject:info];
                                }
                                
                                [_segControl setTitle:[NSString stringWithFormat:@"Comments (%li)", _comments.count] forSegmentAtIndex:0];
                                
                                CommentsViewController *controller = [self findViewControllerByClass:[CommentsViewController class]];
                                controller.delegate = self;
                                
                                if(controller != nil){
                                    
                                    if(_comments.count > 0){
                                        
                                        [controller refreshViewWithCommentInfo:[_comments firstObject]];
                                    }
                                    else{
                                        
                                        [controller refreshViewWithCommentInfo:nil];
                                    }
                                }
                                
                                _reviews = [[NSMutableArray alloc] init];
                                
                                for(NSDictionary *data in dic[@"reviews"]){
                                    
                                    ReviewInfo *info = [ReviewInfo createReviewInfoFromDictionary:data];
                                    [_reviews addObject:info];
                                }
                                 
                                [_segControl setTitle:[NSString stringWithFormat:@"Reviews (%li)", _reviews.count] forSegmentAtIndex:1];
                                
                                //review controller
                                ReviewsViewController *rcontroller = [self findViewControllerByClass:[ReviewsViewController class]];
                                rcontroller.delegate = self;
                                
                                if(rcontroller != nil){
                                    
                                    if(_reviews.count > 0){
                                        
                                        [rcontroller refreshViewWithReviewInfo:[_reviews firstObject]];
                                    }
                                    else{
                                        
                                        [rcontroller refreshViewWithReviewInfo:nil];
                                    }
                                }
                                
                                [self.view hideActivityView];
                            }
                        });
                        
                    }];
                    
                    [self.view hideActivityView];
                    
                    return;
                }
                
            }
            
            [self.view hideActivityView];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        });
    }];
}

#pragma mark - CommentsViewController delegate
- (void)commentSeeAllTap{
    
    SeeAllCommentViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SeeAllCommentViewController"];
    controller.commentsData = _comments;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)commentPostCommentTap{
    
}

#pragma mark - ReviewsViewController delegate
- (void)reviewSeeAllTap{
    
    SeeAllReviewViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SeeAllReviewViewController"];
    controller.reviewsData = _reviews;
    
    [self.navigationController pushViewController:controller animated:YES];
}

/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}
*/

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
