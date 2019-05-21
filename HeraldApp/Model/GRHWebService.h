//
//  GRHWebService.h
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/12.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"
@protocol GRHWebService <NSObject>

//- (RACSignal *)requestRepositoryReadmeHTML:(OCTRepository *)repository reference:(NSString *)reference;
//- (RACSignal *)requestTrendingRepositoriesSince:(NSString *)since language:(NSString *)language;

- (RACSignal *)authWithCardnum:(NSString *)cardnum password:(NSString *)password;
- (RACSignal *)apiUser;
- (RACSignal *)uploadDeviceToken;

@end

