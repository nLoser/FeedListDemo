//
//  FeedLiveViewCell.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/12.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTRecommendModel.h"

FOUNDATION_EXPORT NSString *const kFeedLiveViewCellReuseIndentifier;

@interface FeedLiveViewCell : UICollectionViewCell

@property (nonatomic, strong) MTRecommendLiveModel *model;

@property (nonatomic, strong) NSString * indexString;

@end
