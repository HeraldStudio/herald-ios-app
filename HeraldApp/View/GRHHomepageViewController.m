//
//  GRHHomepageViewController.m
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/14.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHHomepageViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface GRHHomepageViewController ()

@property (nonatomic, weak, readwrite) UIView * tabBarView;
@property (nonatomic, weak, readwrite) UIStackView * tabBarStackView;
@property (nonatomic, strong, readwrite) NSMutableArray * tabBarButtons;
@property (nonatomic, strong, readwrite) NSMutableArray * tabBarButtonImageViews;
@property (nonatomic, strong, readwrite) NSMutableArray * tabBarButtonTextViews;
@property (nonatomic, strong, readwrite) NSMutableArray * tabGestureRecognizer;
@property (nonatomic, readwrite) NSInteger currentTabIndex;
@property (nonatomic, strong, readwrite) NSArray * tabButtonImageNamePositive;
@property (nonatomic, strong, readwrite) NSArray * tabButtonImageNameNegative;
@property (nonatomic, strong, readwrite) NSArray * tabButtonText;
@property int reloadCounter;

@end

@implementation GRHHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.backgroundColor = HexRGB(0x13ACD9);
    [self constructUI];
    [self checkNotification];
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backButtonItem;
    
    // 设置刷新按钮
    UIButton *reloadButton = [[UIButton alloc] init];
    //[reloadButton setTitle:@"刷新" forState:UIControlStateNormal];
    [reloadButton setImage:[UIImage imageNamed:@"reload-button"] forState:UIControlStateNormal];
    UIBarButtonItem * reloadButtonItem = [[UIBarButtonItem alloc] initWithCustomView:reloadButton];
    [reloadButton addTarget:self action:@selector(reloadClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = reloadButtonItem;
    
    self.reloadCounter = 0;
    
}

- (void)checkNotification{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if(settings.authorizationStatus == UNAuthorizationStatusDenied){
                NSLog(@"通知被禁止");
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"通知权限被禁止" message:@"小猴偷米通知权限被禁用，您将无法收到来自小猴的提醒" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                    
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"前往开启" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
                    if (UIApplicationOpenSettingsURLString != NULL) {
                        UIApplication *application = [UIApplication sharedApplication];
                        NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                            [application openURL:URL options:@{} completionHandler:nil];
                        } else {
                            [application openURL:URL];
                        }
                    }
                }]];
                // 弹出对话框
                [self presentViewController:alert animated:true completion:nil];
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}

- (void)constructUI {
    UIView *tabBarView = [[UIView alloc] init];
    self.tabBarView = tabBarView;
    self.currentTabIndex = 0;
    self.tabButtonImageNameNegative = @[@"home-tab",@"activity-tab",@"notification-tab",@"personal-tab"];
    self.tabButtonImageNamePositive = @[@"home-tab-selected",@"activity-tab-selected",@"notification-tab-selected",@"personal-tab-selected"];
    self.tabButtonText = @[@"主页", @"活动", @"通知", @"个人"];
    
    NSMutableArray *tabButtonViews = [[NSMutableArray alloc] init];
    NSMutableArray *tabButtonImageViews = [[NSMutableArray alloc] init];
    NSMutableArray *tabButtonTextViews = [[NSMutableArray alloc] init];
    NSMutableArray *tabGestureRecognizer = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < self.tabButtonText.count; i++) {
        UIImageView *tabButtonImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed: i == self.currentTabIndex ? self.tabButtonImageNamePositive[i] : self.tabButtonImageNameNegative[i]]];
        tabButtonImage.contentMode = UIViewContentModeScaleAspectFit;
        [tabButtonImageViews addObject:tabButtonImage];
        UILabel *tabButtonTextView = [[UILabel alloc] init];
        tabButtonTextView.text = self.tabButtonText[i];
        tabButtonTextView.textColor = (i == self.currentTabIndex ? HexRGB(0x13ACD9) : HexRGB(0x888888));
        tabButtonTextView.font = [UIFont systemFontOfSize: 14];
        [tabButtonTextViews addObject:tabButtonTextView];
        UIStackView *tabButtonView = [[UIStackView alloc] initWithArrangedSubviews:@[tabButtonImage, tabButtonTextView]];
        [tabButtonViews addObject:tabButtonView];
        tabButtonView.spacing = 5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabClick:)];
        tabButtonView.userInteractionEnabled = YES;
        [tabButtonView addGestureRecognizer:tap];
        [tabGestureRecognizer addObject:tap];
    }
    
    
    self.tabBarButtons = tabButtonViews;
    self.tabBarButtonTextViews = tabButtonTextViews;
    self.tabBarButtonImageViews = tabButtonImageViews;
    self.tabGestureRecognizer = tabGestureRecognizer;
    
    UIStackView *tabBarStackView = [[UIStackView alloc] initWithArrangedSubviews:tabButtonViews];
    self.tabBarStackView = tabBarStackView;
    tabBarStackView.distribution = UIStackViewDistributionEqualCentering;
    [self.tabBarView addSubview:self.tabBarStackView];
    
    
    UIView *splitter = [[UIView alloc] init];
    splitter.backgroundColor = HexRGB(0xEEEEEE);
    [self.view addSubview:self.tabBarView];
    [self.view addSubview:splitter];
    
    [self.tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view);
    }];
    
    [splitter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(0.5));
        make.top.equalTo(self.tabBarView.mas_top);
    }];
    
    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tabBarView.mas_top);
    }];
    
    [self.tabBarStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(splitter.mas_bottom).offset(4);
        make.left.equalTo(tabBarView);
        make.right.equalTo(tabBarView);
        if (@available(iOS 11.0, *)) {
            if(is_iPhoneXSerious) {
                make.height.equalTo(@(35));
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                make.height.equalTo(@(40));
                make.bottom.equalTo(self.view.mas_bottom).offset(-4);
            }
        } else {
            // Fallback on earlier versions
            make.height.equalTo(@(40));
            make.bottom.equalTo(self.view.mas_bottom).offset(-4);
        }
    }];
}
-(void) reloadClick:(UIBarButtonItem *)sender{
    ((UIImageView *)self.tabBarButtonImageViews[0]).image = [UIImage imageNamed:self.tabButtonImageNamePositive[0]] ;
    ((UIImageView *)self.tabBarButtonImageViews[1]).image = [UIImage imageNamed:self.tabButtonImageNameNegative[1]] ;
    ((UIImageView *)self.tabBarButtonImageViews[2]).image = [UIImage imageNamed:self.tabButtonImageNameNegative[2]] ;
    ((UIImageView *)self.tabBarButtonImageViews[3]).image = [UIImage imageNamed:self.tabButtonImageNameNegative[3]] ;
    ((UILabel *)self.tabBarButtonTextViews[0]).textColor = HexRGB(0x13ACD9);
    ((UILabel *)self.tabBarButtonTextViews[1]).textColor = HexRGB(0x888888);
    ((UILabel *)self.tabBarButtonTextViews[2]).textColor = HexRGB(0x888888);
    ((UILabel *)self.tabBarButtonTextViews[3]).textColor = HexRGB(0x888888);
    self.reloadCounter++;
    if (self.reloadCounter >= 10) {
        // 出现这种情况就重新彻底
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"遇到问题？" message:@"发现您多次点击刷新，重新加载可能帮助您解决问题" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"重新加载" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            [self.viewModel.reloadCommand execute:nil];
        }]];
        // 弹出对话框
        [self presentViewController:alert animated:true completion:nil];
        self.reloadCounter = 0;
    } else {
        [self.webView reload];
    }
    
}

-(void) tabClick:(UITapGestureRecognizer *)tabButton{
    self.currentTabIndex = [self.tabGestureRecognizer indexOfObject:tabButton];
    for(NSInteger i = 0; i < self.tabButtonText.count; i++){
        ((UILabel *)self.tabBarButtonTextViews[i]).textColor = (i == self.currentTabIndex ? HexRGB(0x13ACD9) : HexRGB(0x888888));
        ((UIImageView *)self.tabBarButtonImageViews[i]).image = [UIImage imageNamed: i == self.currentTabIndex ? self.tabButtonImageNamePositive[i] : self.tabButtonImageNameNegative[i]];
    }
    NSString *tabPath = @"/home";
    switch (self.currentTabIndex) {
        case 0:
            tabPath = @"/home";
            break;
        case 1:
            tabPath = @"/activity";
            break;
        case 2:
            tabPath = @"/notice";
            break;
        case 3:
            tabPath = @"/personal";
        default:
            break;
    }
    [self.viewModel evalJS:[NSString stringWithFormat:@"window.router.replace('%@?jsbridge=true')", tabPath]];
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
