//
//  GRHWebViewModel.h
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/16.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHViewModel.h"
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface GRHWebViewModel : GRHViewModel <WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, strong, readonly) NSString *token;
@property (nonatomic, strong, readonly) RACSignal * evaluateJavascriptSignal;

-(void) evalJS:(NSString *) jsString;
-(void) didFinshLoadingInject;
-(void) set


@end

NS_ASSUME_NONNULL_END
