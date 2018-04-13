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

#import "MTFetchResultUpdaterDelegate.h"
#import "MTFetchBatchUpdateState.h"

@interface MTFetchMOCAdapterUpdater : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithFetchWithContext:(NSString*)contextName
                                  entity:(NSString *)entityName
                               sortDescs:(NSArray *)sortDescs;

@property (nonatomic, strong, readonly) NSManagedObjectContext *moContext;

@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchController;

@property (nonatomic, strong, readonly) NSString *entityName;
@property (nonatomic, assign, readonly) NSUInteger pageSize;
@property (nonatomic, assign, readonly) int entitysNumber;

@property (nonatomic, assign, readonly) MTFetchBatchUpdateState updateState;

@property (nonatomic, weak) id <MTFetchResultUpdaterDelegate> delegate;

@property (nonatomic, weak) UICollectionView *collectionView;

@end
