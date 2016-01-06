//
//  orderExpressView.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/9.
//  Copyright © 2015年 haiwang. All rights reserved.
//订单快递部分的view

#import <UIKit/UIKit.h>

@interface orderExpressView : UIView

@property(nonatomic,copy)NSString* style;//配送类型
@property(nonatomic,strong)NSNumber* cost;//运费
@property(nonatomic,strong)NSNumber* preferent;//优惠价格
@property(nonatomic,strong)NSNumber* price;//订单总价

+(instancetype)view;

@end
