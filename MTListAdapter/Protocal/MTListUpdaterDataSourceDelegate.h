//
//  MTlistUpdaterDataSourceDelegate.h
//  FeedListDemo
//
//  Created by meipai_lv on 2018/4/19.
//  Copyright © 2018年 MT.inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTListUpdaterDataSourceDelegate <NSObject>

@required

- (void)update:(NSArray *)updateArray delete:(NSArray *)deleteArray insert:(NSArray *)insertArray;

@end
