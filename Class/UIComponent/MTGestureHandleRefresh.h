//
//  MTGestureHandleRefresh.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/17.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^refreshBlock) (BOOL);

@interface MTGestureHandleRefresh : NSObject

@property (nonatomic, copy) refreshBlock refresh;

- (instancetype)initWithViewController:(UIViewController *)viewController
                            scrollView:(UIScrollView *)scrollView NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

@interface MTGestureHandleRefreshProxy : NSProxy

- (instancetype)initWithScrollViewTarget:(nullable id)scrollViewTarget
                             interceptor:(MTGestureHandleRefresh *)interceptor;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
