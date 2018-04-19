//
//  ViewController.m
//  RecommendListDemo
//
//  Created by meipai_lv on 2018/4/11.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "ViewController.h"

#import "MTGlobalManagedObjectContext.h"
#import "MTGestureHandleRefresh.h"
#import "MTListAdpter.h"

#import "BannerSectionController.h"
#import "RecommendSectionController.h"
#import "SpinnerSectionController.h"

@interface ViewController () <
    MTListAdpterDataSource,
    UICollectionViewDelegate,
    UIGestureRecognizerDelegate>
{
    BOOL _loading;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) MTListAdpter *adapter;
@property (nonatomic, strong) MTGestureHandleRefresh *refresh;

@end

@implementation ViewController

#pragma mark - LifeCycle

- (instancetype)init {
    if (self = [super init]) {
        _loading = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.adapter = [[MTListAdpter alloc] initWithDataSource:self];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _loading = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.adapter = [[MTListAdpter alloc] initWithDataSource:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    
    self.adapter.collectionView = self.collectionView;
    
    self.refresh = [[MTGestureHandleRefresh alloc] initWithViewController:self
                                                               scrollView:self.collectionView];
    __weak typeof(self) weakSelf = self;
    self.refresh.refresh = ^(BOOL refresh) {
        [weakSelf refreshData];
    };
    
    //NOTE:test
    [self refreshData];
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
        _collectionView.delegate = self;
    }
    return _collectionView;
}

#pragma mark - UIEvents

- (void)refreshData {
    [[MTGlobalManagedObjectContext shareManager] removeAllDataBase];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self testLoadData];
    });
}

- (void)testLoadData {
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"json" ofType:@"json"];
    NSString *jsonData = [NSString stringWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error:nil];
    MTRecommendProgramsModel *programs = [MTRecommendProgramsModel modelWithJSON:jsonData];
    
    [[MTGlobalManagedObjectContext shareManager] insertDataBasePrograms:programs.programs];
    [[MTGlobalManagedObjectContext shareManager] testDeleteDataBase];
    
    _loading = NO;
}

#pragma mark - MTListAdpterDataSource

- (NSArray<MTListSectionModel *> *)objectsForListAdpater:(MTListAdpter *)listAdapter {
    NSMutableArray<MTListSectionModel *> *objects = [NSMutableArray array];
    for (int i = 0; i < 2; i ++) {
        MTListSectionModel *model = [MTListSectionModel new];
        if (i == 0) {
            model.bindCoreData = NO;
            model.entityName = @"Banner";
            model.dataSources = @[@"占位1"];
        } else {
            model.bindCoreData = YES;
            model.entityName = @"Recommend";
            model.descriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
        }
        [objects addObject:model];
    }
    MTListSectionModel *model = [MTListSectionModel new];
    model.bindCoreData = NO;
    model.entityName = @"Spinner";
    model.dataSources = @[@"占位1"];
    [objects addObject:model];
    return objects;
}

- (MTListSectionController *)listAdapter:(MTListAdpter *)listAdapter sectionControllerForObject:(MTListSectionModel *)object {
    if ([object.entityName isEqualToString:@"Banner"]) {
        return [[BannerSectionController alloc] initWithAdpater:listAdapter];
    } else if ([object.entityName isEqualToString:@"Recommend"]) {
        return [[RecommendSectionController alloc] initWithAdpater:listAdapter];
    } else if ([object.entityName isEqualToString:@"Spinner"]){
        return [[SpinnerSectionController alloc] initWithAdpater:listAdapter];
    } else {
        return nil;
    }
}

#pragma mark - UICollectionDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.adapter sizeForSectionAtIndexPath:indexPath];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat distance = scrollView.contentSize.height - (targetContentOffset->y + scrollView.bounds.size.height);
    
    if (!_loading && distance < 200) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(2);
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_loading = YES;
                [self testLoadData];
            });
        });
    }
}

@end
