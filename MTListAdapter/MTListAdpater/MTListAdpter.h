//
//  MTListAdpter.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/16.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTListAdpter : NSObject

@property (nonatomic, weak, nullable) UIViewController *viewController;
@property (nonatomic, weak, nullable) UICollectionView *collectionView;

@property (nonatomic, strong, readonly) id updater;

@property (nonatomic, weak, nullable) id <UICollectionViewDelegate> collectionViewDelegate;
@property (nonatomic, weak, nullable) id <UIScrollViewDelegate> scrollViewDelegate;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithUpdater:(id)updater
                 viewController:(UIViewController *)viewController NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
