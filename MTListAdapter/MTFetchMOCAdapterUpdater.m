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

@property (nonatomic, assign, readwrite) MTFetchBatchUpdateState updateState;

@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) MTListSectionController *sectionController;

@property (nonatomic, strong) NSFetchedResultsController *fetchController;

@property (nonatomic, strong) NSMutableArray *deleteArray;
@property (nonatomic, strong) NSMutableArray *insertArray;
@property (nonatomic, strong) NSMutableArray *updateArray;

@end

@implementation MTFetchMOCAdapterUpdater

#pragma mark - LifeCycle

- (instancetype)initWithEntityName:(NSString *)entityName
                  sortDescriptions:(NSArray<NSSortDescriptor *> *)sortDescriptions
                 sectionController:(MTListSectionController *)sectionController
                           section:(NSInteger)section{
    //Global MOC
    NSManagedObjectContext *mainContext = nil;
    return [self initWithManagedObjectContext:mainContext
                                   entityName:entityName
                             sortDescriptions:sortDescriptions
                            sectionController:sectionController
                                      section:section];
}

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context
                                  entityName:(NSString *)entityName
                            sortDescriptions:(NSArray<NSSortDescriptor *> *)sortDescriptions
                           sectionController:(MTListSectionController *)sectionController
                                     section:(NSInteger)section{
    if (self = [super init]) {
        _updateState = MTFetchBatchUpdateStateIdle;
        
        _updateArray = [NSMutableArray array];
        _insertArray = [NSMutableArray array];
        _deleteArray = [NSMutableArray array];
        
        _managedObjectContext = context;
        
        _entityName = entityName;
        _sectionController = sectionController;
        _section = section;
        
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

#pragma mark - MTListUpdatingDelegate

- (void)performUpdateWithCollectionView:(UICollectionView *)collection animated:(BOOL)animated completion:(MTListUpdatingCompletion)completion {
    if(collection == nil) return;
    if (_collectionView != collection) {
        _collectionView = collection;
    }
    
    if(self.updateState != MTFetchBatchUpdateStateWillChangeContext) return;
    
    __weak typeof(self) weakSelf = self;
    void (^executeUpdateBlock)(void) = ^{
        weakSelf.updateState = MTFetchBatchUpdateStateExectingBatchUpdateBlock;
        
        [collection reloadItemsAtIndexPaths:weakSelf.updateArray];
        [collection deleteItemsAtIndexPaths:weakSelf.deleteArray];
        [collection insertItemsAtIndexPaths:weakSelf.insertArray];
        
        weakSelf.updateState = MTFetchBatchUpdateStateExectedBatchUpdateBlock;
    };
    
    [collection performBatchUpdates:executeUpdateBlock completion:^(BOOL finished) {
        weakSelf.updateState = MTFetchBatchUpdateStateIdle;
        [weakSelf resetBatchUpdate];
        if (completion) {
            completion(finished);
        }
    }];
    
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    self.updateState = MTFetchBatchUpdateStateWillChangeContext;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if(!_collectionView) return;
    [self performUpdateWithCollectionView:_collectionView animated:YES completion:nil];
    self.updateState = MTFetchBatchUpdateStateDidChangeContext;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath {
    NSLog(@"【2_object】%ld_%@",newIndexPath.row,logStataus(type));
    
    switch (type) {
        case NSFetchedResultsChangeDelete: {
            if(!indexPath) return;
            [self.deleteArray addObject:[NSIndexPath indexPathForRow:indexPath.row inSection:_section]];
        }
            break;
        case NSFetchedResultsChangeInsert: {
            if(!newIndexPath) return;
            [self.insertArray addObject:[NSIndexPath indexPathForRow:newIndexPath.row inSection:_section]];
        }
            break;
        case NSFetchedResultsChangeUpdate: {
            if(!indexPath) return;
            [self.updateArray addObject:[NSIndexPath indexPathForRow:indexPath.row inSection:_section]];
        }
            break;
            
        default:
            break;
    }
}

@end
