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
    NSMutableDictionary<NSNumber *, MTListSectionController *> *_sectionControllerMap;
    NSMutableDictionary<NSNumber *, MTFetchMOCAdapterUpdater *> *_entitySectionMap;
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
        
        _entitySectionMap = [NSMutableDictionary dictionaryWithCapacity:0];
        _sectionControllerMap = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [self _bindSectionUpdater];
    }
    return self;
}

#pragma mark - Custom Accessors

- (UICollectionView *)collectionView {
    return _collectionView;
}

- (void)setCollectionView:(UICollectionView *)collectionView {
    if (_collectionView != collectionView || _collectionView.dataSource != self) {
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
        
        [self performUpdateAfterChange];
    }
}

- (void)performUpdateAfterChange {
    __weak typeof(self) weakSelf = self;
    [_entitySectionMap enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, MTFetchMOCAdapterUpdater * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj performUpdateWithCollectionView:weakSelf.collectionView animated:YES completion:nil];
    }];
}

#pragma mark - Private - Supply Setter

- (void)_bindSectionUpdater {
    NSArray<MTListSectionModel *> *resources = [self.dataSource objectsForListAdpater:self];
    NSInteger section = 0;
    for (MTListSectionModel *model in resources) {
        MTListSectionController *sectionController = [self.dataSource listAdapter:self sectionControllerForObject:model];
        [_sectionControllerMap setObject:sectionController forKey:@(section)];
        
        if (model.bindCoreData) {
            MTFetchMOCAdapterUpdater *updater = [[MTFetchMOCAdapterUpdater alloc] initWithManagedObjectContext:model.managedObjectContext
                                                                                                    entityName:model.entityName
                                                                                              sortDescriptions:model.descriptors
                                                                                             sectionController:sectionController
                                                                                                       section:section];
            [_entitySectionMap setObject:updater forKey:@(section)];
        }
        section ++;
    }
}

@end
