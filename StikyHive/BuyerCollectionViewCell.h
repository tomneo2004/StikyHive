//
//  BuyerCollectionViewCell.h
//  StikyHive
//
//  Created by User on 15/4/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyerCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

- (void)displayImageWithURL:(NSString *)url;

@end
