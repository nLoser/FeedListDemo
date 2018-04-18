//
//  MTListAdpterProxy.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/16.
//  Copyright © 2018年 MT.inc. All rights reserved.
/*
 https://github.com/Instagram/IGListKit/blob/master/Source/Internal/IGListAdapterProxy.h
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MTListAdpter.h"

NS_ASSUME_NONNULL_BEGIN

@interface MTListAdpterProxy : NSProxy

- (instancetype)initWithCollectionTarget:(nullable id<UICollectionViewDelegate>)collectionViewTarget
                        scrollViewTarget:(nullable id<UIScrollViewDelegate>)scrollViewTarget
                             interceptor:(MTListAdpter *)interceptor;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
