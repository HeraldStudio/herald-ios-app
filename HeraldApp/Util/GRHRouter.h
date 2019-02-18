//
//  GRHRouter.h
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/8.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRHViewController.h"

@interface GRHRouter : NSObject

/// Retrieves the shared router instance.
///
/// Returns the shared router instance.
+ (instancetype)sharedInstance;

/// Retrieves the view corresponding to the given view model.
///
/// viewModel - The view model
///
/// Returns the view corresponding to the given view model.
- (GRHViewController *)viewControllerForViewModel:(GRHViewModel *)viewModel;

@end
