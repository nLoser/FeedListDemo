//
//  RecommendSectionController.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/17.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "RecommendSectionController.h"

#import <YYKit/NSObject+YYModel.h>

#import "MTListAdpter.h"

#import "FeedLiveViewCell.h"

@implementation RecommendSectionController

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    FeedLiveViewCell *cell = (id)[self.adapter dequeueResuseCellOfClass:[FeedLiveViewCell class] forSectionController:self index:index];
    Recommend *model = [self.adapter objectForSectionController:self index:index];
    MTRecommendLiveModel *liveModel = [MTRecommendLiveModel modelWithJSON:model.live];
    cell.model = liveModel;
    cell.indexString = [NSString stringWithFormat:@"%ld",(long)index];
    return cell;
}

- (CGSize)sizeForItemItemAtIndex:(NSInteger)index {
    CGFloat width = [UIScreen mainScreen].bounds.size.width/2.f-0.5;
    return CGSizeMake(width, width * 1.2);
}

@end
