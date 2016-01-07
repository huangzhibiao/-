//
//  MyOrderTopTabBar.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/9.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabButton;
@class MyOrderTopTabBar;
@protocol MyOrderTopTabBarDelegate <NSObject>
@optional
-(void)tabBar:(MyOrderTopTabBar *)tabBar didSelectIndex:(NSInteger)index;

@end

@interface MyOrderTopTabBar : UIView

@property(nonatomic,weak) id<MyOrderTopTabBarDelegate> delegate;
/**
 静态方法初始化
 */
+(instancetype)tabbar;
/**
 使用数组初始化
 */
-(instancetype)initWithArray:(NSArray*)array;
-(void)AddTarBarBtn:(NSString *)name;//添加顶部标题项的名字
-(void)TabBtnClick:(TabButton *)sender;//监听tabbar的点击
@end
