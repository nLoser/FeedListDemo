//
//  MTListAdapter.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/11.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 当列表更新完成时执行的代码块
 @param finished 制定更新动画是否完成
 */
typedef void(^MTListUpdaterCompletion) (BOOL finished);

/**
 MTListAdpater提供抽象的刷新对象给每组SectionController（根据Section分出来的Controller，它管理dataSource和Delegate）
 */
@interface MTListAdapter : NSObject

@property (nonatomic, nullable, weak) UIViewController *viewControllr;

@property (nonatomic, nullable, weak) UICollectionView *collectionView;

@property (nonatomic, strong, readonly) id updater;

@end
