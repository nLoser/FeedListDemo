//
//  MTFetchResultController.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/12.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "MTFetchMOCAdapterUpdater.h"
#import <UIKit/UIKit.h>

@interface MTFetchMOCAdapterUpdater()<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readwrite) NSFetchedResultsController *fetchController;

@property (nonatomic, weak, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong, readwrite) NSString *entityName;
@property (nonatomic, assign, readwrite) MTFetchBatchUpdateState updateState;

@property (nonatomic, strong) NSMutableArray *deleteArray;
@property (nonatomic, strong) NSMutableArray *insertArray;
@property (nonatomic, strong) NSMutableArray *updateArray;

@end

@implementation MTFetchMOCAdapterUpdater

#pragma mark - LifeCycle

- (instancetype)initWithEntityName:(NSString *)entityName
                  sortDescriptions:(NSArray<NSSortDescriptor *> *)sortDescriptions
                    collectionView:(UICollectionView *)collectionView {
    ///< 全局设定Context
    NSManagedObjectContext *mainContext = nil;
    return [self initWithManagedObjectContext:mainContext
                                   entityName:entityName
                             sortDescriptions:sortDescriptions
                               collectionView:collectionView];
}

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context
                                  entityName:(NSString *)entityName
                            sortDescriptions:(NSArray<NSSortDescriptor *> *)sortDescriptions
                              collectionView:(UICollectionView *)collectionView {
    if (self = [super init]) {
        
        _entityName = entityName;
        _updateState = MTFetchBatchUpdateStateIdle;
        
        _updateArray = [NSMutableArray array];
        _insertArray = [NSMutableArray array];
        _deleteArray = [NSMutableArray array];
        
        _collectionView = collectionView;
        _managedObjectContext = context;
        
        [self bindMangedObjectContextBySortDescs:sortDescriptions];
    }
    return self;
};

#pragma mark - Custom Accessors

- (NSInteger)entitysNumber {
    return [self lookupEntitysNumber];
}

#pragma mark - Private

- (void)bindMangedObjectContextBySortDescs:(NSArray *)sortDescs {
    if(!self.managedObjectContext || !sortDescs || sortDescs.count == 0) return;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    request.sortDescriptors = sortDescs;
    self.fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                   managedObjectContext:self.managedObjectContext
                                                                     sectionNameKeyPath:nil
                                                                              cacheName:nil];
    
    self.fetchController.delegate = self;
    NSError *error = nil;
    [self.fetchController performFetch:&error];
    if (error) {
        NSLog(@"##Bind OMContext failed : %@",error);
        return;
    }
}

- (NSInteger)lookupEntitysNumber {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    return [self.managedObjectContext countForFetchRequest:fetchRequest error:nil];
}

- (void)performBatchUpdatesWithCollectionView:(UICollectionView *)collectionView {
    if(!collectionView) return;
    __weak typeof(self) weakSelf = self;
    void (^executeUpdateBlock)(void) = ^{
        weakSelf.updateState = MTFetchBatchUpdateStateExectingBatchUpdateBlock;
        
        [collectionView reloadItemsAtIndexPaths:weakSelf.updateArray];
        [collectionView deleteItemsAtIndexPaths:weakSelf.deleteArray];
        [collectionView insertItemsAtIndexPaths:weakSelf.insertArray];
        
        weakSelf.updateState = MTFetchBatchUpdateStateExectedBatchUpdateBlock;
    };
    
    [collectionView performBatchUpdates:executeUpdateBlock completion:^(BOOL finished) {
        weakSelf.updateState = MTFetchBatchUpdateStateIdle;
    }];
}

- (void)resetBatchUpdate {
    [self.updateArray removeAllObjects];
    [self.deleteArray removeAllObjects];
    [self.insertArray removeAllObjects];
}

#pragma mark - Private - inline

static NSString * logStataus(NSFetchedResultsChangeType type) {
    switch (type) {
        case 1:
            return @"ChangeInsert";
            break;
        case 2:
            return @"ChangeDelete";
            break;
        case 3:
            return @"ChangeMove";
            break;
        case 4:
            return @"ChangeUpdate";
            break;
        default:
            break;
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"【1】controllerWillChangeContent");
    self.updateState = MTFetchBatchUpdateStateWillChangeContext;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"【3】controllerDidChangeContent");
    self.updateState = MTFetchBatchUpdateStateDidChangeContext;
    [self performBatchUpdatesWithCollectionView:self.collectionView];
    [self resetBatchUpdate];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath {
    NSLog(@"【2_object】%ld_%@",newIndexPath.row,logStataus(type));
    
    switch (type) {
        case NSFetchedResultsChangeDelete: {
            if(!indexPath) return;
            [self.deleteArray addObject:indexPath];
        }
            break;
        case NSFetchedResultsChangeInsert: {
            if(!newIndexPath) return;
            [self.insertArray addObject:newIndexPath];
        }
            break;
        case NSFetchedResultsChangeUpdate: {
            if(!indexPath) return;
            [self.updateArray addObject:indexPath];
        }
            break;
            
        default:
            break;
    }
}

@end
