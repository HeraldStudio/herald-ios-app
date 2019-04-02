//
//  GRHViewModel.m
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/8.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHViewModel.h"
#import "GRHViewModelServices.h"
#import "GRHLoginViewModel.h"
#import "SSKeychain+GRHUtil.h"
#import <UserNotifications/UserNotifications.h>

@interface GRHViewModel ()

@property (nonatomic, strong, readwrite) id<GRHViewModelServices> services;
@property (nonatomic, copy, readwrite) NSDictionary *params;

@property (nonatomic, strong, readwrite) RACSubject *errors;
@property (nonatomic, strong, readwrite) RACSubject *willDisappearSignal;

@property (nonatomic, strong, readwrite) RACSignal *showLoadingSignal;
@property (nonatomic, strong, readwrite) RACSignal *toastSignal;

@end

@implementation GRHViewModel

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    GRHViewModel *viewModel = [super allocWithZone:zone];
    
    @weakify(viewModel)
    [[viewModel
      rac_signalForSelector:@selector(initWithServices:params:)]
     subscribeNext:^(id x) {
         @strongify(viewModel)
         [viewModel initialize];
     }];
    
    return viewModel;
}

- (instancetype)initWithServices:(id<GRHViewModelServices>)services params:(NSDictionary *)params {
    self = [super init];
    if (self) {
        self.shouldFetchLocalDataOnViewModelInitialize = YES;
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
        self.title    = params[@"title"];
        self.services = services;
        self.params   = params;
    }
    return self;
}

- (RACSubject *)errors {
    if (!_errors) _errors = [RACSubject subject];
    return _errors;
}

- (RACSubject *)willDisappearSignal {
    if (!_willDisappearSignal) _willDisappearSignal = [RACSubject subject];
    return _willDisappearSignal;
}

- (void)initialize {
    self.showLoadingSignal = RACObserve(self, showLoading);
    self.toastSignal = RACObserve(self, toastText);
}

- (void)check401:(id)responseObject {
    if([(NSNumber *)responseObject[@"code"] isEqual:@(401)]){
        // 如果出现401错误
        self.toastText = @"身份认证过期，请重新登录"; // 给出用户提示
        [self logout];
    }
}

- (void)logout{
    [SSKeychain deleteToken];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:GRH_USERINFO_DEFUALTS];
    // 清除所有通知
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter* notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        [notificationCenter getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
            for(UNNotificationRequest *request in requests){
                    [notificationCenter removePendingNotificationRequestsWithIdentifiers:@[request.identifier]];
            }
        }];
    }
    GRHLoginViewModel *loginViewModel = [[GRHLoginViewModel alloc] initWithServices:self.services params:nil];
    [self.services resetRootViewModel:loginViewModel]; // 返回登录页面重新登录
}
@end
