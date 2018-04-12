//
//  FeedLiveViewCell.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/12.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "FeedLiveViewCell.h"
#import <YYKit/YYLabel.h>
#import <YYKit/UIImageView+YYWebImage.h>
#import <YYKit/CALayer+YYWebImage.h>

NSString *const kFeedLiveViewCellReuseIndentifier = @"kFeedLiveViewCell";

@interface FeedLiveViewCell()
@property (nonatomic, strong) CALayer *bgImageLayer;
@property (nonatomic, strong) YYLabel *topicLabel;
@property (nonatomic, strong) YYLabel *userNumLabel;
@property (nonatomic, strong) YYLabel *indexLabel;
@end

@implementation FeedLiveViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Custom Accessors

#pragma mark - Custom Accessors - Setter

- (void)setModel:(MTRecommendLiveModel *)model {
    if(!model) return;
    _model = model;
    
    [_bgImageLayer setImageURL:[NSURL URLWithString:model.cover_pic]];
    _topicLabel.text = model.caption;
    _userNumLabel.text = [NSString stringWithFormat:@"%d",model.plays_count];
}

- (void)setIndexString:(NSString *)indexString {
    _indexLabel.text = indexString;
}

#pragma mark - Custom Accessors - Getter

- (CALayer *)bgImageLayer {
    if (!_bgImageLayer) {
        _bgImageLayer = [CALayer layer];
        _bgImageLayer.frame = self.contentView.bounds;
        _bgImageLayer.rasterizationScale = [UIScreen mainScreen].scale;
        _bgImageLayer.shouldRasterize = YES;
        _bgImageLayer.opaque = YES;
    }
    return _bgImageLayer;
}

- (YYLabel *)topicLabel {
    if (!_topicLabel) {
        _topicLabel = [[YYLabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height - 50, self.frame.size.width * 0.7-10, 40)];
        _topicLabel.textVerticalAlignment = YYTextVerticalAlignmentBottom;
        _topicLabel.font = [UIFont fontWithName:@"CourierNewPSMT" size:14];
        _topicLabel.textColor = [UIColor lightGrayColor];
    }
    return _topicLabel;
}

- (YYLabel *)userNumLabel {
    if (!_userNumLabel) {
        _userNumLabel = [[YYLabel alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.5, self.frame.size.height - 50, self.frame.size.width * 0.5-10, 40)];
        _userNumLabel.textVerticalAlignment = YYTextVerticalAlignmentBottom;
        _userNumLabel.textAlignment = NSTextAlignmentRight;
        _userNumLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:18];
        _userNumLabel.textColor = [UIColor whiteColor];
    }
    return _userNumLabel;
}

- (YYLabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, 60, 100)];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.textColor = [UIColor blackColor];
        _indexLabel.shadowColor = [UIColor whiteColor];
        _indexLabel.shadowOffset = CGSizeMake(0, 0);
        _indexLabel.font = [UIFont systemFontOfSize:24];
        _indexLabel.shadowBlurRadius = 2;
        _indexLabel.center = CGPointMake(self.frame.size.width/2.f, self.frame.size.height/2.f);
    }
    return _indexLabel;
}

#pragma mark - Private - Setup

- (void)setup {
    [self.contentView.layer addSublayer:self.bgImageLayer];
    [self.contentView addSubview:self.userNumLabel];
    [self.contentView addSubview:self.topicLabel];
    [self.contentView addSubview:self.indexLabel];
}

@end
