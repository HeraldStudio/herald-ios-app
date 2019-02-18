//
//  GRHViewModelServicesImpl.m
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/10.
//  Copyright © 2019 Herald Studio. All rights reserved.
//


#import "GRHViewModelServicesImpl.h"
#import "GRHHybridServiceImpl.h"
#import "GRHWebServiceImpl.h"

@implementation GRHViewModelServicesImpl

@synthesize webService = _webService;
@synthesize hybridService = _hybridService;
//@synthesize appStoreService = _appStoreService;

- (instancetype)init {
    self = [super init];
    if (self) {
        _webService = [[GRHWebServiceImpl alloc] init];
        _hybridService = [[GRHHybridServiceImpl alloc] init];
        //_appStoreService   = [[GRHAppStoreServiceImpl alloc] init];
    }
    return self;
}

- (void)pushViewModel:(GRHViewModel *)viewModel animated:(BOOL)animated {}

- (void)popViewModelAnimated:(BOOL)animated {}

- (void)popToRootViewModelAnimated:(BOOL)animated {}

- (void)presentViewModel:(GRHViewModel *)viewModel animated:(BOOL)animated completion:(VoidBlock)completion {}

- (void)dismissViewModelAnimated:(BOOL)animated completion:(VoidBlock)completion {}

- (void)resetRootViewModel:(GRHViewModel *)viewModel {}

@end

