//
//  SpinnerSectionController.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/17.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "SpinnerSectionController.h"

#import "MTListAdpter.h"

#import "SpinnerCollectionViewCell.h"

@implementation SpinnerSectionController

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    SpinnerCollectionViewCell *cell = (id)[self.adapter dequeueResuseCellOfClass:[SpinnerCollectionViewCell class] forSectionController:self index:index];
    [cell startAnimating];
    return cell;
}

- (CGSize)sizeForItemItemAtIndex:(NSInteger)index {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(width, 90);
}

@end
