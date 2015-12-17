//
//  SellingCell.h
//  StikyHive
//
//  Created by THV1WP15S on 9/12/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SellingCell;

@protocol SellingCellDelegate <NSObject>

@optional

- (void)SellingCellDidTapImageView:(SellingCell *)cell withImageView:(UIImageView *)imageView;

- (void)SellingCellTextField:(SellingCell *)cell caption:(NSString *)caption;

//- (void)SellingImageView:(SellingCell *)cell image:(UIImage *)image;

@end

@interface SellingCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UITextField *captionTextField;

@property (weak, nonatomic) id<SellingCellDelegate> delegate;


//- (void)displayDefaultImage:(NSString *)defaultImage;

@end
