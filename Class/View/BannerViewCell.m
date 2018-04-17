//
//  BannerViewCell.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/17.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "BannerViewCell.h"

#import "LVInfinitelyCycleView.h"

@interface BannerViewCell ()
@property (nonatomic, strong) LVInfinitelyCycleView *cycleBannerView;
@end

@implementation BannerViewCell

#pragma mark - Custom Accessors

- (void)setDataSources:(NSArray<NSString *> *)dataSources {
    if(_cycleBannerView) return;
    
    _cycleBannerView = [[LVInfinitelyCycleView alloc] initWithFrame:self.contentView.bounds];
    [self addSubview:_cycleBannerView];
    NSArray * tempArray = @[@"https://mvimg1.meitudata.com/5ad373dea78a3924.png",
                            @"https://mvimg1.meitudata.com/5ad4c85c7432d9192.jpg",
                            @"https://mvimg1.meitudata.com/5ad58d2cf39502856.jpg",
                            @"https://mvimg1.meitudata.com/5acef9f37a0695037.jpg"];
    [_cycleBannerView setBannerIamgeUrlGroup:tempArray];
}

@end
