//
//  UserSkillViewController1.m
//  StikyHive
//
//  Created by Koh Quee Boon on 26/5/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "UserSkillViewController1.h"
#import "UserSkillViewController2.h"
#import "LocalDataInterface.h"
#import "EntryViewController.h"
#import "HtmlEditor.h"
#import "ViewControllerUtil.h"
#import "Skill.h"

@interface UserSkillViewController1 ()

@property (nonatomic, strong) NSArray *profCategoryList;
@property (nonatomic, strong) NSArray *rawCategoryList;
@property (nonatomic, strong) NSArray *skillCategoryList;
@property (nonatomic, strong) HtmlEditor *skillDescEditor;
@property (nonatomic, assign) BOOL skillDescEditorLoaded;

@end

@implementation UserSkillViewController1

static NSMutableDictionary *Skill_Info;

+ (UIViewController *) instantiateForInfo:(NSDictionary *)skillInfo
{
    Skill_Info = skillInfo ? skillInfo.mutableCopy : nil;
    return [ViewControllerUtil instantiateViewController:@"user_skill_view_controller_1"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _profCategoryList = [LocalDataInterface retrieveProfessionalSkillCategories];
    _rawCategoryList = [LocalDataInterface retrieveRawTalentCategories];
    _skillCategoryList = _profCategoryList;
    _skillCategoryPicker.delegate = self;
    _skillCategoryPicker.dataSource = self;
    _skillCategoryPicker.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _skillCategoryPicker.layer.borderWidth = 1;
    _skillDescWebview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _skillDescWebview.layer.borderWidth = 1;

    UITapGestureRecognizer *tapCatcher = [[UITapGestureRecognizer alloc] init];
    [tapCatcher setNumberOfTapsRequired:1];
    [tapCatcher setDelegate:self];
    
    [_skillDescWebview addGestureRecognizer:tapCatcher];
    
    [self setTextFields:@[_skillTitleTextField]];
    
//    NSDictionary *animateDists = @{_skillDescWebview:[NSNumber numberWithInteger:-160]};;
//    [self setAnimateDistances:animateDists];
    
    NSString *username = [LocalDataInterface retrieveUsername];
    if (!username || username.length == 0)
    {
        UIViewController *vc = [ViewControllerUtil instantiateViewController:@"entry_view_controller"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (Skill_Info) // Editing of existing skill
    {
        NSNumber *typeNum = Skill_Info[@"type"];
        NSNumber *catNum = Skill_Info[@"catId"];
        [self setSelectedSkillType:typeNum.integerValue andCat:catNum.integerValue];
        _skillTitleTextField.text = Skill_Info[@"name"];
        [_skillDescWebview loadHTMLString:Skill_Info[@"description"] baseURL:nil];
    }
    else // Creating of new skill
    {
        Skill *skill = [LocalDataInterface retrieveCreatedSkill];
        [self setSelectedSkillType:skill.skillType andCat:skill.catID];
        _skillTitleTextField.text = skill.skillName;
        [_skillDescWebview loadHTMLString:Skill_Info[@"description"] baseURL:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    if (_skillDescEditorLoaded)
    {
        [_skillDescWebview loadHTMLString:[_skillDescEditor getHTML] baseURL:nil];
        _skillDescEditorLoaded = NO;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && !_skillDescEditorLoaded)
    {
        _skillDescEditorLoaded = YES;
        _skillDescEditor = [[HtmlEditor alloc] init];
        [_skillDescEditor setHTML:[_skillDescWebview stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"]];
        [self.navigationController pushViewController:_skillDescEditor animated:YES];
    }
    return YES;
}

- (IBAction)skillTypeSelected:(id)sender
{
    NSInteger skillSegmentIndex = _skillSegmentedControl.selectedSegmentIndex;
    NSArray *skillCats = @[_profCategoryList, _rawCategoryList];
    _skillCategoryList = skillCats[skillSegmentIndex];
    [_skillCategoryPicker reloadAllComponents];
}

- (IBAction)nextButtonPressed:(id)sender
{
    NSString *skillTitle = _skillTitleTextField.text;
    NSString *skillDesc = [_skillDescWebview stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    NSString *innerDesc = [_skillDescWebview stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    skillTitle = [skillTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (skillTitle.length == 0)
    {
        [ViewControllerUtil showAlertWithTitle: @"Incomplete Information" andMessage:@"Skill Title not fill in."];
    }
    else if (innerDesc.length == 0)
    {
        [ViewControllerUtil showAlertWithTitle: @"Incomplete Information" andMessage:@"Skill Description not fill in."];
    }
    else
    {
//        NSString *userID = [LocalDataInterface retrieveUserID];
//        Skill *skill = [[Skill alloc] initWithID:0 catID:[self getSelectedSkillCat]
//                                          userID:userID skillName:skillTitle skillDesc:skillDesc
//                                   skillImageURL:nil skillVideoURL:nil skillVideoThumbURL:nil userPhotoLoc:nil];
//        skill.skillType = [self getSelectedSkillType];
//        
//        if (!Skill_Info) // Creating new skill
//        {
//            [LocalDataInterface storeCreatedSkill:skill];
//        }
//        else
//        {
//            Skill_Info[@"type"] = [NSNumber numberWithInteger:skill.skillType];
//            Skill_Info[@"catId"] = [NSNumber numberWithInteger:skill.catID];
//            Skill_Info[@"name"] = skill.skillName;
//            Skill_Info[@"description"] = skill.skillDesc;
//        }
//        
//        UIViewController *vc = [UserSkillViewController2 instantiateForInfo:Skill_Info];
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _skillCategoryList.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _skillCategoryList[row][@"name"];
}

- (void)setSelectedSkillType:(NSInteger)type andCat:(NSInteger)catID
{
    _skillSegmentedControl.selectedSegmentIndex = type - 1;
 
    for (NSInteger i = 0; i < _skillCategoryList.count; i++)
    {
        NSNumber *catNum = _skillCategoryList[i][@"id"];
        if (catNum.integerValue == catID)
        {
            [_skillCategoryPicker selectRow:i inComponent:0 animated:YES];
            break;
        }
    }
}

- (NSInteger)getSelectedSkillType
{
    return _skillSegmentedControl.selectedSegmentIndex + 1;
}

- (NSInteger)getSelectedSkillCat
{
    NSInteger selectedCatRow = [_skillCategoryPicker selectedRowInComponent:0];
    NSNumber *catNum = _skillCategoryList[selectedCatRow][@"id"];
    return catNum.integerValue;
}

@end
