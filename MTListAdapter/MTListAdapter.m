//
//  MTListAdapter.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/11.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "MTListAdapterInternal.h"

@interface MTListAdapter()

@end

@implementation MTListAdapter

- (instancetype)initWithUpdater:(MTFetchMOCAdapterUpdater *)updater viewController:(UIViewController *)viewController {
    if (self = [super init]) {
        _updater = updater;
        _viewControllr = viewController;
    }
    return self;
}

#pragma mark - Custom Accessors

- (void)setCollectionView:(UICollectionView *)collectionView {
    if (_collectionView != collectionView || _collectionView.dataSource != self) {
        
        _registerNibNames = [NSMutableSet new];
        _registerCellClasses = [NSMutableSet new];
        
        _collectionView = collectionView;
    }
}

@end
