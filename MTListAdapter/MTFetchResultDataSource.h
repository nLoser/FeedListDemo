//
//  MTFetchResultDataSource.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/19.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

#import "MTFetchBatchUpdateState.h"

#import "MTListUpdaterDataSourceDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MTFetchResultDataSource : NSObject <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readonly) NSMutableArray *deleteArray;
@property (nonatomic, strong, readonly) NSMutableArray *insertArray;
@property (nonatomic, strong, readonly) NSMutableArray *updateArray;

@property (nonatomic, weak) id <MTListUpdaterDataSourceDelegate> delegate;

@property (nonatomic, assign) MTFetchBatchUpdateState updateState;

/**
 Initialize
 */
- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context
                                  entityName:(NSString *)entityName
                            sortDescriptions:(NSArray<NSSortDescriptor *> *)sortDescriptions
                                     section:(NSInteger)section;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 Public
 */
@property (nonatomic, assign, readonly) NSUInteger numberOfObjects; ///< Cache
@property (nonatomic, assign, readonly) NSUInteger numberOfEntityObjects; ///< DBTable

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
