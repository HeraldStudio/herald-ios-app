//
//  GRHUtil.m
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/10.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHUtil.h"

@implementation GRHUtil

@end

@implementation NSString (Util)

- (BOOL)isExist {
    return self && ![self isEqualToString:@""];
}

- (NSString *)firstLetter {
    return [[self substringToIndex:1] uppercaseString];
}

- (BOOL)isMarkdown {
    if (![self isExist]) return NO;
    
    NSArray *markdownExtensions = @[ @".md", @".mkdn", @".mdwn", @".mdown", @".markdown", @".mkd", @".mkdown", @".ron" ];
    for (NSString *extension in markdownExtensions) {
        if ([self.lowercaseString hasSuffix:extension]) return YES;
    }
    
    return NO;
}

@end

@implementation UIColor (Util)

- (UIImage *)color2Image {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)color2ImageSized:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@implementation NSMutableArray (GRHSafeAdditions)

- (void)grh_addObject:(id)object {
    if (!object) return;
    [self addObject:object];
}

@end
