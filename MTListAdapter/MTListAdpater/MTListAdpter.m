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
}

@end

@implementation MTListAdpter

#pragma mark - LifeCycle

- (instancetype)initWithUpdater:(id<MTListUpdatingDelegate>)updater
                 viewController:(UIViewController *)viewController {
    if (self = [super init]) {
        _viewSectionControllerMap = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory|NSMapTableObjectPointerPersonality
                                                          valueOptions:NSMapTableStrongMemory];
        
        _updater = updater;
        _viewController = viewController;
    }
    return self;
}

- (void)dealloc {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        self.collectionView.dataSource = nil;
        self.collectionView.delegate = nil;
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
        
        [self updateCollectionVierwDelegate];
        [self updateAfterPublicSettingChange];
    }
}

- (void)setCollectionViewDelegate:(id<UICollectionViewDelegate>)collectionViewDelegate {
    if (_collectionViewDelegate != collectionViewDelegate) {
        _collectionViewDelegate = collectionViewDelegate;
        [self createProxyAndUpdateCollectionViewDelegate];
    }
}

- (void)setScrollViewDelegate:(id<UIScrollViewDelegate>)scrollViewDelegate {
    if (_scrollViewDelegate != scrollViewDelegate) {
        _scrollViewDelegate = scrollViewDelegate;
        [self createProxyAndUpdateCollectionViewDelegate];
    }
}

#pragma mark - Public

- (void)performUpdateAnimated:(BOOL)animated completion:(MTListUpdateCompletion)completion {
    UICollectionView *collectionView = self.collectionView;
    if (collectionView == nil) {
        if (completion) {
            completion(NO);
        }
        return;
    }
    
    //TODO:更新
    [self.updater performUpdateAnimated:animated completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Private - Supply Setter

- (void)updateCollectionVierwDelegate {
    self.collectionView.delegate = (id<UICollectionViewDelegate>)self.delegateProxy ? : self;
}

//TODO: Switch host View to handle latest change
- (void)updateAfterPublicSettingChange {
    
}

- (void)createProxyAndUpdateCollectionViewDelegate {
    self.collectionView.delegate = nil;
    self.delegateProxy = [[MTListAdpterProxy alloc] initWithCollectionTarget:self.collectionViewDelegate
                                                            scrollViewTarget:self.scrollViewDelegate
                                                                 interceptor:self];
    [self updateCollectionVierwDelegate];
}

@end
