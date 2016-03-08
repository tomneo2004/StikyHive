//
//  ChatMessagesViewController.h
//  StikyHive
//
//  Created by THV1WP15S on 25/1/16.
//  Copyright (c) 2016 Stiky Hive. All rights reserved.
//

#import "JSQMessagesViewController.h"
#import "JSQMessages.h"
#import "ChatData.h"
#import "AudioRecordManager.h"
#import <MediaPlayer/MediaPlayer.h>


@class ChatMessagesViewController;

@protocol ChatMessagesViewControllerDelegate <NSObject>

- (void)didDismissJSQDemoViewController:(ChatMessagesViewController *)vc;

@end



//<<<<<<< HEAD 
@interface ChatMessagesViewController : JSQMessagesViewController <UIActionSheetDelegate, AudioRecordManagerDelegate, ChatDataDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIDocumentInteractionControllerDelegate>
//=======
//@interface ChatMessagesViewController : JSQMessagesViewController <UIActionSheetDelegate, AudioRecordManagerDelegate, ChatDataDelegate, UIDocumentInteractionControllerDelegate>
//>>>>>>> 92249bc647a418dffc66c199be49d645db13fcc9

@property (weak, nonatomic) id<ChatMessagesViewControllerDelegate> delegateModal;
@property (strong, nonatomic) ChatData *chatData;


- (void)closePressed:(UIBarButtonItem *)sender;


+ (void)setToStikyBee:(NSString *)toStikyBee;
+ (void)setToStikyBeeInfoArray:(NSArray *)toStikyBeeArray;

@end
