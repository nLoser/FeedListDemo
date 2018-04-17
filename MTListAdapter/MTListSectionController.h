//
//  MTListSectionController.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/16.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MTListAdpter;

@interface MTListSectionController : NSObject

@property (nonatomic, weak, readonly) MTListAdpter *adapter;

- (CGSize)sizeForItemItemAtIndex:(NSInteger)index;

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index;

- (instancetype)initWithAdpater:(MTListAdpter *)adapter NS_DESIGNATED_INITIALIZER;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end
