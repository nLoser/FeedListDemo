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

@interface MTFetchMOCAdapterUpdater : NSObject<MTListUpdatingDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;

- (instancetype)initWithEntityName:(NSString *)entityName
                  sortDescriptions:(NSArray<NSSortDescriptor *> *)sortDescriptions
                 sectionController:(MTListSectionController *)sectionController
                           section:(NSInteger)section;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context
                                  entityName:(NSString *)entityName
                            sortDescriptions:(NSArray<NSSortDescriptor *> *)sortDescriptions
                           sectionController:(MTListSectionController *)sectionController
                                     section:(NSInteger)section NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
