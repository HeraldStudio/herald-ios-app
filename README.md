# 小猴偷米 iOS App 第二版

基于 Hybrid App 思想开发的小猴偷米 iOS App

## 开发风格

* Objective-C 

  Swift 更新太快了，为了避免重蹈第一版的覆辙，这次我们用OjbC👌

* MVVM 模式

  使用 ReactiveObjC 作为根本实现的MVVM模式，大规模借鉴：https://github.com/leichunfeng/MVVMReactiveCocoa

  **不建议🙅**新手直接去看 ReactiveObjC 的任何教程和文档，容易影响积极性；

  **建议🙋‍♂️**认真阅读 `GRHViewModel` / `GRHViewController` 等基类，以 **登录界面** 为例分析代码（`GRHLoginViewModel` / `GRHLoginViewController` / `GRHWebServiceImpl`）然后在实践中体会MVVM模式的实现方式 

* 使用 Masonary 实现 AutoLayout 的纯代码布局

* 离线包

  为了高端大气上档次，项目中称所有 WebView 内容为 Hybrid 内核

  为了提高加载速度，使用离线包方式加载 Hybrid 内核，但是离线包模式仅支持 iOS 11 及以上系统（截止2019年1月 App Store 统计 满足该要求的用户已达到 95%），对于无法支持离线包（的5%迂腐）的用户，将通过 CDN 进行加载。

## 开始开发

1. 确保已经正确安装 Cocoapods
2. 使用 Cocoapods 补全依赖 `pod install`
3. 搭建 Hybrid 内核测试服务 （参见：https://github.com/HeraldStudio/herald-hybrid-web-kernel）

## 调试

`GRHConfig.h` 中：

```objective-c
///-----------
/// Hybrid
///-----------

#define GRH_HYBRID_BASEURL @"http://192.168.1.102:8080/"
#define GRH_HYBRID_DEBUG YES
```

`GRH_HYBRID_DEBUG` 字段为 `YES` 时，Hybrid 内核从 `GRH_HYBRID_BASEURL` 加载；否则从 `GRH_HYBRID_BASEURL` 下载离线包到本地，然后使用离线包渲染。

无论何种加载方式，Hybrid 内核的入口点为 `index.html` 。


## 应用启动流程

AppDelegate.m

```objective-c
- (GRHViewModel *)createInitialViewModel {
    // The user has logged-in.
    if ([SSKeychain token].isExist) {
        return [[GRHPrepareViewModel alloc] initWithServices:self.services params:nil];
    } else {
        return [[GRHLoginViewModel alloc] initWithServices:self.services params:nil];
    }
}
```

通过 token 是否存在判断用户是否登录，未登录则跳转登录页面，存在登录信息则跳转至 Prepare 页面。

GRHPrepareViewModel.m

```objective-c
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
```

获取最新的离线包信息 `info.json` ，并更新离线包。需要注意的是调用 `self.services.hybridService updateOfflinePackage:` 时传入最新线上离线包的名称，然后会判断是否本地已有该离线包，已有则不会重复下载。

离线包更新完成后即设置`self.startAnimation` 为 YES，产生进场动画效果，加载 `GRHHomepageViewModel`。

## 封装的方法

### 显示toast信息

`GRHViewModel` 包含 `(NSString *)toastText`  属性，该属性被RAC观察，需要显示toast时直接将显示内容赋值：

```objective-c
// ViewController 
self.viewModel.toastText = @"要显示的内容";
// ViewModel
self.toastText = @"要显示的内容";
```

### Objective-C 和 JS 的交互

* Objective-C 调用 js

使用`GRHWebViewModel`提供的`-(void)evalJS:`方法：

```objective-c
[self evalJS:@"setInterval(function(){console.log('inject Success')}, 1000)"];
```

需要注意的是脚本必须在页面加载完成后执行，`GRHWebViewModel` 作为 `WKWebView` 的 `WKNavigationDelegate` 	，可以通过覆盖 `- (void)webView:didFinishNavigation:`  方法实现以上目的：

```objective-c
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"加载完毕");
    [self evalJS:@"setInterval(function(){console.log('inject Success')}, 1000)"];
}
```

* Js 调用 Objective-C

```javascript
window.webkit.messageHandlers.heraldAppBridge.postMessage({"name":"rikumi"})
```

## 可能经常需要解决的问题

### 设置状态栏颜色为浅色（时间日期信号强度）

在 RootViewController 中加入：

```objective-c
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
```

### 使用十六进制字符串表示颜色

使用宏 `HexRGB` :

```objective-c
cardnumTextField.backgroundColor = HexRGB(0xF0F0F0);
```

### 设置圆角

```objective-c
cardnumTextField.layer.cornerRadius = 5;
//cardnumTextField.layer.masksToBounds = YES; // 如果需要，会导致离屏渲染 
```

### UITextField 文字离左侧太近

设置`leftView`

```objective-c
cardnumTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
cardnumTextField.leftViewMode = UITextFieldViewModeAlways;
```

### 铺满safeArea

```objective-c
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            UIView *topLayoutGuide = (id)self.topLayoutGuide;
            make.top.equalTo(topLayoutGuide.mas_bottom);
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
```

### 判断响应是否为401:

`GRHViewModel`定义了 

​	`-(void)check401:(id) responseObject` 

方法。对于从`GRHWebServiceImpl`中获取的请求结果可以使用该方法进行验证，当产生401时会跳转到登录页面。

## 开发进程

* [x] user信息注入
* [x] 登录失效跳转登录界面
* [x] OAuth 支持
* [x] 【改成 Safari 打开】非内置 WebView 页面 （出于安全考虑，所有非https请求均离开app）
* [x] 通知页打不开的问题
* [ ] Widget 开发
* [ ] 个人页面
* [ ] App 图标设置

