//
//  MJRefreshHeaderView.h
//  MJRefresh
//
//  Created by mj on 13-2-26.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  下拉刷新

#import "MJRefreshBaseView.h"

@interface MJRefreshHeaderView : MJRefreshBaseView
//显示字符
@property (nonatomic, copy)NSString* BGRefreshHeaderPullToRefresh;
@property (nonatomic, copy)NSString* BGRefreshHeaderReleaseToRefresh;
+ (instancetype)header;
@end