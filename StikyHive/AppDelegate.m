//
//  AppDelegate.m
//  StikyHive
//
//  Created by Koh Quee Boon on 14/8/15.
//  Copyright (c) 2015 Stiky Hive. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <linkedin-sdk/LISDK.h>
#import "PayPalMobile.h"
#import <Google/CloudMessaging.h>
#import "WebDataInterface.h"
#import "LocalDataInterface.h"

#import "ChatMessagesViewController.h"
#import "NavigChatViewController.h"


@interface AppDelegate ()

@property(nonatomic, strong) void (^registrationHandler)
(NSString *registrationToken, NSError *error);
@property(nonatomic, assign) BOOL connectedToGCM;
@property(nonatomic, strong) NSString* registrationToken;
@property(nonatomic, assign) BOOL subscribedToTopic;

@end

NSString *const SubscriptionTopic = @"/topics/global";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([LISDKCallbackHandler shouldHandleUrl:url]) {
        return [LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    
    else {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                          sourceApplication:sourceApplication
                                                          annotation:annotation];
        
    }
    
    return YES; 
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _registrationKey = @"onRegistrationCompleted";
    _messageKey = @"onMessageReceived";
    
    //paypal setup
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : PayPal_Production_ClientID, PayPalEnvironmentSandbox : PayPal_Sandbox_ClientID}];
    
    // --- Set the Global appearance of to Navigation Bar and bottom Tab Bar --- //
    
    UIColor *yellow = [UIColor colorWithRed:1.0 green:0.9 blue:0.0 alpha:1.0];
//    UIColor *brown = [UIColor colorWithRed:80.0/255 green:60.0/255 blue:43.0/255 alpha:1.0];
    UIColor *brown = [UIColor colorWithRed:63.0/255 green:46.0/255 blue:31.0/255 alpha:1.0];
    UIColor *green = [UIColor colorWithRed:0 green:167.0/255 blue:155.0/255 alpha:1.0];
    [[UINavigationBar appearance] setTintColor:yellow];
    [[UINavigationBar appearance] setBarTintColor:brown];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UITabBar appearance] setTintColor:green];
    //    [[UITabBar appearance] setBarTintColor:yellow];
    
    [[UINavigationBar appearance] setTintColor:[UIColor lightGrayColor]];
    
    
//    [self startGCMService];
    
    
//    // check for push notification
//    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    if (notification) {
//        NSLog(@"app recieved notification from remote %@",notification);
//        [self application:application didReceiveRemoteNotification:(NSDictionary *)notification];
//    }
//    else
//    {
//        NSLog(@"app did not recieve notification");
//    }
    
    
    
//    [self startGCMService];
    
    //end
    
//    return YES;
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    GGLInstanceIDConfig *instanceIDConfig = [GGLInstanceIDConfig defaultConfig];
    instanceIDConfig.delegate = self;
    // Start the GGLInstanceID shared instance with the that config and request a registration
    // token to enable reception of notifications
    [[GGLInstanceID sharedInstance] startWithConfig:instanceIDConfig];
    _registrationOptions = @{kGGLInstanceIDRegisterAPNSOption:deviceToken,
                             kGGLInstanceIDAPNSServerTypeSandboxOption:@YES};
    [[GGLInstanceID sharedInstance] tokenWithAuthorizedEntity:_gcmSenderID
                                                        scope:kGGLInstanceIDScopeGCM
                                                      options:_registrationOptions
                                                      handler:_registrationHandler];
    
    /*
     *
     */
//    GCMConfig *config = [GCMConfig defaultConfig];
//    config.logLevel = kGCMLogLevelDebug;
//    config.receiverDelegate = [[GCMReceiver alloc] init];
//    [config.receiverDelegate] =
    
}

// [START receive_apns_token_error]
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Registration for remote notification failed with error: %@", error.localizedDescription);
    // [END receive_apns_token_error]
    NSDictionary *userInfo = @{@"error" :error.localizedDescription};
    [[NSNotificationCenter defaultCenter] postNotificationName:_registrationKey
                                                        object:nil
                                                      userInfo:userInfo];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    
    
    
    
    NSLog(@"Notification received from gcm: %@", userInfo);
    // This works only if the app started the GCM service
    [[GCMService sharedInstance] appDidReceiveMessage:userInfo];
    // Handle the received message
    
    // [START_EXCLUDE]
    [[NSNotificationCenter defaultCenter] postNotificationName:_messageKey
                                                        object:nil
                                                      userInfo:userInfo];
    
    
    
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    NSLog(@"Notification received completion handler: %@", userInfo);
    // This works only if the app started the GCM service
    [[GCMService sharedInstance] appDidReceiveMessage:userInfo];
    // Handle the received message
    // Invoke the completion handler passing the appropriate UIBackgroundFetchResult value
    // [START_EXCLUDE]
    [[NSNotificationCenter defaultCenter] postNotificationName:_messageKey
                                                        object:nil
                                                      userInfo:userInfo];
    
    completionHandler(UIBackgroundFetchResultNoData);
    
    
    // testing open chatting page ------
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        // app was already in the foreground
        NSLog(@"notification received by running app");
    }
    else
    {
        // app was just brougt from background to foreground
        NSLog(@"app opened from notification");
        
        
        NSDictionary *info = (NSDictionary *)userInfo;
        NSLog(@"user info nsdictionary ---- %@",info);
        NSLog(@"stikid --- %@",info[@"recipientStkid"]);
        NSLog(@"name ---- %@",info[@"chatRecipient"]);
        NSLog(@"file ------ %@",info[@"fileName"]);
        
        
        NavigChatViewController *loginController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"navig_chat_view_controller"]; //or the homeController
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:loginController];
        [NavigChatViewController setToStikyBee:info[@"recipientStkid"]];
        
        NSArray *infoArray = [NSArray arrayWithObjects:info[@"recipientStkid"],info[@"chatRecipient"],info[@"chatRecipientUrl"], nil];
        
        [NavigChatViewController setToStikyBeeInfoArray:infoArray];

        loginController = [NavigChatViewController messagesViewController];
        
        self.window.rootViewController = navController;
        
        [navController pushViewController:loginController animated:YES];
        
       
    }
    
}


- (UIViewController*)topMostController
{
    UIViewController *topController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}




- (void)startGCMService
{
    //google cloud --------------------------------------------------------//
    
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    _gcmSenderID = [[[GGLContext sharedInstance] configuration] gcmSenderID];
    NSLog(@"gcg sender id ---- %@",_gcmSenderID);
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
    {
        // iOS 7.1 or earlier
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:allNotificationTypes];
    }
    else
    {
        // iOS 8 or later
        // [END_EXCLUDE]
        
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }
    // [END register_for_remote_notifications]
    // [START start_gcm_service]
    
    GCMConfig *gcmConfig = [GCMConfig defaultConfig];
    gcmConfig.receiverDelegate = self;
    [[GCMService sharedInstance] startWithConfig:gcmConfig];
    // [END start_gcm_service]
    __weak typeof(self) weakSelf = self;
    // Handler for registration token request
    _registrationHandler = ^(NSString *registrationToken, NSError *error){
       
        if (registrationToken != nil)
        {
            weakSelf.registrationToken = registrationToken;
            NSLog(@"Registration Token: %@", registrationToken);
            [weakSelf subscribeToTopic];
            NSDictionary *userInfo = @{@"registrationToken":registrationToken};
            [[NSNotificationCenter defaultCenter] postNotificationName:weakSelf.registrationKey
                                                                object:nil
                                                              userInfo:userInfo];

            
            
            [WebDataInterface updateToken:[LocalDataInterface retrieveStkid] token:weakSelf.registrationToken completion:^(NSObject *obj, NSError *err) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *dict = (NSDictionary *)obj;
                    if ([dict[@"status"] isEqualToString:@"success"])
                    {
                        
                        NSLog(@"update token success !!!!!!!!!--- %@",dict[@"status"]);
                        //            [weakSelf subscribeToTopic];
//                        NSDictionary *userInfo = @{@"registrationToken":registrationToken};
//                        [[NSNotificationCenter defaultCenter] postNotificationName:weakSelf.registrationKey
//                                                                            object:nil
//                                                                          userInfo:userInfo];
                        
                        NSLog(@"user info --- %@",userInfo);
                    }
                    else
                    {
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                    }

                });
            }];
            
            
            
        }
        else
        {
            NSLog(@"Registration to GCM failed with error: %@", error.localizedDescription);
            NSDictionary *userInfo = @{@"error":error.localizedDescription};
            [[NSNotificationCenter defaultCenter] postNotificationName:weakSelf.registrationKey
                                                                object:nil
                                                              userInfo:userInfo];
        }
    };
}



- (void)subscribeToTopic {
    // If the app has a registration token and is connected to GCM, proceed to subscribe to the
    // topic
    if (_registrationToken && _connectedToGCM) {
        [[GCMPubSub sharedInstance] subscribeWithToken:_registrationToken
                                                 topic:SubscriptionTopic
                                               options:nil
                                               handler:^(NSError *error) {
                                                   if (error) {
                                                       // Treat the "already subscribed" error more gently
                                                       if (error.code == 3001) {
                                                           NSLog(@"Already subscribed to %@",
                                                                 SubscriptionTopic);
                                                       } else {
                                                           NSLog(@"Subscription failed: %@",
                                                                 error.localizedDescription);
                                                       }
                                                   } else {
                                                       self.subscribedToTopic = true;
                                                       NSLog(@"Subscribed to %@", SubscriptionTopic);
                                                   }
                                               }];
    }
}

- (void)onTokenRefresh
{
    NSLog(@"The GCM registration token needs to be changed.");
    [[GGLInstanceID sharedInstance] tokenWithAuthorizedEntity:_gcmSenderID
                                                        scope:kGGLInstanceIDScopeGCM
                                                      options:_registrationOptions
                                                      handler:_registrationHandler];
}


// [START upstream_callbacks]
- (void)willSendDataMessageWithID:(NSString *)messageID error:(NSError *)error {
    if (error) {
        // Failed to send the message.
        NSLog(@"error send msg --- %@",error);
    } else {
        // Will send message, you can save the messageID to track the message
        NSLog(@"will send data message with id");
        
    }
}


- (void)didSendDataMessageWithID:(NSString *)messageID {
    // Did successfully send message identified by messageID
    
    NSLog(@"did successfully send msg identified by messageid --- %@",messageID);
}
// [END upstream_callbacks]



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

// [START disconnect_gcm_service]
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[GCMService sharedInstance] disconnect];
    // [START_EXCLUDE]
    _connectedToGCM = NO;
    // [END_EXCLUDE]
}
// [END disconnect_gcm_service]

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
    
    
    // Connect to the GCM server to receive non-APNS notifications
    [[GCMService sharedInstance] connectWithHandler:^(NSError *error) {
        if (error)
        {
            NSLog(@"Could not connect to GCM: %@", error.localizedDescription);
        }
        else
        {
            _connectedToGCM = true;
            NSLog(@"Connected to GCM");
            // [START_EXCLUDE]
            [self subscribeToTopic];
            // [END_EXCLUDE]
        }
    }];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
