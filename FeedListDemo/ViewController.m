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

#import "MTRecommendModel.h"

#import "FeedLiveViewCell.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) MTFetchMOCAdapterUpdater *updater;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) int pageIndex; // pagesize = 5
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pageIndex = 0;
    
    [self.view addSubview:self.collectionView];

    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    _updater = [[MTFetchMOCAdapterUpdater alloc] initWithFetchWithContext:@"FeedModel"
                                                                   entity:@"Recommend"
                                                                sortDescs:@[descriptor]];
    _updater.collectionView = self.collectionView;
    
    [self.collectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(testLoadData)]];
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
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[FeedLiveViewCell class] forCellWithReuseIdentifier:kFeedLiveViewCellReuseIndentifier];
    }
    return _collectionView;
}

#pragma mark - Private

#pragma mark - UIEvents

- (void)testLoadData {
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"json" ofType:@"json"];
    NSString *jsonData = [NSString stringWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error:nil];
    MTRecommendProgramsModel *programs = [MTRecommendProgramsModel modelWithJSON:jsonData];
    
    [self insertDataBase:programs.programs];
    
    _pageIndex ++;
}

- (void)insertDataBase:(NSArray<MTRecommendItemModel *> *)programs {
    if(!_updater) return;
    int index = 1 + _pageIndex * 5;
    for (MTRecommendItemModel *item in programs) {
        Recommend *recommend = [NSEntityDescription insertNewObjectForEntityForName:@"Recommend" inManagedObjectContext:_updater.moContext];
        recommend.recommend_caption = item.recommend_caption;
        recommend.recommend_cover_pic = item.recommend_cover_pic;
        recommend.recommend_cover_pic_size = item.recommend_cover_pic_size;
        recommend.type = item.type;
        recommend.live = [item.live modelToJSONString];
        recommend.index = index;
        index ++;
    }
    
    NSError *error = nil;
    [_updater.moContext save:&error];
    if (error) {
        NSLog(@"##Insert data failed : %@",error);
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _updater.fetchController.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _updater.fetchController.sections[section].numberOfObjects;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FeedLiveViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFeedLiveViewCellReuseIndentifier forIndexPath:indexPath];
    Recommend *rec = [_updater.fetchController objectAtIndexPath:indexPath];
    MTRecommendLiveModel *model = [MTRecommendLiveModel modelWithJSON:rec.live];
    cell.model = model;
    cell.indexString = [NSString stringWithFormat:@"%ld_%d",(long)indexPath.section,rec.index];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = [UIScreen mainScreen].bounds.size.width/2.f-0.5;
    return CGSizeMake(width, width * 1.2);
}

@end
