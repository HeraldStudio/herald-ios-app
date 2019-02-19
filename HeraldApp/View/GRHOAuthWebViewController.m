//
//  GRHOAuthWebViewController.m
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/19.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHOAuthWebViewController.h"
#import "WebKit/WebKit.h"

@interface GRHOAuthWebViewController ()

@property (nonatomic, weak, readwrite) WKWebView *webView;

@end

@implementation GRHOAuthWebViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WKWebViewConfiguration *webViewConfiguration = [[WKWebViewConfiguration alloc] init];
    
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    // 注册ViewModel为JS方法回调对象
    [userContentController addScriptMessageHandler:self.viewModel name:@"heraldAppBridge"];
    webViewConfiguration.userContentController = userContentController;
    NSLog(@"%@",self.viewModel.params[@"OAuthURL"]);
    NSString *loadUrlString = self.viewModel.params[@"OAuthURL"];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:webViewConfiguration];
    webView.navigationDelegate = self.viewModel;
    self.webView = webView;
    [self.view addSubview:webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loadUrlString]]];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            UIView *topLayoutGuide = (id)self.topLayoutGuide;
            make.top.equalTo(topLayoutGuide.mas_bottom);
        }
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
