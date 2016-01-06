//
//  orderAdressView.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/8.
//  Copyright © 2015年 haiwang. All rights reserved.
//订单收货部分的view

#import <UIKit/UIKit.h>

@interface orderAdressView : UIView

@property(nonatomic,copy)NSString* receiveName;//收件人姓名
@property(nonatomic,copy)NSString* telphoneNumber;//手机号
@property(nonatomic,copy)NSString* receiveAddress;//收件地址


+ (instancetype)view;

@end
