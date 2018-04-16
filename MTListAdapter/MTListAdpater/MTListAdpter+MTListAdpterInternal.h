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

NS_ASSUME_NONNULL_BEGIN

@interface MTListAdpter () {
    __weak UICollectionView *_collectionView;
    BOOL _isDequeueingCell;
}

@property (nonatomic, strong, nullable) MTListAdpterProxy *delegateProxy;

@property (nonatomic, strong) NSMutableSet<Class> *regiseterCellClass;
@property (nonatomic, strong) NSMutableSet<NSString *> *registerNibName;

@end

NS_ASSUME_NONNULL_END
