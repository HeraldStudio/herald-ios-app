//
//  GRHOAuthWebViewModel.h
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/19.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHViewModel.h"
#import "WebKit/WebKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface GRHOAuthWebViewModel : GRHViewModel <WKNavigationDelegate, WKScriptMessageHandler>


@end

NS_ASSUME_NONNULL_END
