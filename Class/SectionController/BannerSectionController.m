//
//  BannerSectionController.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/17.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "BannerSectionController.h"

@implementation BannerSectionController

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
//    UICollectionViewCell *cell = (id)[self.adapter dequeueResuseCellOfClass:[UICollectionViewCell class] forSectionController:self index:index];
    return nil;
}

- (CGSize)sizeForItemItemAtIndex:(NSInteger)index {
    CGFloat width = [UIScreen mainScreen].bounds.size.width/2.f-0.5;
    return CGSizeMake(width, width * 1.2);
}

@end
