//
//  MTFetchResultDataSource.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/19.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "MTFetchResultDataSource.h"

@interface MTFetchResultDataSource ()

@property (nonatomic, strong) NSMutableArray *deleteArray;
@property (nonatomic, strong) NSMutableArray *insertArray;
@property (nonatomic, strong) NSMutableArray *updateArray;

@property (nonatomic, assign) NSInteger section;

@end

@implementation MTFetchResultDataSource

#pragma mark - LifeCycle

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context
                                  entityName:(NSString *)entityName
                            sortDescriptions:(NSArray<NSSortDescriptor *> *)sortDescriptions
                                     section:(NSInteger)section {
    self = [super init];
    if (self) {
        _managedObjectContext = context;
        _entityName = entityName;
        _section = section;
        
        _updateArray = [NSMutableArray array];
        _insertArray = [NSMutableArray array];
        _deleteArray = [NSMutableArray array];
        
        _updateState = MTFetchBatchUpdateStateIdle;
        
        [self bindMangedObjectContextBySortDescs:sortDescriptions];
    }
    return self;
}

#pragma mark - Public

- (NSUInteger)numberOfEntityObjects {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    return [self.managedObjectContext countForFetchRequest:fetchRequest error:nil];
}

- (NSUInteger)numberOfObjects {
    return self.fetchController.sections.firstObject.numberOfObjects;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchController objectAtIndexPath:indexPath];
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

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    self.updateState = MTFetchBatchUpdateStateWillChangeContext;
    NSLog(@"【1】WillChangeContent");
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    self.updateState = MTFetchBatchUpdateStateDidChangeContext;
    //[self performUpdateWithCollectionView:_collectionView animated:YES completion:nil];
    NSLog(@"【3】DidChangeContent");
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath {
    NSLog(@"【2_object】%ld_%@_%ld",newIndexPath.row,logStataus(type),(long)_section);
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
            break;
        default:
            break;
    }
}

@end
