//
//  BGRefresh.h
//  BGJDRefresh
//
//  Created by huangzhibiao on 16/4/18.
//  Copyright © 2016年 JDRefresh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^animatOption)();

@interface BGRefresh : UIView

@property(weak,nonatomic)UIScrollView* scrollview;
@property(copy,nonatomic)animatOption startBlock;
@property(copy,nonatomic)animatOption endBlock;
@property(assign,nonatomic)BOOL isAutoEnd;//是否自动结束刷新 YES/NO 自动/手动
@property(assign,nonatomic)float refreshTime;//自动刷新的时间(秒为单位) 手动结束刷新时不设置此项

/**
 刷新完毕隐藏(可以手动结束)
 */
-(void)hide;
/**
 释放控件
 */
-(void)free;

@end
