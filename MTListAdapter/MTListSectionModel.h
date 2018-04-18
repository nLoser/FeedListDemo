//
//  MTListSectionModel.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/16.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTListSectionModel : NSObject

@property (nonatomic, assign) BOOL bindCoreData;
@property (nonatomic, copy) NSString *entityName; 

@property (nonatomic, nullable, strong) NSArray *dataSources;

@property (nonatomic, nullable, strong) NSArray<NSSortDescriptor *> *descriptors;
@property (nonatomic, nullable, weak) NSManagedObjectContext *managedObjectContext;

@end

NS_ASSUME_NONNULL_END
