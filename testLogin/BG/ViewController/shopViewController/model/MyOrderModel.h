//
//  MyOrderModel.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/22.
//  Copyright © 2015年 haiwang. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef enum{
    WillPay,//待付款类型
    WillSend,//待发货类型
    WillReceive,//待收货类型
    WillComments//待评价类型
}orderStyle;

@interface MyOrderModel : NSObject

@property(nonatomic,copy)NSString* order_id;
@property(nonatomic,copy)NSString* itemnum;
@property(nonatomic,strong)NSNumber* amount;
@property(nonatomic,copy)NSString* createtime;
@property(nonatomic,copy)NSString* pay_status;//未支付
@property(nonatomic,copy)NSString* ship_status;//未发货
@property(nonatomic,copy)NSString* status;
@property(nonatomic,strong)NSArray* item;

@property(nonatomic,assign)orderStyle style;//cell类型
          
@end
