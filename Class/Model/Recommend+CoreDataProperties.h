//
//  Recommend+CoreDataProperties.h
//  
//
//  Created by meipai_lv on 2018/4/12.
//
//

#import "Recommend+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Recommend (CoreDataProperties)

+ (NSFetchRequest<Recommend *> *)fetchRequest;

@property (nonatomic) int32_t index;
@property (nullable, nonatomic, copy) NSString *live;
@property (nullable, nonatomic, copy) NSString *recommend_caption;
@property (nullable, nonatomic, copy) NSString *recommend_cover_pic;
@property (nullable, nonatomic, copy) NSString *recommend_cover_pic_size;
@property (nullable, nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
