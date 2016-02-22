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



@interface ChatMessagesViewController ()


@property (nonatomic, strong) UIButton *pttButton;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIImage *audioImage;

@property (nonatomic, strong) NSMutableDictionary *audioData;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UILabel *pttInfoLabel;
@property (nonatomic, strong) UILabel *pttTimeLabel;



@end

@implementation ChatMessagesViewController

static NSString *ToStikyBee = nil;

+ (void)setToStikyBee:(NSString *)toStikyBee
{
    ToStikyBee = toStikyBee;
    NSLog(@"to stiky bee --- %@",ToStikyBee);
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.senderId = [LocalDataInterface retrieveStkid];
    self.senderDisplayName = @"echo";
    
   
    _chatData = [[ChatData alloc] initWithIncomingAvatarImage:[UIImage imageNamed:@"Default_profile_small@2x"] incomingID:@"" incomingDisplayName:@"" outgoingID:self.senderId outgoingDisplayName:self.senderDisplayName];
    
    
    
    
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
    
    
    
    /*
     * Show earlier messages url
     */
    [WebDataInterface selectChatMsgs:@"15AAAAAE" toStikyBee:@"15AAAABX" limit:7 completion:^(NSObject *obj, NSError *err)
     {
        
         NSLog(@"chat obj--- %@",obj);
         
         
     }];
    
    
    
    
    
    
    _audioImage = [UIImage imageNamed:@"audio_message@2x"];
    
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
        
        
        
        self.inputToolbar.contentView.rightBarButtonItem = _pttButton;
        self.inputToolbar.contentView.rightBarButtonItem.enabled = YES;
        
        
    }
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
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}


- (void)didPressAccessoryButton:(UIButton *)sender
{
    [self.inputToolbar.contentView.textView resignFirstResponder];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Send photo",@"Send file",@"Trasaction", nil];
    
    [sheet showFromToolbar:self.inputToolbar];
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    [self finishSendingMessageAnimated:YES];
    
}



@end
