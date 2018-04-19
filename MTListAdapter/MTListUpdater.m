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

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, copy) MTListUpdatingCompletion updateCompletion;
@property (nonatomic, strong) MTFetchResultDataSource *fetchResult;
@property (nonatomic, assign) NSInteger section;

@end

@implementation MTListUpdater

#pragma mark - LifeCycle

- (instancetype)initWithEntityName:(NSString *)entityName
                  sortDescriptions:(NSArray<NSSortDescriptor *> *)sortDescriptions
                           section:(NSInteger)section
                    collectionView:(nonnull UICollectionView *)collectionView{
    NSManagedObjectContext *mainContext = [MTGlobalManagedObjectContext shareManager].managedObjectContext;
    return [self initWithManagedObjectContext:mainContext
                                   entityName:entityName
                             sortDescriptions:sortDescriptions
                                      section:section
                               collectionView:collectionView];
}

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context
                                  entityName:(NSString *)entityName
                            sortDescriptions:(NSArray<NSSortDescriptor *> *)sortDescriptions
                                     section:(NSInteger)section
                              collectionView:(nonnull UICollectionView *)collectionView{
    if (self = [super init]) {
        _section = section;
        _collectionView = collectionView;
        
        _fetchResult = [[MTFetchResultDataSource alloc] initWithManagedObjectContext:context
                                                                          entityName:entityName
                                                                    sortDescriptions:sortDescriptions
                                                                             section:section];
        
        __weak typeof(self) weakSelf = self;
        UICollectionView *collection = weakSelf.collectionView;
        _fetchResult.updaterBlock = ^(NSArray * _Nonnull updateArray, NSArray * _Nonnull insertArray, NSArray * _Nonnull deleteArray) {
            void (^executeUpdateBlock)(void) = ^{
                weakSelf.fetchResult.updateState = MTFetchBatchUpdateStateExectingBatchUpdateBlock;
                
                [collection deleteItemsAtIndexPaths:deleteArray];
                [collection reloadItemsAtIndexPaths:updateArray];
                [collection insertItemsAtIndexPaths:insertArray];
                
                weakSelf.fetchResult.updateState = MTFetchBatchUpdateStateExectedBatchUpdateBlock;
            };
            [collection performBatchUpdates:executeUpdateBlock completion:^(BOOL finished) {
                weakSelf.fetchResult.updateState = MTFetchBatchUpdateStateIdle;
                if (weakSelf.updateCompletion) {
                    weakSelf.updateCompletion(finished);
                }
            }];
        };
        
    }
    return self;
};

#pragma mark - MTListUpdatingDelegate

- (void)performUpdateWithCollectionView:(UICollectionView *)collection animated:(BOOL)animated completion:(MTListUpdatingCompletion)completion {
    if (completion) {
        self.updateCompletion = completion;
    }
}

- (NSUInteger)numberOfObjects {
    return self.fetchResult.numberOfObjects;
}

- (id)dataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchResult objectAtIndexPath:indexPath];
}

@end
