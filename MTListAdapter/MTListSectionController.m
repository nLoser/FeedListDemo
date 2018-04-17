//
//  MTListSectionController.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/16.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "MTListSectionController.h"
#import "MTListAdpter.h"

@interface MTListSectionController ()
@property (nonatomic, weak, readwrite) MTListAdpter *adapter;
@end

@implementation MTListSectionController

- (instancetype)initWithAdpater:(MTListAdpter *)adapter {
    if (self = [super init]) {
        _adapter = adapter;
    }
    return self;
}

#pragma mark - Need Override

- (CGSize)sizeForItemItemAtIndex:(NSInteger)index {
    return CGSizeZero;
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    NSCAssert(NO, @"需要重写 cellForItemAtIndex");
    return nil;
}

@end
