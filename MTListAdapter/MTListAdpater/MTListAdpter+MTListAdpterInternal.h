//
//  MTListAdpter+MTListAdpterInternal.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/16.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "MTListAdpter.h"

#import "MTListAdpter+UICollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MTListAdpter () {
    BOOL _isDequeueingCell; ///< 是否出队列
}

@end

NS_ASSUME_NONNULL_END
