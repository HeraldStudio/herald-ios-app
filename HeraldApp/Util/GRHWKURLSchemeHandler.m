//
//  GRHWKURLSchemeHandler.m
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/17.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHWKURLSchemeHandler.h"

@implementation GRHWKURLSchemeHandler

- (NSString *)getMIMETypeWithCAPIAtFilePath:(NSString *)path
{
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
        return nil;
    }
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
        return @"application/octet-stream";
    }
    return (__bridge NSString *)(MIMEType);
}

- (void)webView:(nonnull WKWebView *)webView startURLSchemeTask:(nonnull id<WKURLSchemeTask>)urlSchemeTask  API_AVAILABLE(ios(11.0)){
    NSLog(@"拦截到请求的URL：%@", urlSchemeTask.request.URL);
    NSString *localFileName = [urlSchemeTask.request.URL lastPathComponent];
    NSLog(@"本地文件名称：%@", localFileName);
    NSString *localFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    localFilePath = [localFilePath stringByAppendingPathComponent:@"hybrid-package"];
    localFilePath = [localFilePath stringByAppendingPathComponent:localFileName];
    NSLog(@"本地文件路径：%@", localFilePath);
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:localFilePath];
    NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    NSString *fileMIME = [self getMIMETypeWithCAPIAtFilePath:localFilePath];
    NSLog(@"文件MIME：%@", fileMIME);
    NSDictionary *responseHeader = @{
                                     @"Content-type":fileMIME,
                                     @"Content-length":[NSString stringWithFormat:@"%lu",(unsigned long)[data length]]
                                     };
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"herald-hybrid://hybrid-ios.myseu.cn/", localFileName]] statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:responseHeader];
    [urlSchemeTask didReceiveResponse:response];
    [urlSchemeTask didReceiveData:data];
    [urlSchemeTask didFinish];
}

- (void)webView:(nonnull WKWebView *)webView stopURLSchemeTask:(nonnull id<WKURLSchemeTask>)urlSchemeTask  API_AVAILABLE(ios(11.0)){
    
}

@end
