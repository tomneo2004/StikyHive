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
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Notification received: %@", userInfo);
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
    
    NSLog(@"Notification received: %@", userInfo);
    // This works only if the app started the GCM service
    [[GCMService sharedInstance] appDidReceiveMessage:userInfo];
    // Handle the received message
    // Invoke the completion handler passing the appropriate UIBackgroundFetchResult value
    // [START_EXCLUDE]
    [[NSNotificationCenter defaultCenter] postNotificationName:_messageKey
                                                        object:nil
                                                      userInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNoData);
    
}

- (void)startGCMService
{
    //google cloud ------------------------------------------------//
    _registrationKey = @"onRegistrationCompleted";
    _messageKey = @"onMessageReceived";
    
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    _gcmSenderID = [[[GGLContext sharedInstance] configuration] gcmSenderID];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
    {
        // iOS 7.1 or earlier
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:allNotificationTypes];
    }else{
        
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }
    
    GCMConfig *gcmConfig = [GCMConfig defaultConfig];
    gcmConfig.receiverDelegate = self;
    [[GCMService sharedInstance] startWithConfig:gcmConfig];
    // [END start_gcm_service]
    __weak typeof(self) weakSelf = self;
    // Handler for registration token request
    _registrationHandler = ^(NSString *registrationToken, NSError *error){
        if (registrationToken != nil) {
            weakSelf.registrationToken = registrationToken;
            NSLog(@"Registration Token: %@", registrationToken);
            
            [WebDataInterface updateToken:[LocalDataInterface retrieveStkid] token:weakSelf.registrationToken completion:^(NSObject *obj, NSError *err) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *dict = (NSDictionary *)obj;
                    if ([dict[@"status"] isEqualToString:@"success"]) {
                        
                        NSLog(@"update token success !!!!!!!!!");
                        
                        //            [weakSelf subscribeToTopic];
                        NSDictionary *userInfo = @{@"registrationToken":registrationToken};
                        [[NSNotificationCenter defaultCenter] postNotificationName:weakSelf.registrationKey
                                                                            object:nil
                                                                          userInfo:userInfo];
                    }

                });
                
                
            }];
            
            
        } else {
            NSLog(@"Registration to GCM failed with error: %@", error.localizedDescription);
            NSDictionary *userInfo = @{@"error":error.localizedDescription};
            [[NSNotificationCenter defaultCenter] postNotificationName:weakSelf.registrationKey
                                                                object:nil
                                                              userInfo:userInfo];
        }
    };
}


//- (void)subscribeToTopic {
//    // If the app has a registration token and is connected to GCM, proceed to subscribe to the
//    // topic
//    if (_registrationToken && _connectedToGCM) {
//        [[GCMPubSub sharedInstance] subscribeWithToken:_registrationToken
//                                                 topic:SubscriptionTopic
//                                               options:nil
//                                               handler:^(NSError *error) {
//                                                   if (error) {
//                                                       // Treat the "already subscribed" error more gently
//                                                       if (error.code == 3001) {
//                                                           NSLog(@"Already subscribed to %@",
//                                                                 SubscriptionTopic);
//                                                       } else {
//                                                           NSLog(@"Subscription failed: %@",
//                                                                 error.localizedDescription);
//                                                       }
//                                                   } else {
//                                                       self.subscribedToTopic = true;
//                                                       NSLog(@"Subscribed to %@", SubscriptionTopic);
//                                                   }
//                                               }];
//    }
//}

- (void)onTokenRefresh
{
    NSLog(@"The GCM registration token needs to be changed.");
    [[GGLInstanceID sharedInstance] tokenWithAuthorizedEntity:_gcmSenderID
                                                        scope:kGGLInstanceIDScopeGCM
                                                      options:_registrationOptions
                                                      handler:_registrationHandler];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
    
    
    // Connect to the GCM server to receive non-APNS notifications
    [[GCMService sharedInstance] connectWithHandler:^(NSError *error) {
        if (error) {
            NSLog(@"Could not connect to GCM: %@", error.localizedDescription);
        } else {
            _connectedToGCM = true;
            NSLog(@"Connected to GCM");
            // [START_EXCLUDE]
//            [self subscribeToTopic];
            // [END_EXCLUDE]
        }
    }];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
