//
//  MTListAdpterProxy.m
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/16.
//  Copyright © 2018年 MT.inc. All rights reserved.
/*
 https://github.com/Instagram/IGListKit/blob/master/Source/Internal/IGListAdapterProxy.m
 */

#import "MTListAdpterProxy.h"

@interface MTListAdpterProxy() {
    __weak id _collectionViewTarget;
    __weak id _scrollViewTarget;
    __weak MTListAdpter *_interceptor;
}

@end

static BOOL isInterceptedSelector(SEL sel) {
    return(
           // UICollectionViewDelegate
           sel == @selector(collectionView:didSelectItemAtIndexPath:) ||
           sel == @selector(collectionView:willDisplayCell:forItemAtIndexPath:) ||
           sel == @selector(collectionView:didEndDisplayingCell:forItemAtIndexPath:) ||
           // UICollectionViewDelegateFlowLayout
           sel == @selector(collectionView:layout:sizeForItemAtIndexPath:) ||
           sel == @selector(collectionView:layout:insetForSectionAtIndex:) ||
           sel == @selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:) ||
           sel == @selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:) ||
           sel == @selector(collectionView:layout:referenceSizeForFooterInSection:) ||
           sel == @selector(collectionView:layout:referenceSizeForHeaderInSection:) ||
           // UIScrollViewDelegate
           sel == @selector(scrollViewDidScroll:) ||
           sel == @selector(scrollViewWillBeginDragging:) ||
           sel == @selector(scrollViewDidEndDragging:willDecelerate:)
           );
}

@implementation MTListAdpterProxy

- (instancetype)initWithCollectionTarget:(id<UICollectionViewDelegate>)collectionViewTarget
                        scrollViewTarget:(id<UIScrollViewDelegate>)scrollViewTarget
                             interceptor:(MTListAdpter *)interceptor {
    if (self) {
        _collectionViewTarget = collectionViewTarget;
        _scrollViewTarget = scrollViewTarget;
        _interceptor = interceptor;
    }
    return self;
}

#pragma mark - Runtime

- (BOOL)respondsToSelector:(SEL)aSelector {
    return isInterceptedSelector(aSelector)
    || [_collectionViewTarget respondsToSelector:aSelector]
    || [_scrollViewTarget respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (isInterceptedSelector(aSelector)) {
        return _interceptor;
    }
    return [_scrollViewTarget respondsToSelector:aSelector] ? _scrollViewTarget : _collectionViewTarget;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    void *nullPointer = NULL;
    [invocation setReturnValue:&nullPointer];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [NSObject instanceMethodSignatureForSelector:sel];
}

@end
