//
//  SellerCommViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 8/10/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "SellerCommViewController.h"
#import "WebDataInterface.h"
#import "ViewControllerUtil.h"


@interface SellerCommViewController ()

@property (nonatomic, strong) NSString *skillId;
@property (nonatomic, strong) NSDictionary *commDict;
@property (nonatomic, strong) NSArray *commentsArray;


@end

@implementation SellerCommViewController

- (void)setSkillID:(NSString *)skillID
{
    _skillId = skillID;
    NSLog(@"skill id  -------------  %@",_skillId);
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *chatButton = [ViewControllerUtil createBarButton:@"button_chat_header" onTarget:self
                                                         withSelector:@selector(generalChatPressed)];
    UIBarButtonItem *callButton = [ViewControllerUtil createBarButton:@"button_call_header" onTarget:self
                                                         withSelector:@selector(generalCallPressed)];
    chatButton.imageInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    callButton.imageInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    self.navigationItem.rightBarButtonItems = @[callButton, chatButton];
    
    
    _contentScrollView.alwaysBounceVertical = YES;
    _contentScrollView.delegate = self;
    
    
    
    [WebDataInterface getCommReviewBySkillId:_skillId completion:^(NSObject *obj, NSError *err)
     {
         _commDict = (NSDictionary *)obj;
         
         if (_commDict) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 _commentsArray = _commDict[@"comments"];
                 
                  [self displayContent:_commentsArray];
             });
         }
     }];

}

- (void)displayContent:(NSArray *)commArray
{
    CGFloat x = 0;
    CGFloat y = 10;
//    CGFloat vspace = 30;
//    CGFloat aspect = 9.0/16;
    CGFloat width = self.view.frame.size.width;
    
    y = [self displayTitle:commArray atStartPoint:CGPointMake(x, y) andWidth:width];
    y = [self displayComments:commArray atStartPoint:CGPointMake(x, y) andWidth:width];

    [_contentScrollView setContentSize:CGSizeMake(self.view.frame.size.width, y)];
    
}

- (CGFloat)displayTitle:(NSArray *)commArray atStartPoint:(CGPoint)point andWidth:(CGFloat)width
{
    CGFloat y = point.y;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y, 150, 40)];
    titleLabel.text = [NSString stringWithFormat:@"Comments(%lu)",(unsigned long)commArray.count];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    CGPoint center = titleLabel.center;
    center.x = self.view.center.x;
    titleLabel.center = center;
    
    [_contentScrollView addSubview:titleLabel];
    
    y = y + titleLabel.frame.size.height + 5;
    
    UIColor *greenbColor = [UIColor colorWithRed:18.0/255 green:148.0/255 blue:133.0/255 alpha:1.0];
    
    UIButton *postBtn = [[UIButton alloc] initWithFrame:CGRectMake(width - 140, y, 120, 30)];
    [postBtn setTitle:@"Post Comment" forState:UIControlStateNormal];
    [postBtn setTitleColor:greenbColor forState:UIControlStateNormal];
    postBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    postBtn.layer.borderColor = greenbColor.CGColor;
    postBtn.layer.borderWidth = 1.5;
    postBtn.layer.cornerRadius = 5;
    postBtn.layer.masksToBounds = YES;

    [_contentScrollView addSubview:postBtn];
    
    y = y + postBtn.frame.size.height + 15;
    
    return y;
}


- (CGFloat)displayComments:(NSArray *)commArray atStartPoint:(CGPoint)point andWidth:(CGFloat)width
{
    CGFloat y = point.y;
    
    for (int i = 0; i < commArray.count; i ++) {
        UIView *commView = [[UIView alloc] initWithFrame:CGRectMake(point.x, y, width, 120)];
        
        
        NSDictionary *commObj = commArray[i];
        
        NSString *name = [NSString stringWithFormat:@"%@ %@",commObj[@"firstName"],commObj[@"lastName"]];
        NSString *profileLocation = commObj[@"profilePicture"];
        NSString *comment = commObj[@"review"];
        NSString *createDate = commObj[@"createDate"];
        
        NSString *profileUrl = [WebDataInterface getFullUrlPath:profileLocation];
        
        UIView *profilePhotoView = [ViewControllerUtil getViewWithImageURLNormal:profileUrl xOffset:30 yOffset:30 width:60.0 heigth:60.0 defaultPhoto:@"Default_profile_small@2x"];
        profilePhotoView.layer.cornerRadius = 60.0/2;
        profilePhotoView.layer.masksToBounds = YES;
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - 120, 20, 100, 8)];
        dateLabel.text = createDate;
        dateLabel.font = [UIFont systemFontOfSize:10];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, profilePhotoView.frame.origin.y + profilePhotoView.frame.size.height + 10, 120, 15)];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = name;
        nameLabel.font = [UIFont systemFontOfSize:15];
        
        UILabel *commLabel = [[UILabel alloc] initWithFrame:CGRectMake(profilePhotoView.frame.origin.x+profilePhotoView.frame.size.width + 35, dateLabel.frame.origin.y+dateLabel.frame.size.height + 5, 200, 50)];
        commLabel.numberOfLines = 0;
//        [commLabel sizeToFit];
        commLabel.text = comment;
        commLabel.font = [UIFont systemFontOfSize:15];
        
        
        CGRect frame = commView.frame;
        frame.size.height = 100 + commLabel.frame.size.height;
        commView.frame = frame;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, commView.frame.size.height-1, width, 1)];
        line.backgroundColor = [UIColor blackColor];
        
        [commView addSubview:profilePhotoView];
        [commView addSubview:nameLabel];
        [commView addSubview:dateLabel];
        [commView addSubview:commLabel];
        [commView addSubview:line];
        
        [_contentScrollView addSubview:commView];
        
        y = y + commView.frame.size.height;
    }
    
    return y;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
