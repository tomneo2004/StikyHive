//
//  UserSkillViewController3.m
//  StikyHive
//
//  Created by Koh Quee Boon on 26/5/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "UserSkillViewController3.h"
//#import "PaymentViewController1.h"
#import "ViewControllerUtil.h"
#import "LocalDataInterface.h"
#import "WebDataInterface.h"

@interface UserSkillViewController3 ()

@property (nonatomic, strong) NSArray *skillImageViews;
@property (nonatomic, strong) NSMutableArray *selectionIndicators;

@end

@implementation UserSkillViewController3

static NSMutableDictionary *Skill_Info;
static UIImage *Video_Thumbnail;
static NSData *Video_Data;

+ (UIViewController *) instantiateForInfo:(NSDictionary *)skillInfo
                               videoThumb:(UIImage *)thumbImage
                             andVideodata:(NSData *)videoData
{
    Skill_Info = skillInfo.mutableCopy;
    Video_Thumbnail = thumbImage;
    Video_Data = videoData;
    return [ViewControllerUtil instantiateViewController:@"user_skill_view_controller_3"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, 950)];
    
    _selectionIndicators = @[[NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO],
                             [NSNumber numberWithBool:NO]].mutableCopy;
    
    _skillImageViews = @[_skillPhotoImageView1,_skillPhotoImageView2,_skillPhotoImageView3,_skillPhotoImageView4];
    
    for (NSInteger i = 0; i < _skillImageViews.count; i++)
    {
        UIGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedImage:)];
        [_skillImageViews[i] addGestureRecognizer:rec];
        [_skillImageViews[i] setUserInteractionEnabled:YES];
        [_skillImageViews[i] setTag:i];
        
        // Editing existing skill
        if (Skill_Info)
        {
            [_skillImageViews[i] setImage: [UIImage imageNamed:@"Default_skill_photo@2x"]];
            if (((NSArray *)Skill_Info[@"photo"]).count > i)
            {
                NSString *imageLoc = Skill_Info[@"photo"][i][@"location"];
                NSString *imagePath = [WebDataInterface getFullStoragePath:imageLoc];
                UIImage *image = [ViewControllerUtil getImageForPath:imagePath];
                if (image && image.size.width > 0 && image.size.height > 0)
                {
                    _selectionIndicators[i] = [NSNumber numberWithBool:YES];
                    [_skillImageViews[i] setImage:image];
                }
            }
        }
        else // Creating new skill
        {
            UIImage *image = [LocalDataInterface retrieveImageAtIndex:i];
            if (image && image.size.width > 0 && image.size.height > 0)
                [_skillImageViews[i] setImage:[LocalDataInterface retrieveImageAtIndex:i]];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)tappedImage:(UITapGestureRecognizer *)sender
{
    [self showImagePickerForImageView:_skillImageViews[sender.view.tag]];
    _selectionIndicators[sender.view.tag] = [NSNumber numberWithBool:YES];
}

- (IBAction)updateButtonPressed:(id)sender
{
    for (NSInteger i = 0; i < _skillImageViews.count; i++)
        if ([_selectionIndicators[i] boolValue])
            [LocalDataInterface storeImage:[_skillImageViews[i] image] atIndex:i];

    // Editing existing skill
    if (Skill_Info && Skill_Info[@"photo"])
    {
        NSString *userID = [LocalDataInterface retrieveUserID];
        NSNumber *skillID = Skill_Info[@"id"];
        NSNumber *skillType = Skill_Info[@"type"];
        NSNumber *skillCat = Skill_Info[@"catId"];
        NSString *skillName = Skill_Info[@"name"];
        NSString *skillDesc = Skill_Info[@"description"];
        
        [WebDataInterface updateSkill:skillID.integerValue skillType:skillType.integerValue catID:skillCat.integerValue
                            skillName:skillName skillDesc:skillDesc completion:^(NSObject *obj, NSError *err)
        {
        }];
        
        NSString *timeStamp = [ViewControllerUtil getCurrentDateTimeWithFormat:@"YYYY-MM-dd_HH-mm-ss"];

        if (Video_Thumbnail && Video_Data)
        {
            NSString *videoFile = [NSString stringWithFormat:@"%@_%d.mov",timeStamp,1];
            NSString *thumbFile = [NSString stringWithFormat:@"%@_thumbnail_%d.jpg",timeStamp,1];
            NSData *imageData = UIImageJPEGRepresentation(Video_Thumbnail,1.0);
            [WebDataInterface updateVideoForSkill:skillID.integerValue videoFile:videoFile videoData:Video_Data
                                        thumbFile:thumbFile thumbData:imageData ofUser:userID
                                       completion:^(NSObject *obj, NSError *err)
            {
            }];
        }
        
        for (NSInteger i = 0; i < _skillImageViews.count; i++)
        {
            if ([_selectionIndicators[i] boolValue])
            {
                NSString *photoFile = [NSString stringWithFormat:@"%@_%ld.jpg",timeStamp,i];
                NSData *imageData = UIImageJPEGRepresentation([_skillImageViews[i] image],1.0);
                [WebDataInterface updatePhotoForSkill:skillID.integerValue photoFile:photoFile photoData:imageData
                                               ofUser:userID completion:^(NSObject *obj, NSError *err)
                {
                }];
            }
        }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else // Creating new skill
    {
        UIViewController *vc = [ViewControllerUtil instantiateViewController:@"payment_view_controller_1"];
        [self.navigationController pushViewController:vc animated:YES];
    }

}


@end

