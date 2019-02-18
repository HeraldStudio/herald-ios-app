//
//  GRHHybridService.h
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/15.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"
@protocol GRHHybridService <NSObject>

- (RACSignal *)updateOfflinePackage:(NSString *)packageName; // 获取离线包
- (RACSignal *)fetchLocalizedFileList; // 获取离线文件列表

@end
