# 小猴偷米 iOS App 第二版

产品代号 herald-ios-v2

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

通过 token 是否存在判断用户是否登录，未登录则跳转登录页面



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
