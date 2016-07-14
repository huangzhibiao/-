//
//  BGTopSilderBar.h
//  topSilderBar
//
//  Created by huangzhibiao on 16/7/7.
//  Copyright © 2016年 Biao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "global.h"
//平常状态的颜色
#define NormalColor color(93.0,93.0,93.0,1.0)
//被选中状态的颜色
#define SelectedColor color(243.0,39.0,66.0,1.0)
//下划线的颜色
#define UnderlineColor color(243.0,39.0,66.0,1.0)
//设置一页标题item有几个,默认6个
#define itemNum 6

@interface BGTopSilderBar : UIView

@property(nonatomic,weak)UIScrollView* contentCollectionView;
@property(nonatomic,assign)CGFloat underlineX;//下划线的x轴距离
@property(nonatomic,assign)CGFloat underlineWidth;//下划线的宽度

/**
 从某个item移动到另一个item
 */
-(void)setItemColorFromIndex:(NSInteger)fromIndex to:(NSInteger)toIndex;
@end
