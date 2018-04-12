//
//  MTFetchBatchUpdateData.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/12.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTFetchBatchUpdateData : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithInsertIndexPaths:(NSArray<NSIndexPath *> *)insertIndexPath
                         deleteIndexPath:(NSArray<NSIndexPath *> *)deleteIndexPath;

@property (nonatomic, strong, readonly) NSArray<NSIndexPath *> *insertIndexPath;
@property (nonatomic, strong, readonly) NSArray<NSIndexPath *> *deleteIndexPath;

@end
