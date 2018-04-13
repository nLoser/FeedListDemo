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
@property (nonatomic, strong, readwrite) NSManagedObjectContext *moContext;
@property (nonatomic, strong, readwrite) NSFetchedResultsController *fetchController;
@property (nonatomic, strong, readwrite) NSString *entityName;
@property (nonatomic, assign, readwrite) NSUInteger pageSize;
@property (nonatomic, assign, readwrite) MTFetchBatchUpdateState updateState;

@property (nonatomic, strong) NSMutableArray *deleteSet;
@property (nonatomic, strong) NSMutableArray *insertSet;
@property (nonatomic, strong) NSMutableArray *updateSet;
@end

@implementation MTFetchMOCAdapterUpdater

#pragma mark - LifeCycle

- (instancetype)initWithFetchWithContext:(NSString*)contextName
                                  entity:(NSString *)entityName
                               sortDescs:(NSArray *)sortDescs {
    return [self initWithContext:contextName
                          entity:entityName
                       sortDescs:sortDescs
                        pageSize:20
                          sqlite:@"data.sqlite"];
}

- (instancetype)initWithContext:(NSString *)contextName
                         entity:(NSString *)entityName
                      sortDescs:(NSArray *)sortDescs
                       pageSize:(NSUInteger)pageSize
                         sqlite:(NSString *)sqliteName {
    if (self = [super init]) {
        _entityName = entityName;
        _pageSize = pageSize;
        
        _updateState = MTFetchBatchUpdateState_Idle;
        
        _updateSet = [NSMutableArray array];
        _insertSet = [NSMutableArray array];
        _deleteSet = [NSMutableArray array];
        
        [self setupManagedObjectContextWithContextName:contextName sqliteName:sqliteName];
        [self bindMangedObjectContextBySortDescs:sortDescs];
    }
    return self;
}

#pragma mark - Custom Accessors

- (void)setCollectionView:(UICollectionView *)collectionView {
    if (_collectionView != collectionView ) {
        _collectionView = collectionView;
    }
}

#pragma mark - Private

- (void)bindMangedObjectContextBySortDescs:(NSArray *)sortDescs {
    if(!_moContext || !sortDescs || sortDescs.count == 0) return;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recommend"];
    request.sortDescriptors = sortDescs;
    _fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                   managedObjectContext:_moContext
                                                                     sectionNameKeyPath:nil
                                                                              cacheName:nil];
    
    _fetchController.delegate = self;
    NSError *error = nil;
    [_fetchController performFetch:&error];
    if (error) {
        NSLog(@"##Bind OMContext failed : %@",error);
        return;
    }
}

- (void)setupManagedObjectContextWithContextName:(NSString *)contextName sqliteName:(NSString *)sqliteName{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:contextName withExtension:@"momd"];
    if(!modelURL) return;
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSString *dbPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:sqliteName];
    NSURL *dbURL = [NSURL fileURLWithPath:dbPath];
    
    NSError *error = nil;
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:dbURL options:nil error:&error];
    if (error) {
        NSLog(@"##Open database failed : %@", error);
        return;
    }
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = coordinator;
    _moContext = context;
}

- (NSInteger)lookupEntitysNumber {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:_entityName];
    return [_moContext countForFetchRequest:fetchRequest error:nil];
}

- (void)performBatchUpdatesWithCollectionView:(UICollectionView *)collectionView {
    if(!collectionView) return;
    __weak typeof(self) weakSelf = self;
    void (^executeUpdateBlock)(void) = ^{
        weakSelf.updateState = MTFetchBatchUpdateState_ExectingBatchUpdateBlock;
        
        [collectionView reloadItemsAtIndexPaths:weakSelf.updateSet];
        [collectionView deleteItemsAtIndexPaths:weakSelf.deleteSet];
        [collectionView insertItemsAtIndexPaths:weakSelf.insertSet];
        
        weakSelf.updateState = MTFetchBatchUpdateState_ExectingBatchUpdateBlock;
    };
    
    [collectionView performBatchUpdates:executeUpdateBlock completion:^(BOOL finished) {
        weakSelf.updateState = MTFetchBatchUpdateState_Idle;
    }];
}

- (void)resetBatchUpdate {
    [_updateSet removeAllObjects];
    [_deleteSet removeAllObjects];
    [_insertSet removeAllObjects];
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
    _updateState = MTFetchBatchUpdateState_WillChangeContext;
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"【3】controllerDidChangeContent");
    _updateState = MTFetchBatchUpdateState_DidChangeContext;
    [self performBatchUpdatesWithCollectionView:_collectionView];
    [self resetBatchUpdate];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath {
    NSLog(@"【2_object】%ld_%@",newIndexPath.row,logStataus(type));
    
    switch (type) {
        case NSFetchedResultsChangeDelete: {
            [_deleteSet addObject:newIndexPath];
        }
            break;
        case NSFetchedResultsChangeInsert: {
            [_insertSet addObject:newIndexPath];
        }
            break;
        case NSFetchedResultsChangeUpdate: {
            [_updateSet addObject:newIndexPath];
        }
            break;
            
        default:
            break;
    }
}

@end
