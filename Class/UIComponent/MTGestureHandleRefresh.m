//
//  MTGestureHandleRefresh.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/17.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import "MTGestureHandleRefresh.h"

@class MTGestureHandleRefreshProxy;

@interface MTGestureHandleRefresh()<UIGestureRecognizerDelegate, UIScrollViewDelegate> {
    CGFloat _slideDistance;
    CGFloat _beganY;
    CGFloat _parallax;
    CGFloat _transitionY;
    BOOL _transitionFlag;

    BOOL _canRespondsScrollViewDidScroll;
    BOOL _canScroll;
}
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) UILabel *refreshHintLabel;
@property (nonatomic, strong) MTGestureHandleRefreshProxy *proxy;

@end

@implementation MTGestureHandleRefresh

#pragma mark - LifeCycle

- (instancetype)initWithViewController:(UIViewController *)viewController
                            scrollView:(UIScrollView *)scrollView {
    if (self = [super init]) {
        _scrollView = scrollView;
        _viewController = viewController;
        
        _slideDistance = 100.f;
        _beganY = 0.f;
        _transitionY = 0.f;
        _transitionFlag = NO;
        _canScroll = YES;
        
        _proxy = [[MTGestureHandleRefreshProxy alloc] initWithScrollViewTarget:viewController
                                                                   interceptor:self];
        _scrollView.delegate = (id<UIScrollViewDelegate>)_proxy ? (id<UIScrollViewDelegate>)_proxy : (id<UIScrollViewDelegate>)viewController;
        
        if ([_viewController respondsToSelector:@selector(scrollViewDidScroll:)]) {
            _canRespondsScrollViewDidScroll = YES;
        }

        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panScroViewRefresh:)];
        panGestureRecognizer.delegate = self;
        [_viewController.view addGestureRecognizer:panGestureRecognizer];
    }
    return self;
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

#pragma mark -

- (void)panScroViewRefresh:(UIPanGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:gesture.view.superview];
    CGPoint velocity = [gesture velocityInView:self.viewController.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _canScroll = NO;
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
        
        if (_parallax == 0) {
            _canScroll = YES;
            _beganY = location.y;
            return;
        }
    } else if (gesture.state == UIGestureRecognizerStateEnded ||
               gesture.state == UIGestureRecognizerStateCancelled) {
        
        _canScroll = YES;
        [self.refreshHintLabel removeFromSuperview];
        
        if (gesture.state == UIGestureRecognizerStateEnded && _parallax >= _slideDistance) {
            self.refresh(YES);
        }
    }
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


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 0 || !_canScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (_canRespondsScrollViewDidScroll) {
        [(id<UIScrollViewDelegate>)_viewController scrollViewDidScroll:scrollView];
    }
}

@end

@interface MTGestureHandleRefreshProxy() {
    __weak id _scrollViewTarget;
    __weak MTGestureHandleRefresh *_interceptor;
}

@end

static BOOL isInterceptedSelector(SEL sel) {
    return(
           // UIScrollViewDelegate
           sel == @selector(scrollViewDidScroll:)
           );
}

@implementation MTGestureHandleRefreshProxy

- (instancetype)initWithScrollViewTarget:(nullable id)scrollViewTarget
                             interceptor:(MTGestureHandleRefresh *)interceptor{
    if (self) {
        _scrollViewTarget = scrollViewTarget;
        _interceptor = interceptor;
    }
    return self;
}

#pragma mark - Runtime

- (BOOL)respondsToSelector:(SEL)aSelector {
    
    return isInterceptedSelector(aSelector)
    || [_scrollViewTarget respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (isInterceptedSelector(aSelector)) {
        return _interceptor;
    }else if ([_scrollViewTarget respondsToSelector:aSelector]) {
        return _scrollViewTarget;
    }
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    void *nullPointer = NULL;
    [invocation setReturnValue:&nullPointer];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [NSObject instanceMethodSignatureForSelector:sel];
}

@end
