//
//  BGShoppingCarInfo.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/29.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGShoppingCarInfo : NSObject
@property(nonatomic,copy)NSString* order_promotion;
@property(nonatomic,strong)NSNumber* subtotal_goods_price;
@property(nonatomic,strong)NSNumber* subtotal_discount_amount;
@property(nonatomic,strong)NSNumber* subtotal_gain_score;
@property(nonatomic,strong)NSNumber* subtotal_price;
@property(nonatomic,strong)NSArray* allGoods;//全部商品模型

@end
