//
//  AppDelegate.m
//  妈妈问
//
//  Created by lixuan on 15/3/2.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstLonginViewController.h"

#import "ViewController.h"
//#import "LXXMPPManager.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    FirstLonginViewController *vc = [FirstLonginViewController new];
//    vc.navigationController.navigationBarHidden = YES;
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    _tabbarVC = [[RootTabbarController alloc] init];
    self.window.rootViewController = _tabbarVC;
    
    [self configSettingParam];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
   
    if (IOS8) {
        [application registerForRemoteNotifications];
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeBadge | UIUserNotificationTypeAlert) categories:Nil];
        [application registerUserNotificationSettings:settings];
        
    } else {
    [application registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    }
    
    return YES;
}
- (void)configSettingParam {
//    [[NSUserDefaults standardUserDefaults] objectForKey:kIsOpenNewMessageNote];
    
    _isOpenNewMessageNote = YES;
    _isOpenNewMessageNoteDetail = YES;
    _isOpenSound = YES;
    _isOpenVibrate = YES;


}
//- (void)application:(UIApplication*)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
//    UIUserNotificationSettings *settings = [application currentUserNotificationSettings];
//    UIUserNotificationType types = [settings types];
//    
//    if (types == 5 || types == 7) {
//        application.applicationIconBadgeNumber = 0;
//    }
/////Users/kin/Desktop/userPush.mobileprovision
//    [application registerForRemoteNotifications];
//
//}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@",deviceToken);
    NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
//    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
//    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
//    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSLog(@"%@",token);
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"register remote notify err:%@",error.description);
}
//- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
//{
//    NSLog(@"%@",NSStringFromSelector(_cmd));
//}
//
//- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
//{
//    if ([identifier isEqualToString:@"action1"]) {
//        [self handleAcceptActionWithNotification:notification];
//    }
//    completionHandler();
//}
//
//- (void)handleAcceptActionWithNotification:(UILocalNotification*)notification
//{
//    NSLog(@"%@",notification.soundName);
//}










- (void)applicationWillResignActive:(UIApplication *)application {

    
    [ViewController offLine];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    
//    NSInteger num = application.applicationIconBadgeNumber;
//    [application setApplicationIconBadgeNumber:num + 1];
    
    [ViewController offLine];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kHasLoginOrRegister] integerValue] != 0) {
        [ViewController reconnect];
    };
        
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kHasLoginOrRegister] integerValue] != 0) {
        [ViewController loginOpenfire];
    };

    
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {

    
    [ViewController offLine];
}

@end
