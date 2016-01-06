//
//  orderGoodsDetailView.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/8.
//  Copyright © 2015年 haiwang. All rights reserved.
//订单商品详情部分的view

#import <UIKit/UIKit.h>

@interface orderGoodsDetailView : UIView

@property(nonatomic,copy)NSString* image;//商品图片
@property(nonatomic,copy)NSString* name;//商品名称
@property(nonatomic,copy)NSString* descri;//商品规格
@property(nonatomic,copy)NSNumber* price;//商品价格
@property(nonatomic,copy)NSNumber* num;//商品数量

+ (instancetype)view;

@end
