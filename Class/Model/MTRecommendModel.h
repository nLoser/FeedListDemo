//
//  MTRecommendModel.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/11.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTUserModel.h"
#import "Recommend+CoreDataProperties.h"

@interface MTRecommendModel : NSObject

@end

@interface MTRecommendVideoStreamModel : MTRecommendModel
@property (nonatomic, copy) NSString *stream_id;
@property (nonatomic, copy) NSString *rtmp_live_url;
@property (nonatomic, copy) NSString *http_flv_url;
@property (nonatomic, copy) NSString *hls_url;
@property (nonatomic, copy) NSString *hls_playback_url;
@property (nonatomic, nullable, copy) NSString *http_playback_url;
@end

@interface MTRecommendChatStreamModel : MTRecommendModel
@property (nonatomic, copy) NSString *url;
@property (nonatomic, nullable, copy) NSString *playback_url;
@end

@interface MTRecommendPushInfoModel : MTRecommendModel
@property (nonatomic, assign) int64_t client_id;
@property (nonatomic, assign) int32_t upstream_sdk;
@end

@interface MTRecommendLiveModel : MTRecommendModel
@property (nonatomic, assign) int64_t id;
@property (nonatomic, assign) int32_t created_at;
@property (nonatomic, assign) int32_t comments_count;
@property (nonatomic, assign) int32_t likes_count;
@property (nonatomic, assign) int32_t plays_count;
@property (nonatomic, assign) int32_t popularity;
@property (nonatomic, assign) int32_t time;
@property (nonatomic, assign) int32_t time_limit;
@property (nonatomic, assign) BOOL is_live;
@property (nonatomic, assign) BOOL is_replay;
@property (nonatomic, assign) BOOL is_shared;
@property (nonatomic, assign) BOOL hide_time;
@property (nonatomic, assign) BOOL refuse_world_gift_banner;
@property (nonatomic, copy) NSString *share_caption;
@property (nonatomic, copy) NSString *facebook_share_caption;
@property (nonatomic, copy) NSString *weixin_share_caption;
@property (nonatomic, copy) NSString *weixin_share_sub_caption;
@property (nonatomic, copy) NSString *weixin_friendfeed_share_caption;
@property (nonatomic, copy) NSString *weixin_friendfeed_share_sub_caption;
@property (nonatomic, copy) NSString *qzone_share_caption;
@property (nonatomic, copy) NSString *qzone_share_sub_caption;
@property (nonatomic, copy) NSString *qq_share_caption;
@property (nonatomic, copy) NSString *qq_share_sub_caption;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *caption;
@property (nonatomic, copy) NSString *cover_pic;
@property (nonatomic, copy) NSString *pic_size;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, strong) MTUserInfoModel *user;
@property (nonatomic, strong) MTRecommendVideoStreamModel *video_stream;
@property (nonatomic, strong) MTRecommendChatStreamModel *chat_stream;
@property (nonatomic, strong) MTRecommendPushInfoModel *push_info;
@end

@interface MTRecommendItemModel : MTRecommendModel
@property (nonatomic, copy) NSString *recommend_caption;
@property (nonatomic, copy) NSString *recommend_cover_pic;
@property (nonatomic, copy) NSString *recommend_cover_pic_size;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) MTRecommendLiveModel *live;
@end

@interface MTRecommendProgramsModel : MTRecommendModel
@property (nonatomic, copy) NSArray<MTRecommendItemModel *> *programs;
@end
