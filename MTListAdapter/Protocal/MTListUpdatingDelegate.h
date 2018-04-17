//
//  MTListUpdatingDelegate.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/16.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^MTListUpdatingCompletion) (BOOL finished);

@protocol MTListUpdatingDelegate <NSObject>

- (void)performUpdateWithCollectionView:(UICollectionView *)collection
                               animated:(BOOL)animated
                             completion:(nullable MTListUpdatingCompletion)completion;

- (NSInteger)numberOfObjects;

- (id)dataForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END