//
//  GRHOAuthWebViewController.h
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/19.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHViewController.h"
#import "GRHOAuthWebViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GRHOAuthWebViewController : GRHViewController

@property (nonatomic, strong, readonly) GRHOAuthWebViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
