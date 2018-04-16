//
//  MTListAdpter.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/16.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "MTListAdpter+MTListAdpterInternal.h"

@interface MTListAdpter()

@property (nonatomic, strong, readwrite) id updater;

@end

@implementation MTListAdpter

#pragma mark - LifeCycle

- (instancetype)initWithUpdater:(id)updater
                 viewController:(UIViewController *)viewController {
    if (self = [super init]) {
        _updater = updater;
        _viewController = viewController;
    }
    return self;
}

- (void)dealloc {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        _collectionView.dataSource = nil;
        _collectionView.delegate = nil;
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

#pragma mark - Private - Supply Setter

- (void)updateCollectionVierwDelegate {
    _collectionView.delegate = (id<UICollectionViewDelegate>)self.delegateProxy ? : self;
}

//TODO: Switch host View to handle latest change
- (void)updateAfterPublicSettingChange {
    
}

- (void)createProxyAndUpdateCollectionViewDelegate {
    _collectionView.delegate = nil;
    self.delegateProxy = [[MTListAdpterProxy alloc] initWithCollectionTarget:_collectionViewDelegate
                                                            scrollViewTarget:_scrollViewDelegate
                                                                 interceptor:self];
    [self updateCollectionVierwDelegate];
}

@end
