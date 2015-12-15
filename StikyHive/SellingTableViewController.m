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

@interface SellingTableViewController ()

@property (nonatomic, assign) NSInteger numberOfRows;
@property (weak, nonatomic) IBOutlet UITableView *sellTableView;

//@property (nonatomic, assign) NSInteger tmpIndex;

@property (nonatomic, assign) BOOL imageSelected0;
@property (nonatomic, assign) BOOL imageSelected1;
@property (nonatomic, assign) BOOL imageSelected2;
@property (nonatomic, assign) BOOL imageSelected3;
@property (nonatomic, assign) BOOL imageSelected4;
@property (nonatomic, assign) BOOL imageSelected5;
@property (nonatomic, assign) BOOL imageSelected6;
@property (nonatomic, assign) BOOL imageSelected7;

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
    
    _imageCapArray = smg.photoCaption;
    
    
    if (!smg.photoStatus) {
        [self setDefaultImageCount:4];
        _numberOfRows = 4;
    }
    else
    {
        [self setDefaultImageCount:8];
        _numberOfRows = 8;
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
    
    _addArray = [[NSMutableArray alloc] init];
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
    
    _imageDict = [[NSMutableDictionary alloc] init];
    NSLog(@"crop dicr ---- %@",_imageDict);
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    //    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];

    
//    [_sellTableView reloadData];
    
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
        
        for (int i = 0; i < amountAdd; i++) {
            ImageCaption *ic = [[ImageCaption alloc] init];
            [_imageCapArray addObject:ic];
        }
    }
    else if (_imageCapArray.count > number)
    {
        while (_imageCapArray.count > number) {
            [_imageCapArray removeLastObject];
        }
    }
    
    
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
    
//    [cell displayDefaultImage:@"sell_upload_photo"];
    cell.photoImageView.tag = indexPath.row;
//    cell.captionTextField.tag = indexPath.row;
    
    
    ImageCaption *imageCaption = _imageCapArray[indexPath.row];
    UIImage *ifImage = imageCaption.image;
    if (ifImage != nil) {
        cell.photoImageView.image = ifImage;
        cell.captionTextField.text = imageCaption.caption;
    }
    
    
//    if (_imageFileArray[indexPath.row] != [NSNull null])
//    {
//        cell.photoImageView.image = _imageFileArray[indexPath.row];
//        NSLog(@"image copy ---  %ld",(long)indexPath.row);
//    }
//    else
//    {
//        NSLog(@"no image --- %ld",(long)indexPath.row);
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
    NSMutableArray *checkArray = [[NSMutableArray alloc] init];
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
    
//    if (checkArray.count > 0)
//    {
    
        
        
//        [SellingManager sharedSellingManager].photoArray = [_imageFileArray mutableCopy];
//        [SellingManager sharedSellingManager].photoCaption = [_imageCapArray mutableCopy];
//        NSLog(@"photo caption array ---- %@",[SellingManager sharedSellingManager].photoCaption);
//        
//        NSArray *imagearray = [SellingManager sharedSellingManager].photoCaption;
//        ImageCaption * imageca = imagearray[0];
//        NSString *caption = imageca.caption;
//        NSLog(@"caption array --- %@",imagearray);
//        NSLog(@"caption ---------- 456 %@",caption);

        
    
        NSLog(@"selling manager array --- %@",[SellingManager sharedSellingManager].photoCaption);
        
    
        UIViewController *vc = [ViewControllerUtil instantiateViewController:@"selling_view_controller_4"];
        [self.navigationController pushViewController:vc animated:YES];
        
        
//    }
//    else
//    {
//        [ViewControllerUtil showAlertWithTitle:@"" andMessage:@"Please upload at least one photo"];
//    }

}


- (void)onImageCropSuccessfulWithImageView:(UIImageView *)imageView
{
    
//   UITableViewCell *cell = [_sellTableView cellForRowAtIndexPath:[NSIndexPath indexPathWithIndex:_tmpIndex]];
//    
//    cell.imageView.image = imageView.image;
    
    
    
    
    ImageCaption *data = _imageCapArray[_tmpIndex];
    data.image = imageView.image;
    
    
//    if (imageView.tag == 0) {
//        _imageSelected0 = YES;
//        UIImage *image = imageView.image;
////        [_imageFileArray replaceObjectAtIndex:0 withObject:image];
//        
//        
//        ImageCaption *data = _imageCapArray[0];
//        data.image = image;
//
////        UITextField *textfield = (UITextField *)[_sellTableView viewWithTag:0];
////        ImageCaption *imcp = [[ImageCaption alloc] initWithImage:imageView.image caption:textfield.text];
////        [_addArray addObject:imcp];
//        
//    }
//    else if (imageView.tag == 1) {
//        _imageSelected1 = YES;
//        UIImage *image = imageView.image;
////        [_imageFileArray replaceObjectAtIndex:1 withObject:image];
//        ImageCaption *data = _imageCapArray[1];
//        data.image = image;
//    }
//    else if (imageView.tag == 2) {
//        _imageSelected2 = YES;
//        UIImage *image = imageView.image;
////        [_imageFileArray replaceObjectAtIndex:2 withObject:image];
//        ImageCaption *data = _imageCapArray[2];
//        data.image = image;
//    }
//    else if (imageView.tag == 3) {
//        _imageSelected3 = YES;
//        UIImage *image = imageView.image;
////        [_imageFileArray replaceObjectAtIndex:3 withObject:image];
//        ImageCaption *data = _imageCapArray[3];
//        data.image = image;
//    }
//    else if (imageView.tag == 4) {
//        _imageSelected4 = YES;
//        UIImage *image = imageView.image;
////        [_imageFileArray replaceObjectAtIndex:4 withObject:image];
//        ImageCaption *data = _imageCapArray[4];
//        data.image = image;
//    }
//    else if (imageView.tag == 5) {
//        _imageSelected5 = YES;
//        UIImage *image = imageView.image;
////        [_imageFileArray replaceObjectAtIndex:5 withObject:image];
//        ImageCaption *data = _imageCapArray[5];
//        data.image = image;
//    }
//    else if (imageView.tag == 6) {
//        _imageSelected6 = YES;
//        UIImage *image = imageView.image;
////        [_imageFileArray replaceObjectAtIndex:6 withObject:image];
//        ImageCaption *data = _imageCapArray[6];
//        data.image = image;
//    }
//    else if (imageView.tag == 7) {
//        _imageSelected7 = YES;
//        UIImage *image = imageView.image;
////        [_imageFileArray replaceObjectAtIndex:7 withObject:image];
//        ImageCaption *data = _imageCapArray[7];
//        data.image = image;
//    }
    
}
@end
