//
//  GRHLoginViewModel.m
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/12.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHLoginViewModel.h"
#import "GRHPrepareViewModel.h"
#import "SSKeychain+GRHUtil.h"
#import "GRHOAuthWebViewModel.h"
#import <UserNotifications/UserNotifications.h>
@interface GRHLoginViewModel ()

@property (nonatomic, strong, readwrite) RACSignal *validLoginSignal;
@property (nonatomic, strong, readwrite) RACCommand *loginCommand;
@property (nonatomic, strong, readwrite) NSString *verifyURL;
@property (nonatomic, strong, readwrite) RACSignal *needOAuth;
@property (nonatomic, strong, readwrite) RACCommand *oauthCommand;

@end

@implementation GRHLoginViewModel

-(void) initialize {
    [super initialize];
    
    // validSLoginSignal 用于确定登录l按钮是否可以点击
    self.validLoginSignal = [[RACSignal
                              combineLatest:@[ RACObserve(self, cardnum), RACObserve(self, password) , RACObserve(self, showLoading)]
                              reduce:^(NSString *cardnum, NSString *password, NSNumber *showLoading) {
                                  // 按钮有效的条件是
                                  // 当前一卡通为9位
                                  // 密码长度不为0
                                  // 当前不处于loading状态
                                  return @(cardnum.length == 9 && password.length > 0 && !([showLoading boolValue]));
                              }]
                             distinctUntilChanged];
    self.needOAuth = RACObserve(self, verifyURL);
    
    @weakify(self)
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        NSLog(@"点击登录按钮了");
        // 点击按钮首先显示 loading
        self.showLoading = @(YES);
        // 获取登录的 Signal
        RACSignal *login = [self.services.webService authWithCardnum:self.cardnum password:self.password];
        [login subscribeNext:^(id  _Nullable authResult) {
            NSLog(@"%@", authResult);
            // 获得登录结果后隐藏loading提示
            self.showLoading = @(NO);
            // 判断登录结果
            if([authResult[@"code"] isEqualToNumber:@(401)]) {
                // 登录结果为 401 时一卡通和密码不正确
                self.toastText = @"一卡通号或密码错误";
            } else if (![authResult[@"success"] boolValue]) {
                // 其他失败原因直接提示
                self.toastText = authResult[@"reason"];
            } else if ([authResult[@"code"] isEqualToNumber:@(200)]) {
                // 成功
                [SSKeychain setToken:authResult[@"result"]];
                // 清除所有通知
                if (@available(iOS 10.0, *)) {
                    UNUserNotificationCenter* notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
                    [notificationCenter getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
                        for(UNNotificationRequest *request in requests){
                            [notificationCenter removePendingNotificationRequestsWithIdentifiers:@[request.identifier]];
                        }
                    }];
                }
                [self.services resetRootViewModel:[[GRHPrepareViewModel alloc] initWithServices:self.services params:nil]];
            } else if ([authResult[@"code"] isEqualToNumber:@(303)]){
                // 返回 303 时设置 verifyURL
                // verifyURL 被设置后将会直接弹出提示
                // 引导用户完成认证操作
                self.verifyURL = authResult[@"result"][@"verifyUrl"];
            }
        } error:^(NSError * _Nullable error) {
            self.showLoading = @(NO);
            self.toastText = @"登录过程出错,请重试";
        }];
        return [RACSignal empty];
    }];
    
    self.oauthCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        [self.services resetRootViewModel:[[GRHOAuthWebViewModel alloc] initWithServices:self.services params:@{@"OAuthURL":self.verifyURL,@"title":@"安全验证",@"subtitle":@"统一身份认证"}]];
        return [RACSignal empty];
    }];
    
}
@end
