//
//  GRHWebViewModel.m
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/16.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHWebViewModel.h"
#import "GRHUtil.h"
#import "SSKeychain+GRHUtil.h"
#import "GRHLoginViewModel.h"
#import "GRHContentViewModel.h"

@interface GRHWebViewModel()

@property (nonatomic, strong, readwrite) NSString * jsToEval;
@property (nonatomic, strong, readwrite) RACSignal * evaluateJavascriptSignal;
@property (nonatomic, strong, readwrite) NSString *token;


@end

@implementation GRHWebViewModel

- (void) initialize {
    [super initialize];
    self.evaluateJavascriptSignal = RACObserve(self, jsToEval);
    if(![SSKeychain token].isExist){
        // 如果token不存在跳转登录页面
        // 从理论上不应出现此处调用
        [self.services resetRootViewModel:[[GRHLoginViewModel alloc] initWithServices:self.services params:nil]];
    }
    self.token = SSKeychain.token;
    
}

- (void) evalJS:(NSString *)jsString {
    self.jsToEval = jsString;
}

- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    NSLog(@"js postMessage：%@",message.body);
    if([(NSString *)message.body[@"action"] isEqualToString:@"navigate"]){
        GRHContentViewModel *newVM = [[GRHContentViewModel alloc] initWithServices:self.services params:@{@"title":message.body[@"name"],@"path":message.body[@"path"]}];
        [self.services pushViewModel:newVM animated:YES];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"加载完毕");
    [self evalJS:@"setInterval(function(){console.log('inject Success')}, 1000)"];
}

@end
