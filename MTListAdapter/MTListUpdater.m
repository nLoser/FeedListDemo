//
//  MTFetchResultController.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/12.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "MTListUpdater.h"
#import <UIKit/UIKit.h>

#import "MTGlobalManagedObjectContext.h"
#import "MTFetchResultDataSource.h"

@interface MTListUpdater()

@property (nonatomic, strong) MTFetchResultDataSource *fetchResult;
@property (nonatomic, assign) NSInteger section;

@end

@implementation MTListUpdater

#pragma mark - LifeCycle

- (instancetype)initWithEntityName:(NSString *)entityName
                  sortDescriptions:(NSArray<NSSortDescriptor *> *)sortDescriptions
                           section:(NSInteger)section{
    NSManagedObjectContext *mainContext = [MTGlobalManagedObjectContext shareManager].managedObjectContext;
    return [self initWithManagedObjectContext:mainContext
                                   entityName:entityName
                             sortDescriptions:sortDescriptions
                                      section:section];
}

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context
                                  entityName:(NSString *)entityName
                            sortDescriptions:(NSArray<NSSortDescriptor *> *)sortDescriptions
                                     section:(NSInteger)section{
    if (self = [super init]) {
        _section = section;
        _fetchResult = [[MTFetchResultDataSource alloc] initWithManagedObjectContext:context
                                                                          entityName:entityName
                                                                    sortDescriptions:sortDescriptions
                                                                             section:section];
    }
    return self;
};

#pragma mark - MTListUpdatingDelegate

- (void)performUpdateWithCollectionView:(UICollectionView *)collection animated:(BOOL)animated completion:(MTListUpdatingCompletion)completion {
#if 0
    if(collection == nil) return;
    if (_collectionView != collection) {
        _collectionView = collection;
    }
    
    __weak typeof(self) weakSelf = self;
    void (^executeUpdateBlock)(void) = ^{
        weakSelf.updateState = MTFetchBatchUpdateStateExectingBatchUpdateBlock;
        
        NSArray *updateArr = [weakSelf.updateArray copy];
        NSArray *insertArr = [weakSelf.insertArray copy];
        NSArray *deleteArr = [weakSelf.deleteArray copy];
        
        [weakSelf resetBatchUpdate];
        
        [collection reloadItemsAtIndexPaths:updateArr];
        [collection insertItemsAtIndexPaths:insertArr];
        [collection deleteItemsAtIndexPaths:deleteArr];
        
        weakSelf.updateState = MTFetchBatchUpdateStateExectedBatchUpdateBlock;
    };
    
    [collection performBatchUpdates:executeUpdateBlock completion:^(BOOL finished) {
        weakSelf.updateState = MTFetchBatchUpdateStateIdle;
        [weakSelf resetBatchUpdate];
        if (completion) {
            completion(finished);
        }
    }];
#endif
}

- (NSInteger)numberOfObjects {
    return self.fetchResult.numberOfObjects;
}

- (id)dataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchResult objectAtIndexPath:indexPath];
}

@end
