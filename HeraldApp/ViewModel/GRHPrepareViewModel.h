//
//  GRHPrepareViewModel.h
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/14.
//  Copyright © 2019 Herald Studio. All rights reserved.
//

#import "GRHViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GRHPrepareViewModel : GRHViewModel

@property (nonatomic, strong, readwrite) NSNumber *startAnimation;
@property (nonatomic, strong, readonly) RACSignal *animationSignal;

-(void) done;
@end

NS_ASSUME_NONNULL_END
