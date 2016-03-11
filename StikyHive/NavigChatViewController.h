//
//  NavigChatViewController.h
//  StikyHive
//
//  Created by THV1WP15S on 11/3/16.
//  Copyright © 2016 Stiky Hive. All rights reserved.
//

#import "JSQMessagesViewController.h"
#import "JSQMessages.h"
#import "ChatData.h"
#import "AudioRecordManager.h"
#import <MediaPlayer/MediaPlayer.h>

@class NavigChatViewController;

@protocol NavigChatViewControllerDelegate <NSObject>

- (void)didDismissJSQDemoViewController:(NavigChatViewController *)vc;

@end

@interface NavigChatViewController : JSQMessagesViewController <UIActionSheetDelegate, AudioRecordManagerDelegate, ChatDataDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIDocumentInteractionControllerDelegate>


@property (weak, nonatomic) id<NavigChatViewControllerDelegate> delegateModal;
@property (strong, nonatomic) ChatData *chatData;


- (void)closePressed:(UIBarButtonItem *)sender;


+ (void)setToStikyBee:(NSString *)toStikyBee;
+ (void)setToStikyBeeInfoArray:(NSArray *)toStikyBeeArray;

@end
