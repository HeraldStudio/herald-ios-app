//
//  AppDelegate.h
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2018/11/24.
//  Copyright © 2018 Herald Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "GRHNavigationControllerStack.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong, readonly) GRHNavigationControllerStack *navigationControllerStack;

@property (nonatomic, assign, readonly) NetworkStatus networkStatus;


@end

