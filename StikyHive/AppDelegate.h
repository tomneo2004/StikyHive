//
//  AppDelegate.h
//  StikyHive
//
//  Created by Koh Quee Boon on 14/8/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/CloudMessaging.h>

#define PayPal_Production_ClientID @"AcSMFQEQkBScl878ovjdfbv1w5NcHmD-5u527hspX2WN-7zlTWhdFT6vBngF9W39H9dRzBBtuHqHrQ9x"
#define PayPal_Sandbox_ClientID @"AWzun8HFikX3vADqPzhntFQKTgdJ3acgWYKF9s1VueI_GC92LsfWpRXeKElpVVUskEs26p65YejBKlO2"

@interface AppDelegate : UIResponder <UIApplicationDelegate, GGLInstanceIDDelegate, GCMReceiverDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, readonly, strong) NSString *registrationKey;
@property(nonatomic, readonly, strong) NSString *messageKey;
@property(nonatomic, readonly, strong) NSString *gcmSenderID;
@property(nonatomic, readonly, strong) NSDictionary *registrationOptions;

- (void)startGCMService;

@end

