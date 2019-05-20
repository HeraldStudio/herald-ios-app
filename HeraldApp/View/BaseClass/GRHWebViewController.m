//
//  GRHWebViewController.m
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/16.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHWebViewController.h"
#import "GRHWKURLSchemeHandler.h"

@interface GRHWebViewController ()

@property (nonatomic, weak, readwrite) WKWebView *webView;
@property (nonatomic, strong, readwrite) WKUserContentController *userContentController;
@property (nonatomic, strong, readwrite) GRHWebViewModel *viewModel;

@end

@implementation GRHWebViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WKWebViewConfiguration *webViewConfiguration = [[WKWebViewConfiguration alloc] init];
    
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    // 注册ViewModel为JS方法回调对象
    [userContentController addScriptMessageHandler:self.viewModel name:@"heraldAppBridge"];
    // 注入token/user
    NSError *parseError = nil;
    NSDictionary *userDict = [grhUserDefaults objectForKey:GRH_USERINFO_DEFUALTS];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDict options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *userInfo = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *injectTokenUserScriptSource = [NSString stringWithFormat:@"window.token='%@'; window.userInfo=%@;", self.viewModel.token, userInfo];
    WKUserScript *injectTokenUserScript = [[WKUserScript alloc] initWithSource:injectTokenUserScriptSource injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    [userContentController addUserScript:injectTokenUserScript];
    webViewConfiguration.userContentController = userContentController;
    NSString *loadUrlString = nil;
    if (@available(iOS 11.0, *)) {
        [webViewConfiguration setURLSchemeHandler:[[GRHWKURLSchemeHandler alloc] init] forURLScheme:@"herald-hybrid"];
        loadUrlString = [NSString stringWithFormat:@"%@%@",@"herald-hybrid://hybrid-ios.myseu.cn/",@"index.html"];
    } else {
        // 对于 iOS 11 以前的版本无法拦截自定义协议，所以这部分用户使用 CDN 加载
        loadUrlString = [NSString stringWithFormat:@"%@%@",GRH_HYBRID_BASEURL,@"index.html"];
    }
    if(GRH_HYBRID_DEBUG){
        // 调试模式加载配置的地址
        loadUrlString = [NSString stringWithFormat:@"%@%@",GRH_HYBRID_DEBUG_URL,@"index.html"];
    }
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:webViewConfiguration];
    webView.navigationDelegate = self.viewModel;
    self.webView = webView;
    [self.view addSubview:webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loadUrlString] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f]];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            //make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            UIView *topLayoutGuide = (id)self.topLayoutGuide;
            make.top.equalTo(topLayoutGuide.mas_bottom);
            //make.bottom.equalTo(self.view.mas_bottom);
        }
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
}

- (void) bindViewModel{
    [super bindViewModel];
    // 绑定
    @weakify(self)
    [self.viewModel.evaluateJavascriptSignal subscribeNext:^(id  _Nullable javascript) {
        @strongify(self);
        [self.webView evaluateJavaScript:javascript completionHandler:nil];
    }];
}

- (void)dealloc{
    [self.userContentController removeScriptMessageHandlerForName:@"heraldAppBridge"];
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
