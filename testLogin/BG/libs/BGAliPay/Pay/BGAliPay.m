//
//  BGAliPay.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/25.
//  Copyright © 2015年 haiwang. All rights reserved.
//
/**
 支付宝相关头文件
 */
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"

#import "BGAliPay.h"
#import "global.h"

@implementation BGAliPay

/**
 支付函数
 */
-(void)Pay{
    //partner和seller获取失败,提示
    if ([ALIPAY_partner length] == 0 ||
        [ALIPAY_seller length] == 0 ||
        [ALIPAY_privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = ALIPAY_partner;
    order.seller = ALIPAY_seller;
    order.tradeNO = [global generateTradeNO]; //订单ID（由商家自行制定）
    //NSLog(@"订单:%@",order.tradeNO);
    order.productName = self.orderData.order_id; //商品标题
    order.productDescription = self.orderData.order_id; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
    order.notifyURL =  ALIPAY_notifyURL; //回调URL
    order.service = ALIPAY_service;
    order.paymentType = ALIPAY_paymentType;
    order.inputCharset = ALIPAY_inputCharset;
    order.itBPay = ALIPAY_itBPay;
    order.showUrl = ALIPAY_showUrl;
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = APPScheme;
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    //NSLog(@"orderSpec = %@",orderSpec);
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(ALIPAY_privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //NSLog(@"reslut = %@",resultDic[@"resultStatus"]);
            NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
            if (resultStatus == 9000) {
                NSDictionary* dict = [global AliPayResultParseWithString:resultDic[@"result"]];
            if ([@"true" isEqualToString:dict[@"success"]]) {
                if ([self.delegate respondsToSelector:@selector(BGAliPayComplete:)]) {
                    [self.delegate BGAliPayComplete:succ];
                    }
                }else{
                if ([self.delegate respondsToSelector:@selector(BGAliPayComplete:)]) {
                    [self.delegate BGAliPayComplete:fail];
                }
                }
            }else{
                if ([self.delegate respondsToSelector:@selector(BGAliPayComplete:)]) {
                    [self.delegate BGAliPayComplete:fail];
                }
            }
        }];
        
    }
    
}


-(void)setOrderData:(MyOrderModel *)orderData{
    _orderData = orderData;
}

@end
