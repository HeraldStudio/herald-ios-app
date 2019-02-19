//
//  GRHRouter.m
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/8.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHRouter.h"

@interface GRHRouter ()

@property (nonatomic, copy) NSDictionary *viewModelViewMappings; // viewModel到view的映射

@end

@implementation GRHRouter

+ (instancetype)sharedInstance {
    static GRHRouter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (GRHViewController *)viewControllerForViewModel:(GRHViewModel *)viewModel {
    NSString *viewController = self.viewModelViewMappings[NSStringFromClass(viewModel.class)];
    
    NSParameterAssert([NSClassFromString(viewController) isSubclassOfClass:[GRHViewController class]]);
    NSParameterAssert([NSClassFromString(viewController) instancesRespondToSelector:@selector(initWithViewModel:)]);
    
    return [[NSClassFromString(viewController) alloc] initWithViewModel:viewModel];
}

- (NSDictionary *)viewModelViewMappings {
    return @{
             @"GRHLoginViewModel": @"GRHLoginViewController",
             @"GRHHomepageViewModel": @"GRHHomepageViewController",
             @"GRHPrepareViewModel": @"GRHPrepareViewController",
             @"GRHContentViewModel": @"GRHContentViewController",
             @"GRHOAuthWebViewModel": @"GRHOAuthWebViewController"
             };
}

@end
