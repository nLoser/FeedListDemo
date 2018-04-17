//
//  MTListAdpter.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/16.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MTListAdpterDataSource.h"

@protocol MTListUpdatingDelegate;

NS_ASSUME_NONNULL_BEGIN

typedef void (^MTListUpdateCompletion)(BOOL finished);

@interface MTListAdpter : NSObject

@property (nonatomic, weak, nullable) UICollectionView *collectionView;

- (instancetype)initWithDataSource:(id<MTListAdpterDataSource>)dataSource;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (UICollectionViewCell *)dequeueResuseCellOfClass:(Class)cellClass
                              forSectionController:(MTListSectionController *)sectionController
                                             index:(NSInteger)index;

- (UICollectionViewCell *)dequeueResuseCellOfClassWithNibName:(NSString *)nibName
                                                       bundle:(NSBundle *)bundle
                              forSectionController:(MTListSectionController *)sectionController
                                             index:(NSInteger)index;

- (id)objectForSectionController:(MTListSectionController *)sectionController index:(NSInteger)index;

- (MTListSectionModel *)sectionObjectForSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
