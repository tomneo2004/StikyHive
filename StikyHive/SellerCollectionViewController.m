//
//  AllSellerViewController.m
//  StikyHive
//
//  Created by Koh Quee Boon on 21/5/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "SellerCollectionViewController.h"
#import "SkillPageViewController.h"
#import "SkillVideoPlayer.h"
//#import "ProfileViewController.h"
#import "ViewControllerUtil.h"
#import "WebDataInterface.h"
#import "SelectableLabel.h"
#import "SelectableImageView.h"
#import "UserProfileViewController.h"
//#import "ChatMessagesViewController.h"
//#import "ViewControllerUtil.h"
#import "Skill.h"
#import "LocalDataInterface.h"
//#import "UserInfo.h"

@interface SellerCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *skillList;
@property (nonatomic, strong) SkillVideoPlayer *skillVideoPlayer;

@end

@implementation SellerCollectionViewController

static NSString *Search_Text = @"";
static NSInteger Skill_Cat_ID = 0;
static NSString *User_ID = nil;

static NSString * const reuseIdentifier = @"seller_cell";

+ (void )setSearchText:(NSString *)searchText
{
    Search_Text = searchText;
    User_ID = nil;
    Skill_Cat_ID = 0;
}

+ (void )setSkillCat:(NSInteger)catID
{
    Skill_Cat_ID = catID;
    Search_Text = nil;
    User_ID = nil;
}

// --- If userID == [LocalDataInterface retrieveUserID], enable editing --- //
+ (void )setUserID:(NSString *)userID
{
    User_ID = userID;
    Search_Text = nil;
    Skill_Cat_ID = 0;
}

- (NSInteger)numRecords
{
    return _skillList.count;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *chatButton = [ViewControllerUtil createBarButton:@"button_chat_header" onTarget:self
                                                         withSelector:@selector(generalChatPressed)];
    UIBarButtonItem *callButton = [ViewControllerUtil createBarButton:@"button_call_header" onTarget:self
                                                         withSelector:@selector(generalCallPressed)];
    chatButton.imageInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    callButton.imageInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    self.navigationItem.rightBarButtonItems = @[callButton, chatButton];

    _skillList = [@[] mutableCopy];
    _skillVideoPlayer = [[SkillVideoPlayer alloc] init];
    
    NSString *stkid = [LocalDataInterface retrieveStkid];
    
    [WebDataInterface getSellAll:0 catId:0 stkid:@"" actionMaker:stkid completion:^(NSObject *obj, NSError *err)
     {
         NSLog(@"obj ------- %@",obj);
         
         [self displayResult:(NSDictionary *)obj];
     }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)displayResult:(NSDictionary *)skillDict
{

    if (skillDict && skillDict[@"status"])
    {
        NSArray *skillArray = skillDict[@"result"];
        
//        NSLog(@"skill dict resul array ---------------------------------- %@",skillArray);
        
        if (skillArray && skillArray.count > 0) {
            
            _skillList = [@[] mutableCopy];
            for (NSDictionary *skillDictry in skillArray)
            {
                [_skillList addObject:[self createSkill:skillDictry]];
            }
            
            [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ViewControllerUtil showAlertWithTitle:@"" andMessage:@"No Data"];
            });
        }
    }
}

- (Skill *) createSkill:(NSDictionary *)dict
{

    NSString *name = dict[@"name"];
    NSString *photoLocation = dict[@"location"];
    NSString *thumbLocation = dict[@"thumbnailLocation"];
    NSString *profileLocation = dict[@"profilePicture"];
    NSString *skillId = dict[@"skillId"];
    NSString *styid = dict[@"stkid"];
    
    NSString *videoLocation = dict[@"videoLocation"];
    
    Skill *skill = [[Skill alloc] initWithSkillId:skillId stkid:styid skillName:name skillImageLocation:photoLocation skillThumbLocation:thumbLocation profileLocation:profileLocation skillVideoLocation:videoLocation];

    
    
//    NSLog(@"photo location --------- %@",photoLocation);
    
//    
//    NSString *photo = @"";
//    if (photoLocation != (id)[NSNull null])
//    {
//        photo = photoLocation;
//    }
//    
//    NSString *thumb = @"";
//    if (thumbLocation != (id)[NSNull null])
//    {
//        thumb = thumbLocation;
//    }
//    
//    NSString *profile = @"";
//    if (profileLocation != (id)[NSNull null])
//    {
//        profile = profileLocation;
//    }
//    
//    NSString *video = @"";
//    if (videoLocation != (id)[NSNull null])
//    {
//        video = videoLocation;
//    }
//    
//    if (photo.length > 0)
//    {
//        [ViewControllerUtil cacheImageForPath:[WebDataInterface getFullUrlPath:photo]
//                                   completion:^(NSObject *obj, NSError *err){}];
//    }
//    if (thumb.length > 0)
//    {
//        [ViewControllerUtil cacheImageForPath:[WebDataInterface getFullUrlPath:thumb]
//                                   completion:^(NSObject *obj, NSError *err){}];
//    }
//    else if (profile.length > 0)
//    {
//        [ViewControllerUtil cacheImageForPath:[WebDataInterface getFullUrlPath:profile]
//                                   completion:^(NSObject *obj, NSError *err){}];
//    }
//    
//    if (video.length > 0) {
//        [ViewControllerUtil cacheImageForPath:[WebDataInterface getFullUrlPath:video]
//                                   completion:^(NSObject *obj, NSError *err) {}];
//    }

    
//    Skill *skill = [[Skill alloc] initWithSkillId:skillId stkid:styid skillName:name imageUrl:photo videoThumbUrl:thumb profileUrl:profile videoUrl:video];
    
    
    return skill;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _skillList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    SelectableImageView *skillView = (SelectableImageView *)[cell viewWithTag:SELLER_COLLECTION_TAG_SKILL_IMAGE];
    SelectableImageView *photoView = (SelectableImageView *)[cell viewWithTag:SELLER_COLLECTION_TAG_PROFILE_IMAGE];
    SelectableLabel *titleLabel = (SelectableLabel *)[cell viewWithTag:SELLER_COLLECTION_TAG_SKILL_TITLE];
    SelectableImageView *chatView = (SelectableImageView *)[cell viewWithTag:SELLER_COLLECTION_TAG_CHAT_ICON];
    SelectableImageView *callView = (SelectableImageView *)[cell viewWithTag:SELLER_COLLECTION_TAG_CALL_ICON];
    UIView *circleView = (UIView *)[cell viewWithTag:SELLER_COLLECTION_TAG_CIRCLE_VIEW];

    Skill *skill = _skillList[indexPath.row];
    
    titleLabel.text = skill.skillName;
    
//    NSLog(@"skill image location ----------- %@",skill.skillImageLocation);
    
    if (skill.skillThumbLocation !=(id)[NSNull null])
    {
        
        NSString *thumbUrl = [WebDataInterface getFullUrlPath:skill.skillThumbLocation];
        UIImage *skillImage = [ViewControllerUtil getImageWithPath:thumbUrl];
        if (skillImage) {
            skillView.image = skillImage;
            UIImageView *playIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_play@2x"]];
            [playIconView setCenter:skillView.center];
            [skillView addSubview:playIconView];
        }
        else
        {
            skillView.image = [UIImage imageNamed:@"Default_skill_photo@2x"];
        }
        
    }
    else if (skill.skillImageLocation != (id)[NSNull null])
    {
        
        NSString *imageUrl = [WebDataInterface getFullUrlPath:skill.skillImageLocation];
        
//        NSLog(@"image url -------- %@",imageUrl);
        
        UIImage *skillImage =[ViewControllerUtil getImageWithPath:imageUrl];
        skillView.image = skillImage ;
    }
    else
    {
        
        skillView.image = [UIImage imageNamed:@"default_seller_post"];
        
    }
    
    NSString *profileUrl = [WebDataInterface getFullUrlPath:skill.profileLocation];
    UIImage *profileImage = [ViewControllerUtil getImageWithPath:profileUrl];
    photoView.image = profileImage ? profileImage : [UIImage imageNamed:@"Default_profile_small@2x"];
    photoView.layer.cornerRadius = photoView.frame.size.width/2;
    photoView.layer.masksToBounds = YES;
    
    circleView.backgroundColor = [UIColor whiteColor];
    circleView.layer.cornerRadius = circleView.frame.size.width/2;
    circleView.layer.masksToBounds = YES;
    
    titleLabel.userInteractionEnabled = YES;
    skillView.userInteractionEnabled = YES;
    photoView.userInteractionEnabled = YES;
    chatView.userInteractionEnabled = YES;
    callView.userInteractionEnabled = YES;
    
    
    titleLabel.index = indexPath.row;
    skillView.index = indexPath.row;
    photoView.index = indexPath.row;
    chatView.index = indexPath.row;
    callView.index = indexPath.row;
    
    
    [titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skillTitleTapped:)]];
    [skillView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skillImageTapped:)]];
    [photoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileImageTapped:)]];
    [chatView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chatImageTapped:)]];
    [callView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callImageTapped:)]];
    
    [cell setNeedsLayout];
    return cell;
}

-(void)skillTitleTapped:(UITapGestureRecognizer *)sender
{
    SelectableLabel *label = (SelectableLabel *)sender.view;
    Skill *skill = _skillList[label.index];
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"skill_page_view_controller"];
    SkillPageViewController *svc = (SkillPageViewController *)vc;
    [svc setSkillID:skill.skillid];
    
    [self.navigationController pushViewController:svc animated:YES];
}

-(void)skillImageTapped:(UITapGestureRecognizer *)sender
{
    SelectableImageView *imageView = (SelectableImageView *)sender.view;
    Skill *skill = _skillList[imageView.index];

    if (skill.skillVideoLocation.length > 0)
    {
        NSString *videoPath = [WebDataInterface getFullStoragePath:skill.skillVideoLocation];
        [_skillVideoPlayer startPlayingVideo:videoPath onView:self.view];
    }
    else if(skill.skillImageURL.length > 0)
    {
         NSString *photoPath = [WebDataInterface getFullStoragePath:skill.skillImageLocation];
        
        NSLog(@"photo path ---- %@",photoPath);
        [ViewControllerUtil showFullPhoto:photoPath onViewController:self];
    }
    
}

-(void)profileImageTapped:(UITapGestureRecognizer *)sender
{
    SelectableImageView *imageView = (SelectableImageView *)sender.view;
    Skill *skill = _skillList[imageView.index];
    
    NSString *stkid = skill.stkid;
//    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"profile_view_controller"];
//    ProfileViewController *pvc = (ProfileViewController *)vc;
//    [pvc setUserID:skill.userID];
//    [self.navigationController pushViewController:pvc animated:YES];
    
    
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"user_profile_view_controller"];
    UserProfileViewController *svc = (UserProfileViewController *)vc;
    [svc setStkID:stkid];
    
    [self.navigationController pushViewController:svc animated:YES];

    
}

-(void)chatImageTapped:(UITapGestureRecognizer *)sender
{
//    SelectableImageView *imageView = (SelectableImageView *)sender.view;
//    Skill *skill = _skillList[imageView.index];
//    [WebDataInterface getInfoForUser:skill.userID completion:^(NSObject *obj, NSError *err)
//    {
//        NSDictionary *userData = (NSDictionary *)obj;
//        UserInfo *userInfo = [[UserInfo alloc] init];
//        
//        dispatch_async(dispatch_get_main_queue(),^{
//
//            [ChatMessagesViewController setRecipientID:userData[@"stkid"]];
//            ChatMessagesViewController *cmvc = [ChatMessagesViewController messagesViewController];
//            [self.navigationController pushViewController:cmvc animated:YES];
//        });
//
//    }];
}

-(void)callImageTapped:(UITapGestureRecognizer *)sender
{
    NSLog(@"Call");
}

- (IBAction)generalCallPressed
{
    NSLog(@"Call Pressed");
}

- (IBAction)generalChatPressed
{
//    UIViewController *vc = ![ViewControllerUtil isLoggedIn] ? [ViewControllerUtil instantiateEntryView] :
//    [ViewControllerUtil instantiateViewController:@"chat_list_view_controller"];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    SelectableImageView *skillView = (SelectableImageView *)[cell viewWithTag:SELLER_COLLECTION_TAG_SKILL_IMAGE];
    SelectableImageView *photoView = (SelectableImageView *)[cell viewWithTag:SELLER_COLLECTION_TAG_PROFILE_IMAGE];
    SelectableLabel *titleLabel = (SelectableLabel *)[cell viewWithTag:SELLER_COLLECTION_TAG_SKILL_TITLE];
    
    for (UIView *view in skillView.subviews)
    {
        [view removeFromSuperview];
    }
    
    skillView.image = nil;
    photoView.image = nil;
    titleLabel.text = nil;
    cell = nil;
}

@end
