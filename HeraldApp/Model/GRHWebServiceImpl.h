//
//  GRHWebServiceImpl.h
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/12.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRHWebService.h"
NS_ASSUME_NONNULL_BEGIN

@interface GRHWebServiceImpl : NSObject <GRHWebService>

- (RACSignal *)authWithCardnum:(NSString *)cardnum password:(NSString *)password;
- (RACSignal *)apiUser;

@end

NS_ASSUME_NONNULL_END
