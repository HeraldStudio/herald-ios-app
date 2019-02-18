//
//  SSKeyChain+GRHUtil.h
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/12.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import <SSKeychain/SSKeychain.h>

@interface SSKeychain (GRHUtil)

+ (NSString *)token;

+ (BOOL)setToken:(NSString *)token;

+ (BOOL)deleteToken;

@end
