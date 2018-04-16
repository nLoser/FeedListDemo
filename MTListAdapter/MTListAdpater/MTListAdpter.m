//
//  MTListAdpter.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/16.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "MTListAdpter+MTListAdpterInternal.h"

@interface MTListAdpter() {
    NSMapTable <id, id> *_viewSectionControllerMap;
    NSMapTable <NSString *, MTListAdpter *> *_entitySectionMap;
}

@property (nonatomic, weak, readwrite) id <MTListAdpterDataSource> dataSource;
@property (nonatomic, weak, readwrite) UIViewController *viewController;

@end

@implementation MTListAdpter

#pragma mark - LifeCycle

- (instancetype)initWithController:(UIViewController<MTListAdpterDataSource> *)viewController {
    if (self = [super init]) {
        self.dataSource = viewController;
        _viewController = viewController;
        
        _entitySectionMap = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory|NSMapTableObjectPointerPersonality
                                                  valueOptions:NSMapTableStrongMemory];
        
        [self _bindSectionUpdater];
    }
    return self;
}

- (void)_bindSectionUpdater {
    NSArray<MTListSectionModel *> *resources = [self.dataSource objectsForListAdpater:self];
    for (MTListSectionModel *model in resources) {
        
    }
}

#pragma mark - Custom Accessors

- (UICollectionView *)collectionView {
    return _collectionView;
}

- (void)setCollectionView:(UICollectionView *)collectionView {
    if (_collectionView != collectionView || _collectionView.dataSource != self) {
        //Global
        static NSMapTable<UICollectionView * , MTListAdpter *> *globalCollectionViewAdpaterMap = nil;
        if (globalCollectionViewAdpaterMap == nil) {
            globalCollectionViewAdpaterMap = [NSMapTable weakToWeakObjectsMapTable];
        }
        [globalCollectionViewAdpaterMap removeObjectForKey:_collectionView];
        [[globalCollectionViewAdpaterMap objectForKey:collectionView] setCollectionView:nil];;
        [globalCollectionViewAdpaterMap setObject:self forKey:collectionView];
        
        _registerNibName = [NSMutableSet new];
        _regiseterCellClass = [NSMutableSet new];
        
        _collectionView = collectionView;
        _collectionView.dataSource = self; ///< Core
        [_collectionView.collectionViewLayout invalidateLayout];
        
        [self updateAfterPublicSettingChange];
    }
}

#pragma mark - Private - Supply Setter

//TODO: Switch host View to handle latest change
- (void)updateAfterPublicSettingChange {
    
}

@end
