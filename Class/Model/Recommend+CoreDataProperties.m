//
//  Recommend+CoreDataProperties.m
//  
//
//  Created by meipai_lv on 2018/4/12.
//
//

#import "Recommend+CoreDataProperties.h"

@implementation Recommend (CoreDataProperties)

+ (NSFetchRequest<Recommend *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Recommend"];
}

@dynamic index;
@dynamic live;
@dynamic recommend_caption;
@dynamic recommend_cover_pic;
@dynamic recommend_cover_pic_size;
@dynamic type;

@end
