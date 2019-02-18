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
    
    if(GRH_HYBRID_DEBUG){
        // 如果配置为调试模式则跳过下载离线包
        self.startAnimation = @(YES);
    } else {
        [self.services.hybridService.fetchLocalizedFileList subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@", x);
            RACSignal *updateTask = [self.services.hybridService updateOfflinePackage:x[@"packageName"]];
            [updateTask subscribeNext:^(id  _Nullable y) {
                NSLog(@"下载完成");
                self.startAnimation = @(YES);
            } error:^(NSError * _Nullable error) {
                NSLog(@"下载出错%@", error);
            }];
        }];
    }
}

- (void) done {
    [self.services resetRootViewModel:[[GRHHomepageViewModel alloc] initWithServices:self.services params:nil]];
}

@end
