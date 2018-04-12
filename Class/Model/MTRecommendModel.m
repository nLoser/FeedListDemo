//
//  MTRecommendModel.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/11.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "MTRecommendModel.h"

@implementation MTRecommendModel

@end

@implementation MTRecommendVideoStreamModel

@end

@implementation MTRecommendChatStreamModel

@end

@implementation MTRecommendPushInfoModel

@end

@implementation MTRecommendLiveModel

@end

@implementation MTRecommendItemModel

@end

@implementation MTRecommendProgramsModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"programs":[MTRecommendItemModel class]};
}
@end
