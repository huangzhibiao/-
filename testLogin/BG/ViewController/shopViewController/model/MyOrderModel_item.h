//
//  MyOrderModel_item.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/22.
//  Copyright © 2015年 haiwang. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface MyOrderModel_item : NSObject

@property(nonatomic,copy)NSString* goods_id;
@property(nonatomic,copy)NSString* product_id;
@property(nonatomic,copy)NSString* goods_name;//CLINIQUE 倩碧 旅行套装
@property(nonatomic,copy)NSString* spec_info;
@property(nonatomic,strong)NSNumber* quantity;
@property(nonatomic,copy)NSString* item_type;
@property(nonatomic,strong)NSDictionary* goods_pic;

@end
