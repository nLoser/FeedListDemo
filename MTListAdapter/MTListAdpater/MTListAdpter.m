//
//  MTListAdpter.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/16.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "MTListAdpter+MTListAdpterInternal.h"

@interface MTListAdpter() {
    NSMapTable<MTListSectionController *, NSNumber *> *_controllerSectionMap;
    NSMutableDictionary<NSNumber *, MTListSectionController *> *_sectionControllerMap;
    NSMutableDictionary<NSNumber *, MTFetchMOCAdapterUpdater *> *_entitySectionMap;
}

@property (nonatomic, strong) NSArray<MTListSectionModel *> *resourcesArray;
@property (nonatomic, weak) id<MTListAdpterDataSource> dataSource;

@end

@implementation MTListAdpter

#pragma mark - LifeCycle

- (instancetype)initWithDataSource:(id<MTListAdpterDataSource>)dataSource {
    if (self = [super init]) {
        _dataSource = dataSource;
        
        _entitySectionMap = [NSMutableDictionary dictionaryWithCapacity:0];
        _sectionControllerMap = [NSMutableDictionary dictionaryWithCapacity:0];
        
        _controllerSectionMap = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory
                                                      valueOptions:NSPointerFunctionsStrongMemory];
        
        [self bindSectionUpdater];
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
        //_collectionView.delegate = self;
        
        [self performUpdateAfterChange];
    }
}

#pragma mark - Public

- (UICollectionViewCell *)dequeueResuseCellOfClass:(Class)cellClass
                              forSectionController:(MTListSectionController *)sectionController
                                             index:(NSInteger)index {
    UICollectionView *collectionView = self.collectionView;
    NSString *identifier = IGListReusableViewIdentifier(cellClass, nil, nil);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:[[_controllerSectionMap objectForKey:sectionController] integerValue]];
    if (![self.regiseterCellClass containsObject:cellClass]) {
        [self.regiseterCellClass addObject:cellClass];
        [collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
    }
    return [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (UICollectionViewCell *)dequeueResuseCellOfClassWithNibName:(NSString *)nibName
                                                       bundle:(NSBundle *)bundle
                                         forSectionController:(MTListSectionController *)sectionController
                                                        index:(NSInteger)index {
    UICollectionView *collectionView = self.collectionView;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:[[_controllerSectionMap objectForKey:sectionController] integerValue]];
    if (![self.registerNibName containsObject:nibName]) {
        [self.registerNibName addObject:nibName];
        UINib *nib = [UINib nibWithNibName:nibName bundle:bundle];
        [collectionView registerNib:nib forCellWithReuseIdentifier:nibName];
    }
    return [collectionView dequeueReusableCellWithReuseIdentifier:nibName forIndexPath:indexPath];
}

- (id)objectForSectionController:(MTListSectionController *)sectionController index:(NSInteger)index {
    NSInteger section = [[_controllerSectionMap objectForKey:sectionController] integerValue];
    MTFetchMOCAdapterUpdater *updater = [_entitySectionMap objectForKey:@(section)];
    id object = [updater dataForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    return object;
}

- (MTListSectionModel *)sectionObjectForSection:(NSInteger)section {
    if (section >= _resourcesArray.count) return nil;
    return [_resourcesArray objectAtIndex:section];
}

- (CGSize)sizeForSectionAtIndexPath:(NSIndexPath *)indexPath {
    MTListSectionController *sectionController = [self mapSectionController:indexPath.section];
    return [sectionController sizeForItemItemAtIndex:indexPath.row];
}

- (void)reloadSection:(NSUInteger)section {
    [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:section]];
}

#pragma mark - Private

- (void)performUpdateAfterChange {
    __weak typeof(self) weakSelf = self;
    [_entitySectionMap enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, MTFetchMOCAdapterUpdater * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj performUpdateWithCollectionView:weakSelf.collectionView animated:YES completion:nil];
    }];
}

- (MTListSectionController *)mapSectionController:(NSInteger)section {
    return [_sectionControllerMap objectForKey:@(section)];
}

- (MTFetchMOCAdapterUpdater *)mapMOCUpdater:(NSInteger)section {
    return [_entitySectionMap objectForKey:@(section)];
}

- (NSInteger)sectionNumber {
    return _sectionControllerMap.count;
}

#pragma mark - Private - Supply Setter

- (void)bindSectionUpdater {
    NSArray<MTListSectionModel *> *resources = [self.dataSource objectsForListAdpater:self];
    self.resourcesArray = [resources copy];
    
    NSInteger section = 0;
    for (MTListSectionModel *model in resources) {
        MTListSectionController *sectionController = [self.dataSource listAdapter:self sectionControllerForObject:model];
        [_sectionControllerMap setObject:sectionController forKey:@(section)];
        [_controllerSectionMap setObject:@(section) forKey:sectionController];
        
        if (model.bindCoreData) {
            MTFetchMOCAdapterUpdater *updater = \
            [[MTFetchMOCAdapterUpdater alloc] initWithManagedObjectContext:model.managedObjectContext
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
