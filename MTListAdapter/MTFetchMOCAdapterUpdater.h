//
//  MTFetchResultController.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/12.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "MTFetchBatchUpdateState.h"

NS_ASSUME_NONNULL_BEGIN

@interface MTFetchMOCAdapterUpdater : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithEntityName:(NSString *)entityName
                  sortDescriptions:(NSArray<NSSortDescriptor *> *)sortDescriptions
                    collectionView:(UICollectionView *)collectionView;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context
                                  entityName:(NSString *)entityName
                            sortDescriptions:(NSArray<NSSortDescriptor *> *)sortDescriptions
                              collectionView:(UICollectionView *)collectionView NS_DESIGNATED_INITIALIZER;

@property (nonatomic, assign, readonly) NSInteger entitysNumber;
@property (nonatomic, assign, readonly) MTFetchBatchUpdateState updateState;

//以下属性后续不不能暴漏
@property (nonatomic, weak, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchController;
@property (nonatomic, strong, readonly) NSString *entityName;

@end

NS_ASSUME_NONNULL_END
