//
//  WXPay.h
//  微信支付Demo
//
//  Created by huangzhibiao on 15/12/25.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyOrderModel.h"
#import "WXApi.h"

@interface BGWXPay : NSObject

@property(nonatomic,strong)MyOrderModel* orderData;

-(void)pay;

@end
