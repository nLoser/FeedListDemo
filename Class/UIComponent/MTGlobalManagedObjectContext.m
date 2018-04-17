//
//  MTGlobalManagedObjectContext.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/17.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "MTGlobalManagedObjectContext.h"

@interface MTGlobalManagedObjectContext()

@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;

@end

@implementation MTGlobalManagedObjectContext

+ (instancetype)shareManager {
    static MTGlobalManagedObjectContext *globalContext = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalContext = [[MTGlobalManagedObjectContext alloc] init];
    });
    return globalContext;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupManagedObjectContextWithContextName:@"FeedModel" sqliteName:@"data.sqlite"];
    }
    return self;
}

#pragma mark - Public

- (void)insertDataBasePrograms:(NSArray<MTRecommendItemModel *> *)programs {
    NSInteger index = 1 + [self lookupEntitysNumber];
    for (MTRecommendItemModel *item in programs) {
        Recommend *recommend = [NSEntityDescription insertNewObjectForEntityForName:@"Recommend" inManagedObjectContext:self.managedObjectContext];
        recommend.recommend_caption = item.recommend_caption;
        recommend.recommend_cover_pic = item.recommend_cover_pic;
        recommend.recommend_cover_pic_size = item.recommend_cover_pic_size;
        recommend.type = item.type;
        recommend.live = [item.live modelToJSONString];
        recommend.index = (int32_t)index;
        index ++;
    }
    if (self.managedObjectContext.hasChanges) {
        [self.managedObjectContext save:nil];
    }
}

- (void)removeAllDataBase {
    NSFetchRequest *reqauest = [[NSFetchRequest alloc] initWithEntityName:@"Recommend"];
//    if (@available(iOS 9.0, *)) {
//        NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:reqauest];
//        [self.managedObjectContext.persistentStoreCoordinator executeRequest:deleteRequest withContext:self.managedObjectContext error:nil];
//        [self.managedObjectContext save:nil];
//    } else {
//        // Fallback on earlier versions
//    }
//
    NSArray *result = [[self.managedObjectContext executeFetchRequest:reqauest error:nil] copy];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.managedObjectContext deleteObject:obj];
    }];
    if ([self.managedObjectContext hasChanges]) {
        [self.managedObjectContext save:nil];
    }
}

- (void)testDeleteDataBase {
    NSFetchRequest *deleteRequest = [NSFetchRequest fetchRequestWithEntityName:@"Recommend"];
    int index = random()%20 + 1;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"index = %d",index];
    deleteRequest.predicate = pre;
    NSArray<Recommend *> *resultArray = [[self.managedObjectContext executeFetchRequest:deleteRequest error:nil] copy];
    if(resultArray.count == 0) return;
    
    [resultArray enumerateObjectsUsingBlock:^(Recommend * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.managedObjectContext deleteObject:obj];
    }];
    if (self.managedObjectContext.hasChanges) {
        [self.managedObjectContext save:nil];
    }
    
    NSLog(@"索引:%d 数量:%lu",index,(unsigned long)resultArray.count);
}

#pragma mark - Private

- (NSInteger)lookupEntitysNumber {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Recommend"];
    return [self.managedObjectContext countForFetchRequest:fetchRequest error:nil];
}

#pragma mark - Private - Setup

- (void)setupManagedObjectContextWithContextName:(NSString *)contextName sqliteName:(NSString *)sqliteName{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:contextName withExtension:@"momd"];
    if(!modelURL) return;
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSString *dbPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:sqliteName];
    NSURL *dbURL = [NSURL fileURLWithPath:dbPath];
    
    NSError *error = nil;
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:dbURL options:nil error:&error];
    if (error) {
        NSLog(@"##Open database failed : %@", error);
        self.managedObjectContext = nil;
        return;
    }
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = coordinator;
    
    self.managedObjectContext = context;
}

@end
