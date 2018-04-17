//
//  BannerSectionController.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/17.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "BannerSectionController.h"
#import "MTListAdpter.h"

#import "BannerViewCell.h"

@implementation BannerSectionController

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    BannerViewCell *cell = (id)[self.adapter dequeueResuseCellOfClass:[BannerViewCell class] forSectionController:self index:index];
    cell.dataSources = @[];
    return cell;
}

- (CGSize)sizeForItemItemAtIndex:(NSInteger)index {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(width, width * 0.4);
}

@end
