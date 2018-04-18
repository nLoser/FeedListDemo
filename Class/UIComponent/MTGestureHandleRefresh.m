//
//  MTGestureHandleRefresh.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/17.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "MTGestureHandleRefresh.h"

@interface MTGestureHandleRefresh()<UIGestureRecognizerDelegate> {
    CGFloat _slideDistance;
    CGFloat _beganY;
    CGFloat _parallax;
    CGFloat _transitionY;
    BOOL _transitionFlag;
}
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) UILabel *refreshHintLabel;
@end

@implementation MTGestureHandleRefresh

- (instancetype)initWithViewController:(UIViewController *)viewController
                            scrollView:(UIScrollView *)scrollView {
    if (self = [super init]) {
        _scrollView = scrollView;
        _viewController = viewController;
        
        _slideDistance = 100.f;
        _beganY = 0.f;
        _transitionY = 0.f;
        _transitionFlag = NO;
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(refresh:)];
        panGestureRecognizer.delegate = self;
        [_viewController.view addGestureRecognizer:panGestureRecognizer];
    }
    return self;
}

#pragma mark - UIEvents

- (void)refresh:(UIPanGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:gesture.view.superview];
    CGPoint velocity = [gesture velocityInView:self.viewController.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _beganY = location.y;
        [self.viewController.view addSubview:self.refreshHintLabel];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        _transitionFlag = velocity.y <= 0?YES:NO;
        if (_transitionFlag) _transitionY = location.y;
        
        if (_transitionFlag && _transitionY - location.y  >= _slideDistance) {
            _parallax = 0;
        }else {
            _parallax = MAX(location.y - _beganY, 0);
        }
        
        self.refreshHintLabel.alpha = _parallax/_slideDistance;
        self.scrollView.contentOffset = CGPointZero;
        
        if (_parallax == 0) {
            gesture.enabled = NO;
            return;
        }
    } else if (gesture.state == UIGestureRecognizerStateEnded ||
              gesture.state == UIGestureRecognizerStateCancelled) {
        self.scrollView.scrollEnabled = YES;
        gesture.enabled = YES;
        
        [self.refreshHintLabel removeFromSuperview];
        
        if (gesture.state == UIGestureRecognizerStateEnded && _parallax >= _slideDistance) {
            self.refresh(YES);
        }
    }
}

#pragma mark - Custom Accessors

- (UILabel *)refreshHintLabel {
    if (!_refreshHintLabel) {
        _refreshHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 30)];
        _refreshHintLabel.textAlignment = NSTextAlignmentCenter;
        _refreshHintLabel.text = @"下拉刷新";
        _refreshHintLabel.textColor = [UIColor blackColor];
        _refreshHintLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _refreshHintLabel;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.scrollView.contentOffset.y > 0 && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint velocity = [((UIPanGestureRecognizer *)gestureRecognizer) velocityInView:self.viewController.view];
        if (velocity.y >= 0 && self.scrollView.contentOffset.y <= 0) {
            return YES;
        }
    }
    return YES;
}


@end
