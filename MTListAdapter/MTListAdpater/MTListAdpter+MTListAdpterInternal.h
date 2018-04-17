//
//  MTListAdpter+MTListAdpterInternal.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/16.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "MTListAdpter.h"

#import "MTListAdpterProxy.h"
#import "MTListAdpter+UICollectionView.h"

#import "MTFetchMOCAdapterUpdater.h"

NS_ASSUME_NONNULL_BEGIN

/// Generate a string representation of a reusable view class when registering with a UICollectionView.
NS_INLINE NSString *IGListReusableViewIdentifier(Class viewClass, NSString * _Nullable nibName, NSString * _Nullable kind) {
    return [NSString stringWithFormat:@"%@%@%@", kind ?: @"", nibName ?: @"", NSStringFromClass(viewClass)];
}

@interface MTListAdpter () {
    __weak UICollectionView *_collectionView;
    BOOL _isDequeueingCell;
}

@property (nonatomic, strong, nullable) MTListAdpterProxy *delegateProxy;

@property (nonatomic, strong) NSMutableSet<Class> *regiseterCellClass;
@property (nonatomic, strong) NSMutableSet<NSString *> *registerNibName;

- (MTFetchMOCAdapterUpdater *)mapMOCUpdater:(NSInteger)section;
- (NSInteger)sectionNumber;

@end

NS_ASSUME_NONNULL_END
