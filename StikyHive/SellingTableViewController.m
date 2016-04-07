//
//  SellingTableViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 9/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "SellingTableViewController.h"
#import "SellingManager.h"
#import "ViewControllerUtil.h"
#import "ImageCaption.h"
#import "SellingViewController4.h"
#import "UIView+RNActivityView.h"
#import "WebDataInterface.h"

@interface SellingTableViewController ()

@property (nonatomic, assign) NSInteger numberOfRows;
@property (weak, nonatomic) IBOutlet UITableView *sellTableView;

//@property (nonatomic, assign) NSInteger tmpIndex;

@property (nonatomic, assign) BOOL imageSelected0;

@property (nonatomic, strong) NSArray *skillImageViews;

@property (nonatomic, strong) NSMutableArray *imageFileArray;
@property (nonatomic, strong) NSMutableDictionary *imageDict;
@property (nonatomic, strong) NSMutableArray *addArray;

@property (nonatomic, strong) NSMutableArray *imageCapArray;

@end

@implementation SellingTableViewController{
    NSInteger _tmpIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    _imageFileArray = [[NSMutableArray alloc] init];
    
    
   SellingManager *smg = [SellingManager sharedSellingManager];
    
    if(smg.photoCaption == nil){
        _imageCapArray = [[NSMutableArray alloc] init];
    }
    else{
        
        _imageCapArray = smg.photoCaption;
    }
    
    
    
    if (!smg.photoStatus) {
        [self setDefaultImageCount:4];
//        _numberOfRows = 4;
    }
    else
    {
        [self setDefaultImageCount:8];
//        _numberOfRows = 8;
        _imageSelected0 = YES;
    }
    
    
    NSLog(@"image caption array ----- %@",_imageCapArray);
    
    for (int i = 0; i < _imageCapArray.count; i++) {
        ImageCaption *im = _imageCapArray[i];
        NSLog(@"image --- %@",im.image);
        NSLog(@"caption --- %@",im.caption);
    }
    
//    _imageCapArray = [[]
//    for (int i = 0; i < 4; i++)
//    {
//        [_imageFileArray insertObject:[NSNull null] atIndex:i];
//    }

    
    
//    _numberOfRows = 4;
    
//    _addArray = [[NSMutableArray alloc] init];
//    _imageFileArray = [smg.photoArray mutableCopy];
//    NSLog(@"4 image file array --- %@",_imageFileArray);
//    if (smg.videoStatus) {
//        _imageFileArray = [smg.photoArray mutableCopy];
//        NSLog(@"4 image file array --- %@",_imageFileArray);
//    }
    
//    if (smg.photoStatus)
//    {
//        _numberOfRows = 8;
//        
//        _imageFileArray = [[SellingManager sharedSellingManager].photoArray mutableCopy];
//        
//        for (int i = 4; i < 8; i++)
//        {
//            [_imageFileArray insertObject:[NSNull null] atIndex:i];
//        }
//
//        NSLog(@"8 image file array --- %@",_imageFileArray);
//    }
    
    _sellTableView.delegate = self;
    _sellTableView.dataSource = self;
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    //    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];

    
//    [_sellTableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    int selfCount = 0;
    
    for(UIViewController *controller in self.navigationController.viewControllers){
        
        if([controller isKindOfClass:[SellingTableViewController class]])
            selfCount++;
    }
    
    //user change subscription plan
    if(selfCount >= 2){
        
        return;
    }
    
    //on edit skill
    if(_mySkillInfo){
        
        [self.view showActivityViewWithLabel:@"Fetching data..."];
        [WebDataInterface getSkillById:_mySkillInfo.skillId stkid:_mySkillInfo.stkId completion:^(NSObject *obj, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(error != nil){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can not get data" delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
                    [alert show];
                    
                    [self.view hideActivityView];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                else{
                    
                    
                    NSDictionary *dic = (NSDictionary *)obj;
                    NSArray *arr = dic[@"resultPhoto"];
                    NSArray *planArr = dic[@"resultSubSkill"];
                    
                    _imageCapArray = nil;
                    _numberOfRows = 0;
                    
                    //how many row base on plan
                    for(NSDictionary *pData in planArr){
                        
                        if([pData[@"subscriptionPlanId"] integerValue] == 1){
                            
                            _numberOfRows = 4;
                        }
                        
                        if([pData[@"subscriptionPlanId"] integerValue] == 3){
                            
                            _numberOfRows = 8;
                        }
                    }
                    
                    //init the row
                    _imageCapArray = [[NSMutableArray alloc] initWithCapacity:_numberOfRows];
                    
                    if(_numberOfRows > 0){
                        
                        for(int i =0; i<_numberOfRows; i++){
                            
                            //if there is exist data
                            if(i<arr.count){
                                
                                NSDictionary *existData = arr[i];
                                [_imageCapArray addObject:[[ImageCaption alloc] initWithImageURL:[WebDataInterface getFullUrlPath:existData[@"location"]] caption:[existData[@"caption"] isEqual:[NSNull null]]?@"":existData[@"caption"] photoId:[existData[@"id"] integerValue] delegate:self]];
                                
                                _imageSelected0 = YES;
                                
                                [self.view hideActivityView];
                            }
                            else{//if there is no data make clean one
                                
                                [_imageCapArray addObject:[ImageCaption emptyImageCaptionDelegate:self]];
                            }
                        }
                    }
                    
                    [_sellTableView reloadData];
                    
                    
                    if(_numberOfRows == 0)
                        [self.view hideActivityView];
                }
                
            });
        }];
    }
    
}

- (void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDefaultImageCount:(NSInteger)number
{
    _numberOfRows = number;
    
    if (_imageCapArray.count < number) {
        NSInteger amountAdd = number - _imageCapArray.count;
        
        for (int i = 0; i < amountAdd; i++)
        {
            ImageCaption *ic = [[ImageCaption alloc] init];
            [_imageCapArray addObject:ic];
        }
    }
    else if (_imageCapArray.count > number)
    {
        while (_imageCapArray.count > number)
        {
            [_imageCapArray removeLastObject];
        }
    }
    
    
}

#pragma mark - ImageCaption delegate
- (void)onImageReady:(ImageCaption *)ic{
    
    for(ImageCaption *im in _imageCapArray){
        
        if(!im.isPrepared)
            return;
    }
    
    [self.view hideActivityView];
}

#pragma mark - UITableViewSouceData delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"sellCell";
    
    SellingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell ==  nil) {
        cell = [[SellingCell alloc] init];
    }
    
    cell.delegate = self;
    cell.photoImageView.userInteractionEnabled = YES;
    
    
    ImageCaption *imageCaption = _imageCapArray[indexPath.row];
    UIImage *ifImage = imageCaption.image;
    if (ifImage != nil) {
        cell.photoImageView.image = ifImage;
        cell.captionTextField.text = imageCaption.caption;
    }
//    else
//    {
//        cell.photoImageView.image = [UIImage imageNamed:@"sell_upload_photo"];
//        cell.captionTextField.text = @"";
//    }
    
    
    return cell;
}

#pragma mark - cell delegate
- (void)SellingCellDidTapImageView:(SellingCell *)cell withImageView:(UIImageView *)imageView
{
    
    _tmpIndex = [_sellTableView indexPathForCell:cell].row;
    
    [self showCropViewControllerWithOptions:cell.photoImageView andType:2];
    
}

- (void)SellingCellTextField:(SellingCell *)cell caption:(NSString *)caption
{
    NSInteger index = [_sellTableView indexPathForCell:cell].row;
    
    ImageCaption *data = _imageCapArray[index];
    data.caption = caption;
    
}

- (IBAction)nextBtnPressed:(id)sender
{
//    NSMutableArray *checkArray = [[NSMutableArray alloc] init];
//    NSMutableArray *imagecaptionArray = [[NSMutableArray alloc] init];
    
//    for (int i = 0; i < _imageFileArray.count; i++) {
//        if (_imageFileArray[i] != [NSNull null]) {
//            [checkArray addObject:_imageFileArray[i]];
//            
    
            
//            UITableViewCell *cell = [_sellTableView cellForRowAtIndexPath:
//                                     [NSIndexPath indexPathForRow:i inSection:1]];
//            UITextField *textField = (UITextField *)[cell.contentView viewWithTag:i];
////            UITextField *textfield = (UITextField *)[_sellTableView viewWithTag:i];
//            NSLog(@"text field --- %@",textField.text);
//            
//            ImageCaption *imcp = [[ImageCaption alloc] initWithImage:_imageFileArray[i] caption:textField.text];
//            [imagecaptionArray addObject:imcp];
//        }
//    }
    
    if (_imageSelected0)
    {
    
//        [SellingManager sharedSellingManager].photoArray = [_imageFileArray mutableCopy];
        [SellingManager sharedSellingManager].photoCaption = [_imageCapArray mutableCopy];
//        NSLog(@"photo caption array ---- %@",[SellingManager sharedSellingManager].photoCaption);
//        
//        NSArray *imagearray = [SellingManager sharedSellingManager].photoCaption;
//        ImageCaption * imageca = imagearray[0];
//        NSString *caption = imageca.caption;
//        NSLog(@"caption array --- %@",imagearray);
//        NSLog(@"caption ---------- 456 %@",caption);
        
        
    
        NSLog(@"selling manager array --- %@",[SellingManager sharedSellingManager].photoCaption);
        SellingManager *smg = [SellingManager sharedSellingManager];
        for (int i = 0; i < smg.photoCaption.count; i++)
        {
            ImageCaption *ic = smg.photoCaption[i];
            NSLog(@"image --- %@",ic.image);
            NSLog(@"caption --= %@",ic.caption);
        }
        
        
        
        UIViewController *vc = [ViewControllerUtil instantiateViewController:@"selling_view_controller_4"];
        SellingViewController4 *sv = (SellingViewController4 *)vc;
        sv.mySkillInfo = _mySkillInfo;
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
    }
    else
    {
        [ViewControllerUtil showAlertWithTitle:@"" andMessage:@"Please upload at least one photo"];
    }

}


- (void)onImageCropSuccessfulWithImageView:(UIImageView *)imageView
{
    
    ImageCaption *data = _imageCapArray[_tmpIndex];
    data.image = imageView.image;
    
    _imageSelected0 = YES;
    
    
}
@end
