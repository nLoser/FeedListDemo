//
//  MTListAdpter.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/16.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MTListAdpterDataSource.h"

@protocol MTListUpdatingDelegate;

NS_ASSUME_NONNULL_BEGIN

typedef void (^MTListUpdateCompletion)(BOOL finished);

@interface MTListAdpter : NSObject

@property (nonatomic, weak, readonly) UIViewController *viewController;
@property (nonatomic, weak, nullable) UICollectionView *collectionView;

- (instancetype)initWithController:(UIViewController<MTListAdpterDataSource>*)viewController;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
