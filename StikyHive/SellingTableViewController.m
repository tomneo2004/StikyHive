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

@interface SellingTableViewController ()

@property (nonatomic, assign) NSInteger numberOfRows;
@property (weak, nonatomic) IBOutlet UITableView *sellTableView;

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

@end

@implementation SellingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imageFileArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++)
    {
        [_imageFileArray insertObject:[NSNull null] atIndex:i];
    }

    SellingManager *smg = [SellingManager sharedSellingManager];
    
    _numberOfRows = 4;
    
    
//    _imageFileArray = [smg.photoArray mutableCopy];
//    NSLog(@"4 image file array --- %@",_imageFileArray);
    if (smg.videoStatus) {
        _imageFileArray = [smg.photoArray mutableCopy];
        NSLog(@"4 image file array --- %@",_imageFileArray);
    }
    
    if (smg.photoStatus)
    {
        _numberOfRows = 8;
        
        _imageFileArray = [[SellingManager sharedSellingManager].photoArray mutableCopy];
        
        for (int i = 4; i < 8; i++)
        {
            [_imageFileArray insertObject:[NSNull null] atIndex:i];
        }

        NSLog(@"8 image file array --- %@",_imageFileArray);
    }
    
    _sellTableView.delegate = self;
    _sellTableView.dataSource = self;
    
    _imageDict = [[NSMutableDictionary alloc] init];
    NSLog(@"crop dicr ---- %@",_imageDict);
    
    
    
//    [_sellTableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    if (_imageFileArray[indexPath.row] != [NSNull null])
    {
        cell.photoImageView.image = _imageFileArray[indexPath.row];
        NSLog(@"image copy ---  %ld",(long)indexPath.row);
    }
    else
    {
        NSLog(@"no image --- %ld",(long)indexPath.row);
    }
    
    return cell;
}

#pragma mark - cell delegate
- (void)SellingCellDidTapImageView:(SellingCell *)cell
{
    
    [self showCropViewControllerWithOptions:cell.photoImageView andType:2];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)nextBtnPressed:(id)sender
{
    NSMutableArray *checkArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _imageFileArray.count; i++) {
        if (_imageFileArray[i] != [NSNull null]) {
            [checkArray addObject:_imageFileArray[i]];
        }
    }
    
    if (checkArray.count > 0)
    {
        
        [SellingManager sharedSellingManager].photoArray = [_imageFileArray mutableCopy];
    
        NSLog(@"selling manager array --- %@",[SellingManager sharedSellingManager].photoArray);
        
    
        UIViewController *vc = [ViewControllerUtil instantiateViewController:@"selling_view_controller_4"];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    else
    {
        [ViewControllerUtil showAlertWithTitle:@"" andMessage:@"Please upload at least one photo"];
    }

}


- (void)onImageCropSuccessfulWithImageView:(UIImageView *)imageView
{
    if (imageView.tag == 0) {
        _imageSelected0 = YES;
        UIImage *image = imageView.image;
        [_imageFileArray replaceObjectAtIndex:0 withObject:image];
        
    }
    else if (imageView.tag == 1) {
        _imageSelected1 = YES;
        UIImage *image = imageView.image;
        [_imageFileArray replaceObjectAtIndex:1 withObject:image];
    }
    else if (imageView.tag == 2) {
        _imageSelected2 = YES;
        UIImage *image = imageView.image;
        [_imageFileArray replaceObjectAtIndex:2 withObject:image];
    }
    else if (imageView.tag == 3) {
        _imageSelected3 = YES;
        UIImage *image = imageView.image;
        [_imageFileArray replaceObjectAtIndex:3 withObject:image];
    }
    else if (imageView.tag == 4) {
        _imageSelected4 = YES;
        UIImage *image = imageView.image;
        [_imageFileArray replaceObjectAtIndex:4 withObject:image];
    }
    else if (imageView.tag == 5) {
        _imageSelected5 = YES;
        UIImage *image = imageView.image;
        [_imageFileArray replaceObjectAtIndex:5 withObject:image];
    }
    else if (imageView.tag == 6) {
        _imageSelected6 = YES;
        UIImage *image = imageView.image;
        [_imageFileArray replaceObjectAtIndex:6 withObject:image];
    }
    else if (imageView.tag == 7) {
        _imageSelected7 = YES;
        UIImage *image = imageView.image;
        [_imageFileArray replaceObjectAtIndex:7 withObject:image];
    }






    
    
    
}
@end
