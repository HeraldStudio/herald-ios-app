//
//  GRHViewController.m
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/8.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHViewController.h"
#import "GRHViewModel.h"
#import "GRHDoubleTitleView.h"
#import "GRHLoadingTitleView.h"
#import "UIView+Toast.h"

@interface GRHViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong, readwrite) GRHViewModel *viewModel;
@property (nonatomic, strong, readwrite) UIPercentDrivenInteractiveTransition *interactivePopTransition;

@property (nonatomic, weak, readwrite) GRHLoadingTitleView *loadingTitleView;

@end

@implementation GRHViewController

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    GRHViewController *viewController = [super allocWithZone:zone];
    
    @weakify(viewController)
    [[viewController
      rac_signalForSelector:@selector(viewDidLoad)]
     subscribeNext:^(id x) {
         @strongify(viewController)
         [viewController bindViewModel];
     }];
    
    return viewController;
}

- (GRHViewController *)initWithViewModel:(id)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HexRGB(0xffffff);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (self.navigationController != nil && self != self.navigationController.viewControllers.firstObject) {
        UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopRecognizer:)];
        [self.view addGestureRecognizer:popRecognizer];
        popRecognizer.delegate = self;
    }
}

- (void)bindViewModel {
    // System title view
    RAC(self, title) = RACObserve(self.viewModel, title);
    
    UIView *titleView = self.navigationItem.titleView;
    
    // Double title view
    GRHDoubleTitleView *doubleTitleView = [[GRHDoubleTitleView alloc] init];
    
    RAC(doubleTitleView.titleLabel, text)    = RACObserve(self.viewModel, title);
    RAC(doubleTitleView.subtitleLabel, text) = RACObserve(self.viewModel, subtitle);
    
    @weakify(self)
    [[self
      rac_signalForSelector:@selector(viewWillTransitionToSize:withTransitionCoordinator:)]
     subscribeNext:^(id x) {
         @strongify(self)
         doubleTitleView.titleLabel.text    = self.viewModel.title;
         doubleTitleView.subtitleLabel.text = self.viewModel.subtitle;
     }];
    
    GRHLoadingTitleView *loadingTitleView = [[NSBundle mainBundle] loadNibNamed:@"GRHLoadingTitleView" owner:nil options:nil].firstObject;
    loadingTitleView.frame = CGRectMake((SCREEN_WIDTH -  CGRectGetWidth(loadingTitleView.frame)) / 2.0, 0, CGRectGetWidth(loadingTitleView.frame), CGRectGetHeight(loadingTitleView.frame));
    
    [self.viewModel.showLoadingSignal subscribeNext:^(id  _Nullable showLoading) {
        @strongify(self)
        if([showLoading boolValue]){
            if(self.loadingTitleView == nil){
                // 如果还没有显示
                GRHLoadingTitleView *loadingTitleView = [[GRHLoadingTitleView alloc] initWithTitle:@"请稍候"];
                self.loadingTitleView = loadingTitleView;
                [self.view addSubview:loadingTitleView];
                [loadingTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(100));
                    make.height.equalTo(@(100));
                    make.center.equalTo(self.view);
                }];
                [loadingTitleView makeUp];
            }
        } else {
            if(self.loadingTitleView != nil){
                [self.loadingTitleView removeFromSuperview];
                self.loadingTitleView = nil;
            }
        }
    }];
    
    [self.viewModel.toastSignal subscribeNext:^(id  _Nullable toastText) {
        @strongify(self)
        if(toastText != nil && [(NSString *)toastText length] > 0) {
            [self.view makeToast:toastText];
        }
    }];
    
    RAC(self.navigationItem, titleView) = [RACObserve(self.viewModel, titleViewType).distinctUntilChanged map:^(NSNumber *value) {
        GRHTitleViewType titleViewType = value.unsignedIntegerValue;
        switch (titleViewType) {
            case GRHTitleViewTypeDefault:
                return titleView;
            case GRHTitleViewTypeDoubleTitle:
                return (UIView *)doubleTitleView;
            case GRHTitleViewTypeLoadingTitle:
                return (UIView *)loadingTitleView;
        }
    }];
    
    [self.viewModel.errors subscribeNext:^(NSError *error) {
        //@strongify(self)
        
        GRHLogError(error);
// 身份认证过期逻辑
//        if ([error.domain isEqual:OCTClientErrorDomain] && error.code == OCTClientErrorAuthenticationFailed) {
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:GRH_ALERT_TITLE
//                                                                                     message:@"Your authorization has expired, please login again"
//                                                                              preferredStyle:UIAlertControllerStyleAlert];
//
//            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                @strongify(self)
//                [SSKeychain deleteAccessToken];
//
//                GRHLoginViewModel *loginViewModel = [[GRHLoginViewModel alloc] initWithServices:self.viewModel.services params:nil];
//                [self.viewModel.services resetRootViewModel:loginViewModel];
//            }]];
//
//            [self presentViewController:alertController animated:YES completion:NULL];
//        } else if (error.code != OCTClientErrorTwoFactorAuthenticationOneTimePasswordRequired && error.code != OCTClientErrorConnectionFailed) {
//            GRHError(error.localizedDescription);
//        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.viewModel.willDisappearSignal sendNext:nil];
    
    // Being popped, take a snapshot
    if ([self isMovingFromParentViewController]) {
        self.snapshot = [self.navigationController.view snapshotViewAfterScreenUpdates:NO];
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return isPad ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIPanGestureRecognizer handlers

- (void)handlePopRecognizer:(UIPanGestureRecognizer *)recognizer {
    CGFloat progress = [recognizer translationInView:self.view].x / CGRectGetWidth(self.view.frame);
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // Create a interactive transition and pop the view controller
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        // Update the interactive transition's progress
        [self.interactivePopTransition updateInteractiveTransition:progress];
    } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        // Finish or cancel the interactive transition
        if (progress > 0.25) {
            [self.interactivePopTransition finishInteractiveTransition];
        } else {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        
        self.interactivePopTransition = nil;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)recognizer {
    return [recognizer velocityInView:self.view].x > 0;
}

@end

