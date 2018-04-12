//
//  MTListAdapter.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/11.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MTFetchMOCAdapterUpdater.h"

/**
 当列表更新完成时执行的代码块
 @param finished 制定更新动画是否完成
 */
typedef void(^MTListUpdaterCompletion) (BOOL finished);

@interface MTListAdapter : NSObject

@property (nonatomic, nullable, weak) UIViewController *viewControllr;

@property (nonatomic, nullable, weak) UICollectionView *collectionView;

@property (nonatomic, strong, readonly) MTFetchMOCAdapterUpdater *updater;

- (instancetype)initWithUpdater:(MTFetchMOCAdapterUpdater *)updater viewController:(UIViewController *)viewController;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
