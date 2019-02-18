//
//  GRHViewControllerAnimatedTransition.h
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/12.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRHViewController.h"

@interface GRHViewControllerAnimatedTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, readonly) UINavigationControllerOperation operation;
@property (nonatomic, weak, readonly) GRHViewController *fromViewController;
@property (nonatomic, weak, readonly) GRHViewController *toViewController;

- (instancetype)initWithNavigationControllerOperation:(UINavigationControllerOperation)operation
                                   fromViewController:(GRHViewController *)fromViewController
                                     toViewController:(GRHViewController *)toViewController;

@end
