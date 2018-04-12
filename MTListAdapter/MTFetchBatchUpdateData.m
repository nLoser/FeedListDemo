//
//  MTFetchBatchUpdateData.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/12.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "MTFetchBatchUpdateData.h"

@interface MTFetchBatchUpdateData()
@property (nonatomic, strong, readwrite) NSArray<NSIndexPath *> *insertIndexPath;
@property (nonatomic, strong, readwrite) NSArray<NSIndexPath *> *deleteIndexPath;
@end

@implementation MTFetchBatchUpdateData

- (instancetype)initWithInsertIndexPaths:(NSArray<NSIndexPath *> *)insertIndexPath deleteIndexPath:(NSArray<NSIndexPath *> *)deleteIndexPath {
    if (self = [super init]) {
        _insertIndexPath = [insertIndexPath copy];
        _deleteIndexPath = [deleteIndexPath copy];
    }
    return self;
}

@end
