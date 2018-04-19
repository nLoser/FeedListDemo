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

#import "MTListUpdatingDelegate.h"

#import "MTListSectionController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MTListUpdater : NSObject <MTListUpdatingDelegate>

@property (nonatomic, assign) NSInteger pageSize;

/**
 Initialize
 */
- (instancetype)initWithEntityName:(NSString *)entityName
                  sortDescriptions:(NSArray<NSSortDescriptor *> *)sortDescriptions
                           section:(NSInteger)section
                    collectionView:(UICollectionView *)collectionView;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context
                                  entityName:(NSString *)entityName
                            sortDescriptions:(NSArray<NSSortDescriptor *> *)sortDescriptions
                                     section:(NSInteger)section
                              collectionView:(UICollectionView *)collectionView NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
