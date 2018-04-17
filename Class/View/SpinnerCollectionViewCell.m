//
//  SpinnerCollectionViewCell.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/17.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "SpinnerCollectionViewCell.h"

@interface SpinnerCollectionViewCell()
@property (nonatomic, strong) UIActivityIndicatorView *indictorView;
@end

@implementation SpinnerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _indictorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indictorView.frame = CGRectMake(0, 0, 40, 40);
        _indictorView.center = CGPointMake(self.bounds.size.width/2.f,
                                           self.bounds.size.height/2.f);
        [self.contentView addSubview:_indictorView];
    }
    return self;
}

- (void)startAnimating {
    [_indictorView startAnimating];
}

@end
