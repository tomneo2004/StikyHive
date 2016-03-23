//
//  BuyerCollectionViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 21/9/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "BuyerCollectionViewController.h"
#import "ViewControllerUtil.h"
#import "WebDataInterface.h"
#import "Buyer.h"
#import "BuyerPageViewController.h"
#import "BuyerPostViewController.h"
#import "SelectableLabel.h"

@interface BuyerCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *buyerList;

@end

@implementation BuyerCollectionViewController

static NSString *const reuseIdentifier = @"buyer_cell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _buyerList = @[].mutableCopy;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // --- Do not do this !!!!!!!!!!, this will cause problem while using storyboard!!! -------------------------- //
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    [WebDataInterface getBuyerMarket:@"" limit:0 completion:^(NSObject *obj, NSError *error)
     {
         [self displayResult:(NSDictionary *)obj];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayResult:(NSDictionary *)dict
{
    NSLog(@"skill dict -------------------- %@",dict);
    
    if (dict && dict[@"buyermarkets"]) {
        NSArray *buyers = dict[@"buyermarkets"];
        if (buyers && buyers.count > 0)
        {
           _buyerList = @[].mutableCopy;
        
           for (NSDictionary *buyerDict in buyers)
           {
               [_buyerList addObject:[self createBuyer:buyerDict]];
           }
        
           [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
           [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ViewControllerUtil showAlertWithTitle:@"" andMessage:@"No Data"];
            });
        }
    }
}

- (Buyer *)createBuyer:(NSDictionary *)dict
{
    NSInteger buyerID = [dict[@"id"] integerValue];
    NSString *name = dict[@"name"];
    NSString *location = dict[@"location"];
    NSString *fullPath = location ? [WebDataInterface getFullUrlPath:location] : nil;
    
    if (fullPath)
        [ViewControllerUtil cacheImageForPath:fullPath completion:^(NSObject *obj, NSError *err){}];
    
    return [[Buyer alloc] initWithBuyerId:buyerID name:name location:location];
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _buyerList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:101];
//    SelectableLabel *titleLabel = (SelectableLabel *)[cell viewWithTag:100];
    
    Buyer *buyer = _buyerList[indexPath.row];
    titleLabel.text = buyer.name;
    
    NSString *locationUrl = buyer.location != (id)[NSNull null] ? [WebDataInterface getFullUrlPath:buyer.location] : @"";
    
//    NSLog(@"location url ------- %@",locationUrl);
    
    imageView.image = locationUrl.length > 0 ? [ViewControllerUtil getImageWithPath:locationUrl] : [UIImage imageNamed:@"Default_buyer_post"];
    
    
    
//    titleLabel.index = indexPath.row;
//    titleLabel.userInteractionEnabled = YES;
//    [titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelTapped:)]];
    
    return cell;
}

- (void)titleLabelTapped:(UITapGestureRecognizer *)sender
{
    Buyer *buyer = _buyerList[sender.view.tag];
    
    NSInteger idInteger = buyer.buyerID;
    NSString *location = buyer.location;
    
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"buyer_post_view_controlller"];
    BuyerPostViewController *svc = (BuyerPostViewController *)vc;
    [svc setBuyerId:idInteger];
    [svc setPictureLocation:location];
    
    [self.navigationController pushViewController:svc animated:YES];

    
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:101];
    imageView.image = nil;
    titleLabel.text = nil;
    cell = nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Buyer *buyer = _buyerList[indexPath.row];
//    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"buyer_page_view_controller"];
//    [(BuyerPageViewController *)vc ];
    
//    NSString *buyerid = buyer.buyerID;
    NSInteger idInteger = buyer.buyerID;
    NSString *location = buyer.location;
    
//    NSLog(@"post location picture ------- %@",location);
    
    
    
    UIViewController *vc = [ViewControllerUtil instantiateViewController:@"buyer_post_view_controlller"];
    BuyerPostViewController *svc = (BuyerPostViewController *)vc;
    [svc setBuyerId:idInteger];
    [svc setPictureLocation:location];
    
    [self.navigationController pushViewController:svc animated:YES];


}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
