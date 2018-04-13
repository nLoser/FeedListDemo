//
//  MTFetchBatchUpdateState.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/12.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

typedef NS_ENUM(NSUInteger, MTFetchBatchUpdateState) {
    MTFetchBatchUpdateStateIdle,
    MTFetchBatchUpdateStateWillChangeContext,
    MTFetchBatchUpdateStateDidChangeContext,
    MTFetchBatchUpdateStateQueuedBatchUpdate,
    MTFetchBatchUpdateStateExectingBatchUpdateBlock,
    MTFetchBatchUpdateStateExectedBatchUpdateBlock
};
