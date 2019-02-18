//
//  GRHViewController.h
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/8.
//  Copyright © 2019 Herald Studio. All rights reserved.
//
#import "GRHViewModel.h"

@interface GRHViewController : UIViewController

/// The `viewModel` parameter in `-initWithViewModel:` method.
@property (nonatomic, strong, readonly) GRHViewModel *viewModel;
@property (nonatomic, strong, readonly) UIPercentDrivenInteractiveTransition *interactivePopTransition;
@property (nonatomic, strong) UIView *snapshot;

/// Initialization method. This is the preferred way to create a new view.
///
/// viewModel - corresponding view model
///
/// Returns a new view.
- (instancetype)initWithViewModel:(GRHViewModel *)viewModel;

/// Binds the corresponding view model to the view.
- (void)bindViewModel;

@end
