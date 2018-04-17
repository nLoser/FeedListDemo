//
//  MTListSectionModel.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/16.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "MTListSectionModel.h"
#import "MTGlobalManagedObjectContext.h"

@implementation MTListSectionModel

- (NSArray *)dataSources {
    if (!_dataSources) {
        _dataSources = @[];
    }
    return _dataSources;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        //设定全局的context，如果默认nil的时候
        _managedObjectContext = [MTGlobalManagedObjectContext shareManager].managedObjectContext;
    }
    return _managedObjectContext;
}

@end
