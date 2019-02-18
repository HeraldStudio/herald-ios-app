//
//  GRHPrepareViewController.m
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/14.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHPrepareViewController.h"
#import "GRHPrepareViewModel.h"

@interface GRHPrepareViewController ()

@property (nonatomic, weak, readwrite) UIImageView* logoImageView;
@property (nonatomic, strong, readonly) GRHPrepareViewModel *viewModel;

@end

@implementation GRHPrepareViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self constructUI];
}

- (void)constructUI {
    self.navigationController.navigationBar.hidden = YES;
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"herald-logo"]];
    self.logoImageView = logoImageView;
    logoImageView.contentMode =  UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:logoImageView];
    
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@(120));
        make.height.equalTo(@(120));
    }];
}
- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self)
    [self.viewModel.animationSignal subscribeNext:^(id  _Nullable startAnimation) {
        @strongify(self)
        if([startAnimation boolValue]) {
            [self.logoImageView setAlpha:0.8];
            [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.logoImageView.transform = CGAffineTransformMakeScale(7, 7);
                [self.logoImageView setAlpha:0];
            } completion:^(BOOL finished) {
                [self.logoImageView removeFromSuperview];
                [self.viewModel done];
            }];
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

@end
