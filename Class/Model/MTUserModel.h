//
//  MTUserModel.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/11.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTUserModel : NSObject

@end

@interface MTUserInfoModel : MTUserModel
@property (nonatomic, assign) int64_t id;
@property (nonatomic, assign) int32_t funy_core_user_created_at;
@property (nonatomic, assign) int32_t last_publish_time;
@property (nonatomic, assign) int32_t level;
@property (nonatomic, assign) int32_t country;
@property (nonatomic, assign) int32_t province;
@property (nonatomic, assign) int32_t city;
@property (nonatomic, assign) int32_t age;
@property (nonatomic, assign) int32_t followers_count;
@property (nonatomic, assign) int32_t friends_count;
@property (nonatomic, assign) int32_t reposts_count;
@property (nonatomic, assign) int32_t videos_count;
@property (nonatomic, assign) int32_t real_videos_count;
@property (nonatomic, assign) int32_t photos_count;
@property (nonatomic, assign) int32_t locked_videos_count;
@property (nonatomic, assign) int32_t real_locked_videos_count;
@property (nonatomic, assign) int32_t locked_photos_count;
@property (nonatomic, assign) int32_t be_liked_count;
@property (nonatomic, assign) int32_t created_at;
@property (nonatomic, assign) BOOL is_funy_core_user;
@property (nonatomic, assign) BOOL has_password;
@property (nonatomic, assign) BOOL show_pendant;
@property (nonatomic, assign) BOOL level_hide_coins;
@property (nonatomic, assign) BOOL level_hide_beans;
@property (nonatomic, assign) BOOL has_assoc_phone;
@property (nonatomic, assign) BOOL verified;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *screen_name;
@property (nonatomic, copy) NSString *constellation;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *birthday;

@end
