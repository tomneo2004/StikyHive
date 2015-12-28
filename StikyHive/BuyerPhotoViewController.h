//
//  BuyerPhotoViewController.h
//  StikyHive
//
//  Created by THV1WP15S on 23/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "CropPhotoViewController.h"

@interface BuyerPhotoViewController : CropPhotoViewController
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
- (IBAction)nextBtnPressed:(id)sender;

@end
