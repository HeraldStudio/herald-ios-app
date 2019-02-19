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
    
    self.validLoginSignal = [[RACSignal
                              combineLatest:@[ RACObserve(self, cardnum), RACObserve(self, password) , RACObserve(self, showLoading)]
                              reduce:^(NSString *cardnum, NSString *password, NSNumber *showLoading) {
                                  return @(cardnum.length == 9 && password.length > 0 && !([showLoading boolValue]));
                              }]
                             distinctUntilChanged];
    self.needOAuth = RACObserve(self, verifyURL);
    
    @weakify(self)
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        NSLog(@"点击登录按钮了");
        self.showLoading = @(YES);
        RACSignal *login = [self.services.webService authWithCardnum:self.cardnum password:self.password];
        [login subscribeNext:^(id  _Nullable authResult) {
            NSLog(@"%@", authResult);
            self.showLoading = @(NO);
            if([authResult[@"code"] isEqualToNumber:@(401)]) {
                self.toastText = @"一卡通号或密码错误";
            } else if (![authResult[@"success"] boolValue]) {
                // 其他失败原因直接提示
                self.toastText = authResult[@"reason"];
            } else if ([authResult[@"code"] isEqualToNumber:@(200)]) {
                // 成功
                [SSKeychain setToken:authResult[@"result"]];
                [self.services resetRootViewModel:[[GRHPrepareViewModel alloc] initWithServices:self.services params:nil]];
            } else if ([authResult[@"code"] isEqualToNumber:@(303)]){
                // TODO: 需要页面认证
                self.verifyURL = authResult[@"result"][@"verifyUrl"];
            }
        } error:^(NSError * _Nullable error) {
            self.showLoading = @(YES);
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
