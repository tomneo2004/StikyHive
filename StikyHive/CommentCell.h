//
//  CommentCell.h
//  StikyHive
//
//  Created by User on 21/12/15.
//  Copyright © 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;

- (void)displayProfileImageWithURL:(NSString *)profileImageURL;

@end
