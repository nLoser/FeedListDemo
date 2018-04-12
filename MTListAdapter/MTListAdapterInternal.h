//
//  MTListAdapterInternal.h
//  FeedListDemo
//
//  Created by LV on 2018/4/12.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "MTListAdapter.h"
#import "MTListAdapter+UICollectionView.h"

@interface MTListAdapter () {
    __weak UICollectionView * _collectionView;
}

@property (nonatomic, strong) MTFetchMOCAdapterUpdater *updater;

@property (nonatomic, strong) NSMutableSet<Class> *registerCellClasses;
@property (nonatomic, strong) NSMutableSet<NSString *> *registerNibNames;

@end
