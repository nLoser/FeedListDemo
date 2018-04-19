//
//  MTListAdpter+MTListAdpterInternal.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/16.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "MTListAdpter.h"
#import "MTListAdpter+UICollectionView.h"

#import "MTListUpdater.h"

NS_ASSUME_NONNULL_BEGIN

/// Generate a string representation of a reusable view class when registering with a UICollectionView.
NS_INLINE NSString *IGListReusableViewIdentifier(Class viewClass, NSString * _Nullable nibName, NSString * _Nullable kind) {
    return [NSString stringWithFormat:@"%@%@%@", kind ?: @"", nibName ?: @"", NSStringFromClass(viewClass)];
}

@interface MTListAdpter ()

@property (nonatomic, assign) BOOL isDequeueingCell;

@property (nonatomic, strong) NSMutableSet<Class> *regiseterCellClass;
@property (nonatomic, strong) NSMutableSet<NSString *> *registerNibName;

- (MTListUpdater *)mapMOCUpdater:(NSInteger)section;
- (NSInteger)sectionNumber;

@end

NS_ASSUME_NONNULL_END
