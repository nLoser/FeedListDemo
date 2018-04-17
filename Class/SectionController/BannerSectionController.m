//
//  BannerSectionController.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/17.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "BannerSectionController.h"
#import "MTListAdpter.h"

@implementation BannerSectionController

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell *cell = [self.adapter dequeueResuseCellOfClass:[UICollectionViewCell class] forSectionController:self index:index];
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

- (CGSize)sizeForItemItemAtIndex:(NSInteger)index {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(width, width * 0.6);
}

@end
