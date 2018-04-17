//
//  MTListAdpterDataSource.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/16.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MTListSectionModel.h"

@class MTListAdpter;
@class MTListSectionController;

NS_ASSUME_NONNULL_BEGIN

@protocol MTListAdpterDataSource <NSObject>

- (NSArray<MTListSectionModel *> *)objectsForListAdpater:(MTListAdpter *)listAdapter;

- (MTListSectionController *)listAdapter:(MTListAdpter *)listAdapter sectionControllerForObject:(MTListSectionModel *)object;

@end

NS_ASSUME_NONNULL_END
