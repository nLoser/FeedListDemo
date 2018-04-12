//
//  MTListAdapter+UICollectionView.m
//  FeedListDemo
//
//  Created by LV on 2018/4/12.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "MTListAdapter+UICollectionView.h"

#import "MTListAdapterInternal.h"

@implementation MTListAdapter (UICollectionView)

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.updater.fetchController.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.updater.fetchController.sections[section].numberOfObjects;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"id" forIndexPath:indexPath];
    return cell;
}



@end
