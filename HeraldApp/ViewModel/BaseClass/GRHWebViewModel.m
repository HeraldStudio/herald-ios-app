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
#import <UserNotifications/UserNotifications.h>


@interface GRHWebViewModel()

@property (nonatomic, strong, readwrite) NSString * jsToEval;
@property (nonatomic, strong, readwrite) RACSignal * evaluateJavascriptSignal;
@property (nonatomic, strong, readwrite) NSString *token;

-(void)setLocalNotificationWithTitle:(NSString *)title body:(NSString *)body at:(NSNumber *)timestamp type:(NSString *)type;
-(void)clearLocalNotificationsOfType:(NSString *)type;

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
        // jsBridge navigate动作
        GRHContentViewModel *newVM = [[GRHContentViewModel alloc] initWithServices:self.services params:@{@"title":message.body[@"name"],@"path":message.body[@"path"]}];
        [self.services pushViewModel:newVM animated:YES];
    } else if ([(NSString *)message.body[@"action"] isEqualToString:@"logout"]){
        // jsBridge logout动作
        [self logout];
    } else if ([(NSString *)message.body[@"action"] isEqualToString:@"openURL"]){
        // jsBridge openURL动作
        NSURL *targetURL = [NSURL URLWithString:message.body[@"url"]];
        if([(NSNumber *)message.body[@"inApp"] boolValue]){
            //TODO
        } else {
            [[UIApplication sharedApplication] openURL:targetURL];  
        }
    } else if ([(NSString *)message.body[@"action"] isEqualToString:@"setLocalNotification"]){
        // jsBridge setLocalNotification动作
        [self setLocalNotificationWithTitle:message.body[@"title"] body:message.body[@"body"] at:message.body[@"timestamp"] type:message.body[@"type"]];
    } else if ([(NSString *)message.body[@"action"] isEqualToString:@"clearLocalNotification"]){
        // jsBridge clearLocalNotification动作
        [self clearLocalNotificationsOfType:message.body[@"type"]];
    } else if ([(NSString *)message.body[@"action"] isEqualToString:@"addTodayExtItems"]) {
        [self addTodayExtItems:message.body[@"items"] of:message.body[@"type"]];
    } else if ([(NSString *)message.body[@"action"] isEqualToString:@"clearTodayExtItems"]) {
        [self clearTodayExtItemsOf:message.body[@"type"]];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"加载完毕");
    [self evalJS:@"setInterval(function(){console.log('inject Success')}, 1000)"];
    [self didFinshLoadingInject];
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    // 如果是在新页面中打开则直接打开浏览器？
    if (navigationAction.targetFrame == nil) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)setLocalNotificationWithTitle:(NSString *)title body:(NSString *)body at:(NSNumber *)timestamp type:(NSString *)type{
    if (@available(iOS 10.0, *)) {
        // 设置通知的标题和内容
        UNMutableNotificationContent *notificationContent = [[UNMutableNotificationContent alloc] init];
        notificationContent.title = title;
        notificationContent.body = body;
        
        // 根据设置通知的时间
        NSDate *notificationTime = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:notificationTime];
        
        UNCalendarNotificationTrigger* trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponent repeats:NO];
        
        NSString *uuid = [[NSUUID UUID] UUIDString];
        NSString *identifier = [NSString stringWithFormat:@"%@-%@", type, uuid];
        UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:identifier content:notificationContent trigger:trigger];
        UNUserNotificationCenter* notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        
        [notificationCenter addNotificationRequest:notificationRequest withCompletionHandler:NULL];
    }
}

-(void)clearLocalNotificationsOfType:(NSString *)type{
    if (@available(iOS 10.0, *)) {
        // 设置通知的标题和内容
        
        UNUserNotificationCenter* notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        
        [notificationCenter getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
            
            for(UNNotificationRequest *request in requests){
                if([request.identifier containsString:type]){
                    [notificationCenter removePendingNotificationRequestsWithIdentifiers:@[request.identifier]];
                }
            }
        }];
    }
}

-(void)addTodayExtItems:(NSArray *)items of:(NSString *)type {
    NSUserDefaults* todayExtDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.cn.myseu"];
    [todayExtDefaults setObject:items forKey:type];
}

-(void)clearTodayExtItemsOf:(NSString *)type {
    NSUserDefaults* todayExtDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.cn.myseu"];
    [todayExtDefaults removeObjectForKey:type];
}

-(void)didFinshLoadingInject {
    // 加载完成后的注入动作
    
}

@end
