//
//  ViewController.m
//  RecommendListDemo
//
//  Created by meipai_lv on 2018/4/11.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import <YYKit/NSObject+YYModel.h>

#import "MTRecommendModel.h"

#import "FeedLiveViewCell.h"

@interface ViewController ()<NSFetchedResultsControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSManagedObjectContext *moContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<MTRecommendItemModel *> *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) int pageIndex; // pagesize = 5
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray array];
    _pageIndex = 0;

    [self.view addSubview:self.collectionView];

    [self createCoreDataContext];
    [self createFRCBindMOC];
    
    [self.collectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(testLoadData)]];
}

#pragma mark - Custom Accessors

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[FeedLiveViewCell class] forCellWithReuseIdentifier:kFeedLiveViewCellReuseIndentifier];
    }
    return _collectionView;
}

#pragma mark - Private

- (void)createFRCBindMOC {
    if(!_moContext) return;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recommend"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
    _fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_moContext sectionNameKeyPath:@"index" cacheName:nil];
    _fetchedResultController.delegate = self;
    NSError *error = nil;
    [_fetchedResultController performFetch:&error];
    if (error) {
        NSLog(@"##Bind OMContext failed : %@",error);
        return;
    }
}

- (void)createCoreDataContext {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FeedModel" withExtension:@"momd"];
    if(!modelURL) return;
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSString *dbPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"data.sqlite"];
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

#pragma mark - UIEvents

- (void)testLoadData {
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"json" ofType:@"json"];
    NSString *jsonData = [NSString stringWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error:nil];
    MTRecommendProgramsModel *programs = [MTRecommendProgramsModel modelWithJSON:jsonData];
    
    [self insertDataBase:programs.programs];
    [_dataArray addObjectsFromArray:programs.programs];
    
    _pageIndex ++;
}

- (void)insertDataBase:(NSArray<MTRecommendItemModel *> *)programs {
    if(!_moContext) return;
    int index = 1 + _pageIndex * 5;
    for (MTRecommendItemModel *item in programs) {
        Recommend *recommend = [NSEntityDescription insertNewObjectForEntityForName:@"Recommend" inManagedObjectContext:_moContext];
        recommend.recommend_caption = item.recommend_caption;
        recommend.recommend_cover_pic = item.recommend_cover_pic;
        recommend.recommend_cover_pic_size = item.recommend_cover_pic_size;
        recommend.type = item.type;
        recommend.live = [item.live modelToJSONString];
        recommend.index = index;
        index ++;
    }
    
    NSError *error = nil;
    [_moContext save:&error];
    if (error) {
        NSLog(@"##Insert data failed : %@",error);
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _fetchedResultController.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _fetchedResultController.sections[section].numberOfObjects;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FeedLiveViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFeedLiveViewCellReuseIndentifier forIndexPath:indexPath];
    Recommend *rec = [_fetchedResultController objectAtIndexPath:indexPath];
    MTRecommendLiveModel *model = [MTRecommendLiveModel modelWithJSON:rec.live];
    cell.model = model;
    cell.indexString = [NSString stringWithFormat:@"%ld_%ld",(long)indexPath.section,(long)indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width/2.f, [UIScreen mainScreen].bounds.size.width/2.f * 1.2);
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath {
    NSLog(@"【3.2-object】didChangeObject\n%@\n%@\n%@\n%lu\n",anObject, newIndexPath,indexPath,(unsigned long)type);
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    NSLog(@"【3.1-section】\n-------------------\n%@\n%@\n%@\n-------------------",sectionInfo.name,sectionInfo.indexTitle,sectionInfo.objects);
}

- (nullable NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName {
    NSLog(@"【1】sectionIndexTitleForSectionName : %@",sectionName);
    //TODO:初始化加载数据，然后开始刷新
    return sectionName;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"【2】controllerWillChangeContent");
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"【4】controllerDidChangeContent");
    //[self.collectionView reloadData];
}

@end
