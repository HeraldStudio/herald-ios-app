//
//  SSKeyChain+GRHUtil.m
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/12.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "SSKeychain+GRHUtil.h"
#import "GRHConfig.h"

@implementation SSKeychain (GRHUtil)

+ (NSString *)token {
    return [self passwordForService:GRH_SERVICE_NAME account:GRH_TOKEN];
}

+ (BOOL)setToken:(NSString *)token {
    return [self setPassword:token forService:GRH_SERVICE_NAME account:GRH_TOKEN];
}

+ (BOOL)deleteToken {
    return [self deletePasswordForService:GRH_SERVICE_NAME account:GRH_TOKEN];
}

@end

