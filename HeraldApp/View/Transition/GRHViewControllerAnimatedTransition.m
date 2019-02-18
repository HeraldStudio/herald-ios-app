//
//  GRHViewControllerAnimatedTransition.m
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/12.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHViewControllerAnimatedTransition.h"

@interface GRHViewControllerAnimatedTransition ()

@property (nonatomic, assign, readwrite) UINavigationControllerOperation operation;
@property (nonatomic, weak, readwrite) GRHViewController *fromViewController;
@property (nonatomic, weak, readwrite) GRHViewController *toViewController;

@end

@implementation GRHViewControllerAnimatedTransition

- (instancetype)initWithNavigationControllerOperation:(UINavigationControllerOperation)operation
                                   fromViewController:(GRHViewController *)fromViewController
                                     toViewController:(GRHViewController *)toViewController {
    self = [super init];
    if (self) {
        self.operation = operation;
        self.fromViewController = fromViewController;
        self.toViewController = toViewController;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    GRHViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    GRHViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    if (self.operation == UINavigationControllerOperationPush) { // push
        [[transitionContext containerView] addSubview:fromViewController.snapshot];
        fromViewController.view.hidden = YES;
        
        CGRect frame = [transitionContext finalFrameForViewController:toViewController];
        toViewController.view.frame = CGRectOffset(frame, CGRectGetWidth(frame), 0);
        [[transitionContext containerView] addSubview:toViewController.view];
        
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             fromViewController.snapshot.alpha = 0.0;
                             fromViewController.snapshot.frame = CGRectInset(fromViewController.view.frame, 20, 20);
                             toViewController.view.frame = CGRectOffset(toViewController.view.frame, -CGRectGetWidth(toViewController.view.frame), 0);
                         }
                         completion:^(BOOL finished) {
                             fromViewController.view.hidden = NO;
                             [fromViewController.snapshot removeFromSuperview];
                             [transitionContext completeTransition:YES];
                         }];
    } else if (self.operation == UINavigationControllerOperationPop) { // pop
        GRHSharedAppDelegate.window.backgroundColor = [UIColor blackColor];
        
        [fromViewController.view addSubview:fromViewController.snapshot];
        fromViewController.navigationController.navigationBar.hidden = YES;
        
        toViewController.view.hidden = YES;
        toViewController.snapshot.alpha = 0.5;
        toViewController.snapshot.transform = CGAffineTransformMakeScale(0.95, 0.95);
        
        [[transitionContext containerView] addSubview:toViewController.view];
        [[transitionContext containerView] addSubview:toViewController.snapshot];
        [[transitionContext containerView] sendSubviewToBack:toViewController.snapshot];
        
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             fromViewController.view.frame = CGRectOffset(fromViewController.view.frame, CGRectGetWidth(fromViewController.view.frame), 0);
                             toViewController.snapshot.alpha = 1.0;
                             toViewController.snapshot.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             GRHSharedAppDelegate.window.backgroundColor = [UIColor whiteColor];
                             
                             toViewController.navigationController.navigationBar.hidden = NO;
                             toViewController.view.hidden = NO;
                             
                             [fromViewController.snapshot removeFromSuperview];
                             [toViewController.snapshot removeFromSuperview];
                             
                             // Reset toViewController's `snapshot` to nil
                             if (![transitionContext transitionWasCancelled]) {
                                 toViewController.snapshot = nil;
                             }
                             
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
    }
}

@end
