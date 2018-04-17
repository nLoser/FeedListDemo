//
//  MTGlobalManagedObjectContext.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/17.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <YYKit/NSObject+YYModel.h>

#import "MTRecommendModel.h"

@interface MTGlobalManagedObjectContext : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

- (void)insertDataBasePrograms:(NSArray<MTRecommendItemModel *> *)programs;

- (void)testDeleteDataBase;

+ (instancetype)shareManager;

@end
