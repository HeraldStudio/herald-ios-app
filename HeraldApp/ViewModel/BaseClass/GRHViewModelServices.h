//
//  GRHViewModelServices.h
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/10.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRHWebService.h"
#import "GRHHybridService.h"
#import "GRHNavigationProtocol.h"
#import "GRHViewModel.h"

@protocol GRHViewModelServices <NSObject, GRHNavigationProtocol>

@property (nonatomic, strong, readonly) id<GRHWebService> webService;
@property (nonatomic, strong, readonly) id<GRHHybridService> hybridService;

@end

/* GRHViewModelServices_h */
