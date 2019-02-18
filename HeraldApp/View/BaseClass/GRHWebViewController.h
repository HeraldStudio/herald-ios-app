//
//  GRHWebViewController.h
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/16.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHViewController.h"
#import <WebKit/WebKit.h>
#import "GRHWebViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GRHWebViewController : GRHViewController <WKUIDelegate>

@property (nonatomic, strong, readonly) GRHWebViewModel *viewModel;
@property (nonatomic, weak, readonly) WKWebView *webView;

@end

NS_ASSUME_NONNULL_END
