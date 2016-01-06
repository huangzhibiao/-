//
//  orderCommonData.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/10.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import <Foundation/Foundation.h>
//typedef enum{
//    WillPay,//待付款类型
//    WillSend,//待发货类型
//    WillReceive,//待收货类型
//    WillComments//待评价类型
//}orderStyle;
typedef void (^orderOption)();
@interface orderCommonData : NSObject

@property(nonatomic,copy)NSString* icon;//商品图标
@property(nonatomic,copy)NSString* name;//商品名称
@property(nonatomic,copy)NSString* status;//商品交易状态
@property(nonatomic,copy)NSString* descri;//商品描述
@property(nonatomic,strong)NSNumber* price;//商品单件价格
@property(nonatomic,strong)NSNumber* num;//商品数量
@property(nonatomic,strong)NSNumber* expressMoney;//快递费用
@property(nonatomic,strong)NSNumber* AllMoney;//全部商品价钱
@property(nonatomic,copy)orderOption firstOption;//点击指向响应的操作
@property(nonatomic,copy)orderOption secondOption;//点击指向响应的操作
//@property(nonatomic,assign)orderStyle style;//cell类型

@end
