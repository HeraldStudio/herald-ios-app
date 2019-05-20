//
//  AppDelegate.m
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2018/11/24.
//  Copyright © 2018 Herald Studio. All rights reserved.
//

#import "AppDelegate.h"
#import "GRHViewModel.h"
#import "GRHViewModelServicesImpl.h"
#import "GRHLoginViewModel.h"
#import "GRHPrepareViewModel.h"
#import "SSKeychain+GRHUtil.h"
#import "GRHUtil.h"
#import "AFNetworking.h"
#import <UserNotifications/UserNotifications.h>


@interface AppDelegate ()
@property (nonatomic, strong) GRHViewModelServicesImpl *services;
@property (nonatomic, strong) GRHViewModel *viewModel;
@property (nonatomic, strong) Reachability *reachability;

@property (nonatomic, strong, readwrite) GRHNavigationControllerStack *navigationControllerStack;

@property (nonatomic, assign, readwrite) NetworkStatus networkStatus;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 初始化services
    self.services = [[GRHViewModelServicesImpl alloc] init];
    
    self.navigationControllerStack = [[GRHNavigationControllerStack alloc] initWithServices:self.services];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.services resetRootViewModel:[self createInitialViewModel]];
    [self.window makeKeyAndVisible];
    [self configureAppearance];
    [self initNotificationPush];
    [[UIApplication sharedApplication] setShortcutItems:@[]];
    return YES;
}

- (void)initNotificationPush{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:                                           (UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if (!error) {
                                      NSLog(@"请求推送权限成功！");
                                  }
                              }];
    } else {
        // iOS 10 以下就不通知了。
    }
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (GRHViewModel *)createInitialViewModel {
    // The user has logged-in.
    if ([SSKeychain token].isExist) {
        return [[GRHPrepareViewModel alloc] initWithServices:self.services params:nil];
    } else {
        return [[GRHLoginViewModel alloc] initWithServices:self.services params:nil];
    }
}

- (void)configureAppearance {
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 0x2F434F
    [UINavigationBar appearance].barTintColor = HexRGB(0x13ACD9);
    [UINavigationBar appearance].barStyle  = UIBarStyleBlack;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    
    [UINavigationBar appearance].backgroundColor = HexRGB(0x13ACD9);
    [UISegmentedControl appearance].tintColor = [UIColor whiteColor];
    
    [UITabBar appearance].tintColor = HexRGB(colorI3);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
