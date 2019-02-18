//
//  GRHContentViewController.m
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/18.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHContentViewController.h"

@implementation GRHContentViewController

-(void) viewDidLoad{
    [super viewDidLoad];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
}
@end
