//
//  GRHLoginViewController.m
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/12.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHLoginViewController.h"
#import "GRHLoginViewModel.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "GRHLoadingTitleView.h"

@interface GRHLoginViewController () <UITextFieldDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, weak) UIImageView *logoImageView;
@property (nonatomic, weak) UITextField *cardnumTextField;
@property (nonatomic, weak) UITextField *passwordTextField;
@property (nonatomic, weak) UIButton *loginButton;
@property (nonatomic, weak) UILabel *descriptionTextView;
@property (nonatomic, weak) UILabel *copyrightTextView;

@property (nonatomic, strong, readonly) GRHLoginViewModel *viewModel;

@end

@implementation GRHLoginViewController
{
    IQKeyboardReturnKeyHandler *returnKeyHandler;
}
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self constructUI];
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)constructUI {
    self.navigationController.navigationBar.hidden = YES;
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"herald-logo"]];
    self.logoImageView = logoImageView;
    logoImageView.contentMode =  UIViewContentModeScaleAspectFit;
    
    UITextField *cardnumTextField = [[UITextField alloc] init];
    self.cardnumTextField = cardnumTextField;
    cardnumTextField.placeholder = NSLocalizedString(@"LoginView_cardnumPlaceHolder", @"一卡通号");
    cardnumTextField.backgroundColor = HexRGB(0xF0F0F0);
    cardnumTextField.layer.cornerRadius = 5;
    cardnumTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    cardnumTextField.leftViewMode = UITextFieldViewModeAlways;
    cardnumTextField.textColor = HexRGB(0x333333);
    //cardnumTextField.layer.masksToBounds = YES;
    
    UITextField *passwordTextField = [[UITextField alloc] init];
    self.passwordTextField = passwordTextField;
    passwordTextField.placeholder = NSLocalizedString(@"LoginView_passwordPlaceHolder", @"统一身份认证密码");
    passwordTextField.backgroundColor = HexRGB(0xF0F0F0);
    passwordTextField.layer.cornerRadius = 5;
    passwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.textColor = HexRGB(0x333333);
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton = loginButton;
    [loginButton setTitle:NSLocalizedString(@"LoginView_loginButtonTitle", @"登录") forState:UIControlStateNormal];
    loginButton.backgroundColor = HexRGB(0x13ACD9);
    loginButton.layer.cornerRadius = 5;
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    UILabel *descriptionTextView = [[UILabel alloc] init];
    self.descriptionTextView = descriptionTextView;
    
    NSMutableParagraphStyle   *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];//行间距
    paragraphStyle.alignment = NSTextAlignmentJustified;//文本对齐方式 左右对齐（两边对齐）
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"LoginView_description", @"LoginView_description")];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [NSLocalizedString(@"LoginView_description", @"LoginView_description") length])];//设置段落样式
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, [NSLocalizedString(@"LoginView_description", @"LoginView_description") length])];//设置字体大小
    
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone] range:NSMakeRange(0, [NSLocalizedString(@"LoginView_description", @"LoginView_description") length])];//这段话必须要添加，否则UIlabel两边对齐无效 NSUnderlineStyleAttributeName （设置下划线）
    
    descriptionTextView.attributedText = attributedString;
    descriptionTextView.numberOfLines = 0;
    descriptionTextView.textColor = HexRGB(0xA0A0A0);
    descriptionTextView.font = [UIFont systemFontOfSize:15];
    [descriptionTextView sizeToFit];
    
    UILabel *copyrightTextView = [[UILabel alloc] init];
    self.copyrightTextView = copyrightTextView;
    copyrightTextView.text = NSLocalizedString(@"LoginView_copyright", @"版权声明");
    copyrightTextView.textColor = HexRGB(0xA0A0A0);
    copyrightTextView.font = [UIFont systemFontOfSize:13];
    [descriptionTextView sizeToFit];
    
    
    UIStackView *panel = [[UIStackView alloc]initWithArrangedSubviews:@[logoImageView, cardnumTextField, passwordTextField,[UIView new], loginButton,[UIView new], descriptionTextView]];
    
    panel.axis = UILayoutConstraintAxisVertical;
    panel.spacing = 10;
    [self.view addSubview:panel];
    [self.view addSubview:copyrightTextView];
    
    [panel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@(SCREEN_WIDTH * 0.65));
    }];
    
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(SCREEN_WIDTH * 0.3));
    }];
    
    
    [cardnumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(40));
    }];
    
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(40));
    }];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(40));
    }];
    
    [copyrightTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-30);
    }];
    
    GRHLoadingTitleView *loading = [GRHLoadingTitleView new];
    [self.view addSubview:loading];
    [loading mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
}

- (void)bindViewModel {
    [super bindViewModel];
    
    NSLog(@"bindViewModel");
    @weakify(self)
    
    RAC(self.viewModel, cardnum) = self.cardnumTextField.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordTextField.rac_textSignal;
    
//    [[RACSignal
//      merge:@[ self.viewModel.loginCommand.executing, self.viewModel.browserLoginCommand.executing ]]
//     subscribeNext:^(NSNumber *executing) {
//         @strongify(self)
//         if (executing.boolValue) {
//             [self.view endEditing:YES];
//             [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].labelText = @"Logging in...";
//         } else {
//             [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
//         }
//     }];
    
//    [[RACSignal merge:@[ self.viewModel.loginCommand.errors, self.viewModel.browserLoginCommand.errors ]] subscribeNext:^(NSError *error) {
//        @strongify(self)
//        if ([error.domain isEqual:OCTClientErrorDomain] && error.code == OCTClientErrorAuthenticationFailed) {
//            MRCError(@"Incorrect username or password");
//        } else if ([error.domain isEqual:OCTClientErrorDomain] && error.code == OCTClientErrorTwoFactorAuthenticationOneTimePasswordRequired) {
//            NSString *message = @"Please enter the 2FA code you received via SMS or read from an authenticator app";
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:MRC_ALERT_TITLE
//                                                                                     message:message
//                                                                              preferredStyle:UIAlertControllerStyleAlert];
//
//            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//                textField.returnKeyType = UIReturnKeyGo;
//                textField.placeholder = @"2FA code";
//                textField.secureTextEntry = YES;
//            }];
//
//            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL]];
//
//            [alertController addAction:[UIAlertAction actionWithTitle:@"Login" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                @strongify(self)
//                [self.viewModel.loginCommand execute:[alertController.textFields.firstObject text]];
//            }]];
//
//            [self presentViewController:alertController animated:YES completion:NULL];
//        } else {
//            MRCError(error.localizedDescription);
//        }
//    }];
//
    RAC(self.loginButton, enabled) = self.viewModel.validLoginSignal;
    
    [self.viewModel.validLoginSignal subscribeNext:^(id valid) {
        @strongify(self)
        if ([valid boolValue]) {
            self.loginButton.backgroundColor = HexRGB(0x13ACD9);
        } else {    
            self.loginButton.backgroundColor = HexRGB(0xe0e0e0);
        }
    }];
    
    
    
    [[self.loginButton
      rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self)
         
         [self.viewModel.loginCommand execute:nil];
     }];
    
    [self.viewModel.needOAuth subscribeNext:^(id  _Nullable x) {
        if(x != nil) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码输入错误次数过多，本次登录需要额外验证过程；请通过统一身份认证验证后再次尝试登录。" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"前往验证" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.viewModel.verifyURL]];
            }]];
            // 弹出对话框
            [self presentViewController:alert animated:true completion:nil];
        }
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
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
