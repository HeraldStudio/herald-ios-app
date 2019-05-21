//
//  GRHHomepageViewModel.m
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/14.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHHomepageViewModel.h"

@interface GRHHomepageViewModel ()

@end

@implementation GRHHomepageViewModel

-(void) initialize {
    [super initialize];
    self.title = @"小猴偷米";
    // 上传deviceToken
    RACSignal *uploadDeviceToken = [self.services.webService uploadDeviceToken];
    [uploadDeviceToken subscribeNext:^(id  _Nullable x) {
    
    } error:^(NSError * _Nullable error) {
        
    }];
}

-(void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self evalJS:@"window.router.replace('/home?jsbridge=true')"];
}

@end
