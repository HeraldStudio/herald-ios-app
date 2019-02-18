//
//  GRHLoadingTitleView.m
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/9.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHLoadingTitleView.h"
@interface GRHLoadingTitleView ()

@property (nonatomic, weak, readwrite) UILabel *hintLabel;
@property (nonatomic, weak, readwrite) UIActivityIndicatorView *indicator;
@property (nonatomic, weak, readwrite) UIView *back;

@end
@implementation GRHLoadingTitleView

-(instancetype) initWithTitle:(NSString *)title {
    self = [super init];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.indicator = indicator;
    UIView *background = [[UIView alloc] init];
    background.layer.cornerRadius = 10;
    background.layer.masksToBounds = YES;
    background.backgroundColor = HexRGBAlpha(0x0, 0.5);
    self.back = background;
    [self addSubview:background];
    [background addSubview:indicator];
    if(title != nil) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = title;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = HexRGB(0xffffff);
        [background addSubview:titleLabel];
        self.hintLabel = titleLabel;
    }
    return self;
}

-(void) makeUp{
    [self.indicator startAnimating];
    [self.back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(self);
        make.center.equalTo(self);
    }];
    [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.back);
        make.width.equalTo(@(50));
        make.height.equalTo(@(50));
    }];
    if(self.hintLabel != nil) {
        [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.back);
            make.bottom.equalTo(self.back).offset(-5);
        }];
    }
}
@end
