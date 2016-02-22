//
//  BGLRRefresh.h
//  BGTaobao
//
//  Created by huangzhibiao on 16/2/22.
//  Copyright © 2016年 haiwang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^animatOption)();

@interface BGLRRefresh : UIView

@property(weak,nonatomic)UIScrollView* scrollview;//用于绑定的scrollview
// 父控件一开始的contentInset
@property (assign, nonatomic)UIEdgeInsets scrollViewInitInset;
@property(copy,nonatomic)animatOption block;//回调block
@property (assign, nonatomic)BOOL refreshing;//刷新跳转中

+(instancetype)view;

-(void)contentWidth:(CGFloat)width;

/**
 释放函数
 */
-(void)free;

@end
