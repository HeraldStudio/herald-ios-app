//
//  GRHPrepareViewModel.m
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/14.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHPrepareViewModel.h"
#import "GRHHomepageViewModel.h"

@interface GRHPrepareViewModel ()

@property (nonatomic, strong, readwrite) RACSignal *animationSignal;

@end

@implementation GRHPrepareViewModel

- (void) initialize {
    [super initialize];
    self.animationSignal = RACObserve(self, startAnimation);
    // 执行耗时的启动操作
    // 调用api/user接口，更新全局用户信息，该信息通过js注入到webview中，提高首屏加载速度
    RACSignal *getUserInfo = [self.services.webService apiUser];
    [getUserInfo subscribeNext:^(id  _Nullable userInfo) {
        if([(NSNumber *)userInfo[@"code"] isEqualToNumber:@(200)]) {
            NSLog(@"更新本地用户信息%@", userInfo[@"result"]);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:userInfo[@"result"] forKey:GRH_USERINFO_DEFUALTS];
            if(GRH_HYBRID_DEBUG){
                // 如果配置为调试模式则跳过下载离线包
                self.startAnimation = @(YES);
            } else {
                [self.services.hybridService.fetchLocalizedFileList subscribeNext:^(id  _Nullable x) {
                    NSLog(@"获取到的离线包信息%@", x);
                    RACSignal *updateTask = [self.services.hybridService updateOfflinePackage:x[@"packageName"]];
                    [updateTask subscribeNext:^(id  _Nullable y) {
                        NSLog(@"下载完成");
                        self.startAnimation = @(YES);
                    } error:^(NSError * _Nullable error) {
                        NSLog(@"下载出错%@", error);
                    }];
                }];
            }
        } else {
            [self logout];
        }
    } error:^(NSError * _Nullable error) {
        //
        [self logout];
    }];
}

- (void) done {
    [self.services resetRootViewModel:[[GRHHomepageViewModel alloc] initWithServices:self.services params:nil]];
}

@end
