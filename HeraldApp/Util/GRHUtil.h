//
//  GRHUtil.h
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/10.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GRHUtil : NSObject

@end

@interface NSString (Util)

/// Judging the string is not nil or empty.
///
/// Returns YES or NO.
- (BOOL)isExist;

- (NSString *)firstLetter;

- (BOOL)isMarkdown;

@end

@interface UIColor (Util)

/// Generating a new image by the color.
///
/// Returns a new image.
- (UIImage *)color2Image;

- (UIImage *)color2ImageSized:(CGSize)size;

@end

@interface NSMutableArray (GRHSafeAdditions)

- (void)grh_addObject:(id)object;

@end
NS_ASSUME_NONNULL_END
