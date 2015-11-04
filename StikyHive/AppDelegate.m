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



@interface AppDelegate ()

@end

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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
