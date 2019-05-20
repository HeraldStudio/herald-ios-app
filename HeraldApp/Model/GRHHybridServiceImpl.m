//
//  GRHHybridServiceImpl.m
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/16.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHHybridServiceImpl.h"
#import "ReactiveObjC.h"
#import "SSZipArchive.h"

@interface GRHHybridServiceImpl ()

@property (nonatomic, strong, readwrite) AFHTTPSessionManager *session;

@end

@implementation GRHHybridServiceImpl
@synthesize session = _session;

- (AFHTTPSessionManager *)session{
    if(_session == nil){
        AFHTTPSessionManager *session = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:GRH_HYBRID_BASEURL]];
        [session.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
        //[session setRequestSerializer:[AFJSONRequestSerializer serializer]];
        //[session setResponseSerializer:[AFJSONResponseSerializer serializer]];
        _session = session;
    }
    return _session;
}

- (RACSignal *)fetchLocalizedFileList {
    return [[RACSignal
             createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                 
                 [self.session setRequestSerializer:[AFJSONRequestSerializer serializer]];
                 [self.session.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
                 [self.session setResponseSerializer:[AFJSONResponseSerializer serializer]];
                 
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 
                 NSURLSessionDataTask *task = [self.session GET:@"info.json" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
                     
                 } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     NSData *fileListData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                     NSLog(@"线上离线包信息:%@", responseObject[@"packageName"]);
                     [defaults setObject:fileListData forKey:GRH_HYBRID_PACKAGE_INFO_DEFAULTS];
                     [subscriber sendNext:responseObject];
                     [subscriber sendCompleted];
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     // 从网络获取出错则尝试从本地获取
                     NSLog(@"获取离线包信息过程中出现网络错误，使用本地数据");
                     NSData *fileListData = [defaults objectForKey:GRH_HYBRID_PACKAGE_INFO_DEFAULTS];
                     id responseObject = nil;
                     
                     if(fileListData != nil) {
                         responseObject = [NSJSONSerialization JSONObjectWithData:fileListData options:NSJSONReadingAllowFragments error:nil];
                     }
                     
                     if(responseObject != nil){
                         [subscriber sendNext:responseObject];
                         [subscriber sendCompleted];
                     } else {
                         [subscriber sendError:error];
                     }
                     
                 }];
                 
                 return [RACDisposable disposableWithBlock:^{
                     [task cancel];
                 }];
             }]
            setNameWithFormat:@"-fetchLocalizedFileList"];
}

- (RACSignal *)updateOfflinePackage:(NSString *)packageName {
    return [[RACSignal
             createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                 
                 // 构造保存路径
                 NSString *savePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
                 savePath = [savePath stringByAppendingPathComponent:packageName];
                 NSLog(@"离线包保存本地路径 - %@",savePath);
                 NSFileManager *fileManager = [NSFileManager defaultManager];
                 if([fileManager fileExistsAtPath:savePath]){
                     // 如果文件已经存在则不再进行下载，直接返回
                     [subscriber sendNext:nil];
                     [subscriber sendCompleted];
                     return [RACDisposable disposableWithBlock:^{
                         return;
                     }];
                 }
                 // 当前离线包不存在开始下载
                 NSLog(@"正在下载离线包 - %@", [NSString stringWithFormat:@"%@%@", GRH_HYBRID_BASEURL, packageName]);
                 [self.session setRequestSerializer:[AFJSONRequestSerializer serializer]];
                 [self.session setResponseSerializer:[AFHTTPResponseSerializer serializer]];
                 NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", GRH_HYBRID_BASEURL, packageName]]] progress:^(NSProgress * _Nonnull downloadProgress) {
                     NSLog(@"下载进度 - %f \n\n",downloadProgress.completedUnitCount / (downloadProgress.totalUnitCount / 1.0));
                 } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                     // 将离线包保存到 Library/Caches/<packageName>.zip
                     return [NSURL fileURLWithPath:savePath];
                 } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                     // 完成后开始解压过程
                     NSLog(@"completeHandler");
                     NSString *extraPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
                     extraPath = [extraPath stringByAppendingPathComponent:@"hybrid-package"];
                     if([fileManager fileExistsAtPath:extraPath]) {
                         // 清除已有目录
                         [fileManager removeItemAtPath:extraPath error:nil];
                     }
                     [fileManager createDirectoryAtPath:extraPath withIntermediateDirectories:YES attributes:nil error:nil];
                     // 解压离线包
                     [SSZipArchive unzipFileAtPath:savePath toDestination:extraPath];
                     if(error != nil) {
                         [subscriber sendError:error];
                         [subscriber sendCompleted];
                     } else {
                         [subscriber sendNext:nil];
                         [subscriber sendCompleted];
                     }
                 }];
                 
                 [downloadTask resume];
                 
                 return [RACDisposable disposableWithBlock:^{
                     [downloadTask cancel];
                 }];
             }]
            setNameWithFormat:@"-fetchLocalizedFileList"];
}

@end
