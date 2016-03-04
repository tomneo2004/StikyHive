//
//  ChatMessagesViewController.m
//  StikyHive
//
//  Created by THV1WP15S on 25/1/16.
//  Copyright (c) 2016 Stiky Hive. All rights reserved.
//

#import "ChatMessagesViewController.h"

#import "WebDataInterface.h"
#import "LocalDataInterface.h"
#import "ViewControllerUtil.h"
#import <Google/CloudMessaging.h>

#import "AttachmentViewController.h"
#import "AudioMediaItem.h"
#import "OfferMediaItem.h"

#import "ViewControllerUtil.h"


@interface ChatMessagesViewController ()


@property (nonatomic, strong) UIButton *pttButton;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIImage *audioImage;

@property (nonatomic, strong) NSMutableDictionary *audioData;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UILabel *pttInfoLabel;
@property (nonatomic, strong) UILabel *pttTimeLabel;

@property (nonatomic, assign) NSInteger messagesSent;


@end

@implementation ChatMessagesViewController

static NSString *ToStikyBee = nil;
static NSString *recipientID = nil;
static NSString *senderID = nil;
static NSString *fullName = nil;
static NSString *profilePic = nil;

+ (void)setToStikyBee:(NSString *)toStikyBee
{
    ToStikyBee = toStikyBee;
    NSLog(@"to stiky bee --- %@",ToStikyBee);
    
}

+ (void)setToStikyBeeInfoArray:(NSArray *)toStikyBeeArray
{
    
    NSLog(@"info array ---- %@",toStikyBeeArray);
    ToStikyBee = toStikyBeeArray[0];
    NSLog(@"to stiky bee ---- %@",ToStikyBee);
    fullName = toStikyBeeArray[1];
    profilePic = [WebDataInterface getFullUrlPath:toStikyBeeArray[2]];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (fullName != nil) {
        self.title = fullName;
    }
    
    self.senderId = [LocalDataInterface retrieveStkid];
    
    self.senderDisplayName = [LocalDataInterface retrieveUsername];
    
    
    UIImage *profileImage = [UIImage imageNamed:@"Default_profile_small@2x"];
    if (profilePic != nil)
    {
        profileImage = [ViewControllerUtil getImageWithPath:profilePic];
    }
    
   
    _chatData = [[ChatData alloc] initWithIncomingAvatarImage:profileImage incomingID:ToStikyBee incomingDisplayName:fullName outgoingID:self.senderId outgoingDisplayName:self.senderDisplayName];
    
    _chatData.delegate = self;
    
    
//    self.showLoadEarlierMessagesHeader = YES;
    
    
    UIBarButtonItem *callButton = [ViewControllerUtil createBarButton:@"button_call_header" onTarget:self withSelector:@selector(callPressedd)];
    callButton.imageInsets = UIEdgeInsetsMake(0, -15, 0, 15);
    self.navigationItem.rightBarButtonItems = @[callButton];
    self.navigationController.navigationBar.topItem.title = @"";
    
    
    /**
     * Register custom menu actions for cells
     */
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(customAction:)];
    [UIMenuController sharedMenuController].menuItems = @[ [[UIMenuItem alloc] initWithTitle:@"Custom Action" action:@selector(customAction:)]];
    
    
    /*
     * Customize toolbar buttons
     */
    _sendButton = [JSQMessagesToolbarButtonFactory defaultSendButtonItem];
    _pttButton = [JSQMessagesToolbarButtonFactory defaultPPTButtonItem];
    
    self.inputToolbar.contentView.rightBarButtonItem = _pttButton;
    self.inputToolbar.contentView.rightBarButtonItem.enabled = YES;
    
    
    NSLog(@"my stikid ---- %@",[LocalDataInterface retrieveStkid]);
    NSLog(@"to stiky bee -- %@",ToStikyBee);
    [WebDataInterface selectToken:[LocalDataInterface retrieveStkid] recipientId:ToStikyBee completion:^(NSObject *obj, NSError *err) {
        
        NSLog(@"token info ---- %@",obj);
        
        NSDictionary *dict = (NSDictionary *)obj;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (dict && [dict[@"status"] isEqualToString:@"success"])
            {
                recipientID = dict[@"recipientId"][@"deviceToken"];
                
                NSLog(@"recipeint id token --- %@",recipientID);
                senderID = dict[@"senderId"][@"deviceToken"];
                NSLog(@"recipientid ---- %@",senderID);
            }
            
        });
    }];
    
    /*
     * Show earlier messages url
     */
//    [WebDataInterface selectChatMsgs:@"15AAAAAE" toStikyBee:@"15AAAABX" limit:7 completion:^(NSObject *obj, NSError *err)
//     {
//        
//         NSLog(@"chat obj--- %@",obj);
//         
//         
//     }];
//    
    
    
    
    
    
    _audioImage = [UIImage imageNamed:@"audio_message@2x"];
    
    //listen to message receive notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:@"onMessageReceived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOfferAccept:) name:acceptOfferNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOfferCancel:) name:cancelOfferNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // set chat list backgroud
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.bounds];
    background.image = [UIImage imageNamed:@"chat_bg"];
    [background setContentMode:UIViewContentModeScaleAspectFill];
    [background setClipsToBounds:YES];
    self.collectionView.backgroundView = background;
    
    
    if (self.delegateModal) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closePressed:)];
    }
    
    [self.tabBarController.tabBar setHidden:YES];
    
    _profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(290, 2, 36, 36)];
    _profileImageView.image = [UIImage imageNamed:@"Default_profile_small@2x"];
    _profileImageView.layer.cornerRadius = 18;
    _profileImageView.layer.masksToBounds = YES;
    
    [self.navigationController.navigationBar addSubview:_profileImageView];
    
}



- (void)viewWillDisappear:(BOOL)animated
{
    [_profileImageView removeFromSuperview];
    
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onMessageReceived" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:acceptOfferNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:cancelOfferNotification object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closePressed:(UIBarButtonItem *)sender
{
    [self.delegateModal didDismissJSQDemoViewController:self];
}

- (void)customAction:(id)sender
{
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0)
    {
        self.inputToolbar.contentView.rightBarButtonItem = _sendButton;
    }
    else
    {
        self.inputToolbar.contentView.rightBarButtonItem = _pttButton;
        self.inputToolbar.contentView.rightBarButtonItem.enabled = YES;
    }
}


#pragma mark - JSQMessageViewController method overrides

- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
    if (button == _sendButton)
    {
        
        [JSQSystemSoundPlayer jsq_playMessageSentSound];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:senderDisplayName date:date text:text];
        
        [self.chatData.messages addObject:message];
        [self finishSendingMessageAnimated:YES];
        
        
        // sending message use gcm
        NSInteger nextMessageID = self.messagesSent++;
        
        
        
        NSDictionary *data = @{@"fileName":[NSNull null],
                                   @"msg":text,
                                   @"offerId":[NSNumber numberWithInteger:0],
                                   @"offerStatus":[NSNumber numberWithInteger:0],
                                   @"price":[NSNull null],
                                   @"rate":[NSNull null],
                                   @"name":[NSNull null],
                                   @"message":text,
                                   @"recipientStkid":ToStikyBee,
                                   @"chatRecipient":fullName,
                                   @"chatRecipientUrl":profilePic,
                                   @"senderToken":senderID,
                                   @"recipientToken":recipientID};
        
        
        NSLog(@"msg : %@",text);
        NSLog(@"message : %@",text);
        NSLog(@"recipientStkid : %@",ToStikyBee);
        NSLog(@"chatRecipient : %@",fullName);
        NSLog(@"chatRecipientUrl : %@",profilePic);
        NSLog(@"senderToken : %@",senderID);
        NSLog(@"recipientToken : %@",recipientID);
        
        //131981869263 ------ sender ID
        NSLog(@"to-- recipientiD ----- %@",recipientID);
        NSString *to = [NSString stringWithFormat:@"%@@gcm.googleapis.com",recipientID];
        
        [[GCMService sharedInstance] sendMessage:data to:to withId:[NSString stringWithFormat:@"%ld",(long)nextMessageID]];
        
        NSLog(@"gcm");
        NSLog(@"text ----- %@",text);
        
        self.inputToolbar.contentView.rightBarButtonItem = _pttButton;
        self.inputToolbar.contentView.rightBarButtonItem.enabled = YES;
        
    }
    else
    {
        
    }
}


- (void)sendMessage:(NSString *)to
{
    // create the request
    NSString *sendUrl = @"https://android.googleapis.com/gcm/send";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:sendUrl]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"key=AIzaSyCvIIIK7xwfLD5in_ypUiGyQWTJYrIzXOk" forHTTPHeaderField:@"Authorization"];
    [request setTimeoutInterval:60];
    
    //prepare the payload
    
    
    
    
}


#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView
       messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.chatData.messages objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
             messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [self.chatData.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId])
    {
        return self.chatData.outgoingBubbleImageData;
    }
    
    return self.chatData.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
                    avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
    JSQMessage *message = [self.chatData.messages objectAtIndex:indexPath.item];
    
    /*
     if ([message.senderId isEqualToString:self.senderId])
     {
     if (![NSUserDefaults outgoingAvatarSetting])
     {
     return nil;
     }
     }
     else
     {
     if (![NSUserDefaults incomingAvatarSetting])
     {
     return nil;
     }
     }
     */
    
    if ([message.senderId isEqualToString:self.senderId])
    {
        return _chatData.outgoingAvatar;
    }
    else
    {
        return _chatData.incomingAvatar;
    }
}


- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0)
    {
        JSQMessage *message = [self.chatData.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.chatData.messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId])
    {
        return nil;
    }
    
    if (indexPath.item - 1 > 0)
    {
        JSQMessage *previousMessage = [self.chatData.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId])
        {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    //  return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}





#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.chatData.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [self.chatData.messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage)
    {
        UIColor *black = [UIColor blackColor];
        UIColor *brown = [UIColor colorWithRed:0.24 green:0.18 blue:0.12 alpha:0.8];
        cell.textView.textColor = [msg.senderId isEqualToString:self.senderId] ? black : brown;
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    return cell;
}


#pragma mark - UICollectionView Delegate

#pragma mark - Custom menu items

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:))
    {
        return YES;
    }
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:))
    {
        [self customAction:sender];
        return;
    }
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}




#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0)
    {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}


- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.chatData.messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId])
    {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0)
    {
        JSQMessage *previousMessage = [self.chatData.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]])
        {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}


- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
//    JSQMessage *message = _chatData.messages[indexPath.row];
//    ProfileViewController *pvc = (ProfileViewController *)[ViewControllerUtil instantiateViewController:@"profile_view_controller"];
//    [pvc setUserID:message.senderId];
//    [self.navigationController pushViewController:pvc animated:YES];
    NSLog(@"tappped avatar");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
//    JSQMessage *message = _chatData.messages[indexPath.row];
//    if (message.isMediaMessage)
//    {
//        JSQPhotoMediaItem *mediaItem = (JSQPhotoMediaItem *) message.media;
//        if (mediaItem.image == _audioImage)
//        {
//            NSString *audioLoc = _audioData[message.senderDisplayName];
//            NSString *fullPath = [WebDataInterface getFullStoragePath:audioLoc];
//            [_soundRecorder playAudio:fullPath];
//        }
//        else
//        {
//            [PhotoViewController setImage:mediaItem.image];
//            UIViewController *vc = [ViewControllerUtil instantiateViewController:@"photo_view_controller"];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }
    NSLog(@"tapped message bubble");
    
    JSQMessage *msg = [_chatData.messages objectAtIndex:indexPath.row];
    
    if(msg.media != nil){
        
        if([msg.media isKindOfClass:[JSQPhotoMediaItem class]]){
            
            JSQPhotoMediaItem *pItem = (JSQPhotoMediaItem *)msg.media;
            
            AttachmentViewController *controller = (AttachmentViewController *)[ViewControllerUtil instantiateViewController:@"AttachmentViewController"];
            controller.image = pItem.image;
            
            [self.navigationController pushViewController:controller animated:YES];
        }
        else if([msg.media isKindOfClass:[AudioMediaItem class]]){
            
            AudioMediaItem *aItem = (AudioMediaItem *)msg.media;
            
            [aItem playAudio];
        }
        /*
        else if([msg.media isKindOfClass:[OfferMediaItem class]]){
            
            OfferMediaItem *oItem = (OfferMediaItem *)msg.media;
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Offer" message:oItem.fullString preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                //send accept offer
                NSLog(@"need implement sending accpt offer message");
            }];
            
            UIAlertAction *rejectAction = [UIAlertAction actionWithTitle:@"Reject" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                //send reject offer
                NSLog(@"need implement sending reject offer message");
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //cancel
            }];
            
            [alertController addAction:acceptAction];
            [alertController addAction:rejectAction];
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
         */
    }
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}


- (void)didPressAccessoryButton:(UIButton *)sender
{
    [self.inputToolbar.contentView.textView resignFirstResponder];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Send photo",@"Send file",@"Trasaction", @"Record audio", nil];
    
    [sheet showFromToolbar:self.inputToolbar];
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        return;
    }
    
    switch (buttonIndex)
    {
        case 0:
            break;
        case 1:
        {
            
        }
            break;
        case 3:
        {
            //present audio recording view
            [[AudioRecordManager sharedAudioRecordManagerWithDelegate:self] presentAudioRecorder];
            
            return;
        }
            
        default:
            break;
    }
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    [self finishSendingMessageAnimated:YES];
    
}

#pragma mark - AudioRecordManager delegate

- (void)beginRecordingAudio{
    
    NSLog(@"begin audio recording");
}

- (void)endRecordingAudioWithFilePath:(NSString *)audioFilePath{
    
    NSLog(@"end audio recording, file at %@", audioFilePath);
}

- (void)beginPlayingAudio{
    
    NSLog(@"being playing record audio");
}

- (void)endPlayingAudio{
    
    NSLog(@"end playing record audio");
}

- (void)recordingViewDismiss{
    
    NSLog(@"audio recording view dismiss");
}

- (void)confirmRecordAudioWithFilePath:(NSString *)audioFilePath{
    
    NSLog(@"confirm using recording audio at path %@", audioFilePath);
    
    //upload audio to server before you do following code
    [self.chatData addAudioMediaMessageWithURL:@"https://" withAudioDuration:10];
    [self finishSendingMessageAnimated:YES];
}

#pragma mark - OfferMediaItem notification handler
- (void)onOfferAccept:(NSNotification *)notification{
    
    //todo:send offer accept
    NSLog(@"need to implement sending offer accept message");
}

- (void)onOfferCancel:(NSNotification *)notification{
    
    //todo:send offer cancel
    NSLog(@"need to implement sending offer cancel message");
}

#pragma mark - Message receive notification handler
- (void)receiveMessage:(NSNotification *)notification{
    
    //make sure message is send from the right person
    if([notification.userInfo[@"recipientStkid"] isEqualToString:ToStikyBee]){
        
        [self processMessage:notification.userInfo];
    }
}

#pragma mark - Process message
- (void)processMessage:(NSDictionary *)dic{
    
    if([dic[@"message"] isEqualToString:@"null"]){ //make offer
        
        BOOL refreshView = NO;
        
        if([dic[@"offerStatus"] integerValue]==0 || [dic[@"offerStatus"] integerValue]==2){//make offer
            
            NSLog(@"sender make offer");
            
            [_chatData addIncomingOfferWithOfferId:[dic[@"offerId"] integerValue] withOfferStatus:[dic[@"offerStatus"] integerValue] withPrice:[dic[@"price"] doubleValue] withOfferName:dic[@"name"] withOfferRate:dic[@"rate"]];
            
            refreshView = YES;
        }
        /*
        else if([dic[@"offerStatus"] integerValue]==-1 || [dic[@"offerStatus"] integerValue]==-2){//reject offer
            
            JSQMessage *rejectMsg = [[JSQMessage alloc] initWithSenderId:dic[@"recipientStkid"] senderDisplayName:dic[@"chatRecipient"] date:[NSDate date] text:@"Rejected Offer"];
            
            [_chatData.messages addObject:rejectMsg];
            
            refreshView = YES;
        }
        else if([dic[@"offerStatus"] integerValue]==1 || [dic[@"offerStatus"] integerValue]==3){//accept offer
            
            if([dic[@"offerStatus"] integerValue]==1){
                
                //stikypay
                AcceptOfferMessage *acceptMsg = [[AcceptOfferMessage alloc] initWithSenderId:dic[@"recipientStkid"] senderDisplayName:dic[@"chatRecipient"] date:[NSDate date] text:@"Accepted Offer. Make payment here"];
                
                acceptMsg.stikypay = YES;
                
                refreshView = YES;
            }
            else if([dic[@"offerStatus"] integerValue]==3){
                
                //no stikypay
                AcceptOfferMessage *acceptMsg = [[AcceptOfferMessage alloc] initWithSenderId:dic[@"recipientStkid"] senderDisplayName:dic[@"chatRecipient"] date:[NSDate date] text:@"Accepted Offer."];
                
                acceptMsg.stikypay = NO;
                
                refreshView = YES;
            }
        }
        */
        
        if(refreshView){
            
            [self scrollToBottomAnimated:YES];
            [self.collectionView reloadData];
        }
       
    }
    else if([dic[@"message"] rangeOfString:@"<span"].location != NSNotFound){//accept offer
        
        [_chatData addincomingAcceptOffer:dic[@"message"]];
        
        [self scrollToBottomAnimated:YES];
        [self.collectionView reloadData];
    }
    else if([dic[@"message"] rangeOfString:@"Rejected offer"].location != NSNotFound){//reject offer
        
        JSQMessage *rejectMsg = [[JSQMessage alloc] initWithSenderId:dic[@"recipientStkid"] senderDisplayName:dic[@"chatRecipient"] date:[NSDate date] text:dic[@"message"]];
        
        [_chatData.messages addObject:rejectMsg];
        
        [self scrollToBottomAnimated:YES];
        [self.collectionView reloadData];
    }
    else if((dic[@"fileName"] != nil) && ([dic[@"message"] rangeOfString:@"<img"].location != NSNotFound) && ([dic[@"msg"] rangeOfString:@"Image"].location != NSNotFound)){//image
        
        NSLog(@"sender send Image");
        
        NSString *urlStr = [WebDataInterface getFullUrlPath:dic[@"fileName"]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        /*
         NSURL *imageURL = [NSURL URLWithString:urlStr];
         UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
         */
        
        [_chatData addIncomingPhotoMessage:urlStr];
        
        [self scrollToBottomAnimated:YES];
        [self.collectionView reloadData];
    }
    else if((dic[@"fileName"] != nil) && ([dic[@"message"] rangeOfString:@"<img"].location != NSNotFound) && ([dic[@"msg"] rangeOfString:@"Voice"].location != NSNotFound)){
        
        NSLog(@"sender send audio");
        
        NSString *urlStr = [WebDataInterface getFullUrlPath:dic[@"fileName"]];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        [_chatData addIncomingAudioMediaMessage:urlStr];
        
        [self scrollToBottomAnimated:YES];
        [self.collectionView reloadData];
    }
    else{
        
        //text
        JSQMessage *textMsg = [[JSQMessage alloc] initWithSenderId:dic[@"recipientStkid"] senderDisplayName:dic[@"chatRecipient"] date:[NSDate date] text:dic[@"msg"]];
        
        [_chatData.messages addObject:textMsg];
        
        [self scrollToBottomAnimated:YES];
        [self.collectionView reloadData];
    }
    
}

#pragma mark - ChatData delegate
- (void)onReceivePhotoReadyToPresent{
    
    [self scrollToBottomAnimated:YES];
    [self.collectionView reloadData];
}

//#pragma mark - MPMoviePlayerController notification handler
//-(void) movieFinishedCallback:(NSNotification*)notification{
//    
//    MPMoviePlayerController *player = [notification object];
//    
//    [player.view removeFromSuperview];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
//    
//    _mPlayer = nil;
//}




@end
