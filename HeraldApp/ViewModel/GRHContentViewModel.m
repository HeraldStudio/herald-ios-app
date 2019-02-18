//
//  GRHContentViewModel.m
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/18.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHContentViewModel.h"

@implementation GRHContentViewModel

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self evalJS:[NSString stringWithFormat:@"window.router.replace('%@?jsbridge=true')", self.params[@"path"]]];
}

@end
