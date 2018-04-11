//
//  Recommend+CoreDataProperties.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/11.
//  Copyright © 2018年 MT.inc. All rights reserved.
//
//

#import "Recommend+CoreDataProperties.h"

@implementation Recommend (CoreDataProperties)

+ (NSFetchRequest<Recommend *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Recommend"];
}

@dynamic recommend_caption;
@dynamic recommend_cover_pic;
@dynamic recommend_cover_pic_size;
@dynamic type;
@dynamic live;

@end
