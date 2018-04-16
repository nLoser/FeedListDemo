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

#import "MTFetchMOCAdapterUpdater.h"
#import "MTListAdpter.h"

#import "MTRecommendModel.h"

#import "FeedLiveViewCell.h"

@interface ViewController ()<MTListAdpterDataSource>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext; ///< 此参数应该是代理
@property (nonatomic, strong) MTListAdpter *adapter;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupManagedObjectContextWithContextName:@"FeedModel" sqliteName:@"data.sqlite"];
    
    self.adapter = [[MTListAdpter alloc] initWithController:self];
    self.adapter.collectionView = self.collectionView;
}

#pragma mark - Custom Accessors

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 1;
        layout.minimumLineSpacing = 1;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 1, 0);
    
        _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[FeedLiveViewCell class] forCellWithReuseIdentifier:kFeedLiveViewCellReuseIndentifier];
    }
    return _collectionView;
}

#pragma mark - Private

- (void)testDelteData {
    NSFetchRequest *deleteRequest = [NSFetchRequest fetchRequestWithEntityName:@"Recommend"];
    int index = random()%20 + 1;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"index = %d",index];
    deleteRequest.predicate = pre;
    NSArray<Recommend *> *resultArray = [self.managedObjectContext executeFetchRequest:deleteRequest error:nil];
    if(resultArray.count == 0) return;
    NSLog(@"索引:%d 数量:%lu",index,(unsigned long)resultArray.count);
    
    __weak typeof(self) weakSelf = self;
    [resultArray enumerateObjectsUsingBlock:^(Recommend * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.managedObjectContext deleteObject:obj];
    }];
    if (self.managedObjectContext.hasChanges) {
        [self.managedObjectContext save:nil];
    }
}

- (void)insertDataBase:(NSArray<MTRecommendItemModel *> *)programs {
    NSInteger index = 1 + [self lookupEntitysNumber];
    for (MTRecommendItemModel *item in programs) {
        Recommend *recommend = [NSEntityDescription insertNewObjectForEntityForName:@"Recommend" inManagedObjectContext:self.managedObjectContext];
        recommend.recommend_caption = item.recommend_caption;
        recommend.recommend_cover_pic = item.recommend_cover_pic;
        recommend.recommend_cover_pic_size = item.recommend_cover_pic_size;
        recommend.type = item.type;
        recommend.live = [item.live modelToJSONString];
        recommend.index = (int32_t)index;
        index ++;
    }
    if (self.managedObjectContext.hasChanges) {
        [self.managedObjectContext save:nil];
    }
}

- (NSInteger)lookupEntitysNumber {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Recommend"];
    return [self.managedObjectContext countForFetchRequest:fetchRequest error:nil];
}

#pragma mark - Private - Setup

- (void)setupUI {
    [self.view addSubview:self.collectionView];
    [self.collectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(testLoadData)]];
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
        self.managedObjectContext = nil;
        return;
    }
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = coordinator;
    
    self.managedObjectContext = context;
}

#pragma mark - UIEvents

- (void)testLoadData {
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"json" ofType:@"json"];
    NSString *jsonData = [NSString stringWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error:nil];
    MTRecommendProgramsModel *programs = [MTRecommendProgramsModel modelWithJSON:jsonData];
    
    [self insertDataBase:programs.programs];
    [self testDelteData];
}

#pragma mark - MTListAdpterDataSource

- (NSArray<MTListSectionModel *> *)objectsForListAdpater:(MTListAdpter *)listAdapter {
    NSMutableArray<MTListSectionModel *> *objects = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 2; i ++) {
        MTListSectionModel *model = [MTListSectionModel new];
        if (i == 0) {
            model.bindCoreData = NO;
            model.dataSources = @[@"",@"",@"",@""];
        }else {
            model.bindCoreData = YES;
            model.entityName = @"Recommend";
            model.descriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
            model.managedObjectContext = self.managedObjectContext;
            [objects addObject:model];
        }
    }
    return objects;
}

#pragma mark - UICollectionViewDataSource
#if 0
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.updater.fetchController.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.updater.fetchController.sections[section].numberOfObjects;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FeedLiveViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFeedLiveViewCellReuseIndentifier forIndexPath:indexPath];
    Recommend *rec = [self.updater.fetchController objectAtIndexPath:indexPath];
    MTRecommendLiveModel *model = [MTRecommendLiveModel modelWithJSON:rec.live];
    cell.model = model;
    cell.indexString = [NSString stringWithFormat:@"%ld_%d",(long)indexPath.section,rec.index];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = [UIScreen mainScreen].bounds.size.width/2.f-0.5;
    return CGSizeMake(width, width * 1.2);
}
#endif

@end
