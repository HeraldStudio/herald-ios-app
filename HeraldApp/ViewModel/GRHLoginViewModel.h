//
//  GRHLoginViewModel.h
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/12.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GRHLoginViewModel : GRHViewModel

/// The username entered by the user.
@property (nonatomic, copy) NSString *cardnum;

/// The password entered by the user.
@property (nonatomic, copy) NSString *password;

// OAuth Url
@property (nonatomic, copy) NSString *validateUrl;

// 判断一卡通和密码输入是否合法
@property (nonatomic, strong, readonly) RACSignal *validLoginSignal;

@property (nonatomic, strong, readonly) RACCommand *loginCommand;

@end

NS_ASSUME_NONNULL_END
