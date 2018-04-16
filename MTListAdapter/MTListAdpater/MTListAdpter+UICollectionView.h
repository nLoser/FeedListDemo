//
//  MTListAdpter+UICollectionView.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/16.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTListAdpter.h"

NS_ASSUME_NONNULL_BEGIN

@interface MTListAdpter (UICollectionView)
<
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@end

NS_ASSUME_NONNULL_END
