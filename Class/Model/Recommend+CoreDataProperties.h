//
//  Recommend+CoreDataProperties.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/11.
//  Copyright © 2018年 MT.inc. All rights reserved.
//
//

#import "Recommend+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Recommend (CoreDataProperties)

+ (NSFetchRequest<Recommend *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *recommend_caption;
@property (nullable, nonatomic, copy) NSString *recommend_cover_pic;
@property (nullable, nonatomic, copy) NSString *recommend_cover_pic_size;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSString *live;

@end

NS_ASSUME_NONNULL_END
