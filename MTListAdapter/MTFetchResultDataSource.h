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

NS_ASSUME_NONNULL_BEGIN

@protocol MTFetchResultDataSourceDelegate <NSObject>

@required

- (void)update:(NSArray *)updateArray delete:(NSArray *)deleteArray insert:(NSArray *)insertArray;

@end

@interface MTFetchResultDataSource : NSObject <NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) id <MTFetchResultDataSourceDelegate> delegate;

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
