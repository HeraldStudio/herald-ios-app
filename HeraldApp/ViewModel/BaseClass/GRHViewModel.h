//
//  GRHViewModel.h
//  HeraldApp
//
//  Created by Wolf-Tungsten on 2019/2/8.
//  Copyright © 2019 Herald Studio. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "GRHConstant.h"
#import "GRHViewModelServices.h"

/// The type of the title view.
typedef NS_ENUM(NSUInteger, GRHTitleViewType) {
    /// System title view
    GRHTitleViewTypeDefault,
    /// Double title view
    GRHTitleViewTypeDoubleTitle,
    /// Loading title view
    GRHTitleViewTypeLoadingTitle
};

/// An abstract class representing a view model.
@interface GRHViewModel : NSObject

/// Initialization method. This is the preferred way to create a new view model.
///
/// services - The service bus of the `Model` layer.
/// params   - The parameters to be passed to view model.
///
/// Returns a new view model.
- (instancetype)initWithServices:(id<GRHViewModelServices>)services params:(NSDictionary *)params;

/// The `services` parameter in `-initWithServices:params:` method.
@property (nonatomic, strong, readonly) id<GRHViewModelServices> services;

/// The `params` parameter in `-initWithServices:params:` method.
@property (nonatomic, copy, readonly) NSDictionary *params;

@property (nonatomic, assign) GRHTitleViewType titleViewType;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

/// The callback block.
@property (nonatomic, copy) VoidBlock_id callback;

/// A RACSubject object, which representing all errors occurred in view model.
@property (nonatomic, strong, readonly) RACSubject *errors;

@property (nonatomic, assign) BOOL shouldFetchLocalDataOnViewModelInitialize;
@property (nonatomic, assign) BOOL shouldRequestRemoteDataOnViewDidLoad;

@property (nonatomic, strong, readonly) RACSubject *willDisappearSignal;

@property (nonatomic, strong, readwrite) NSNumber *showLoading;
@property (nonatomic, strong, readonly) RACSignal *showLoadingSignal;

@property (nonatomic, strong, readwrite) NSString *toastText;
@property (nonatomic, strong, readonly) RACSignal *toastSignal;
/// An additional method, in which you can initialize data, RACCommand etc.
/// This method will be execute after the execution of `-initWithServices:params:` method. But
/// the premise is that you need to inherit `GRHViewModel`.
- (void)initialize;

- (void)check401:(id)responseObject;

@end


