//
//  GRHWebServiceImpl.m
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/12.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHWebServiceImpl.h"
#import "AFNetworking.h"
#import "SSKeychain+GRHUtil.h"

@interface GRHWebServiceImpl ()

@property (nonatomic, strong, readwrite) AFHTTPSessionManager *session;

@end

@implementation GRHWebServiceImpl

@synthesize session = _session;

- (AFHTTPSessionManager *)session{
    if(_session == nil){
        AFHTTPSessionManager *session = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:@"https://myseu.cn/ws3/"]];
        [session setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [session setResponseSerializer:[AFJSONResponseSerializer serializer]];
        _session = session;
    }
    NSString *token = SSKeychain.token;
    [_session.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    return _session;
}

- (RACSignal *)authWithCardnum:(NSString *)cardnum password:(NSString *)password {
    return [[RACSignal
              createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                  
                  NSURLSessionDataTask *task = [self.session POST:@"auth" parameters:@{@"cardnum":cardnum, @"password":password, @"platform":@"ios"} progress:^(NSProgress * _Nonnull uploadProgress) {
                      
                  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      [subscriber sendNext:responseObject];
                      [subscriber sendCompleted];
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      [subscriber sendError:error];
                  }];
                  
                  return [RACDisposable disposableWithBlock:^{
                      [task cancel];
                  }];
              }]
            setNameWithFormat:@"-authWithCardnum: %@", cardnum];
}

- (RACSignal *)apiUser{
    return [[RACSignal
             createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                 
                 NSURLSessionDataTask *task = [self.session GET:@"api/user" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
                     
                 } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     [subscriber sendNext:responseObject];
                     [subscriber sendCompleted];
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     [subscriber sendError:error];
                 }];
                 
                 return [RACDisposable disposableWithBlock:^{
                     [task cancel];
                 }];
             }]
            setNameWithFormat:@"webservice:/api/user"];
}


@end
