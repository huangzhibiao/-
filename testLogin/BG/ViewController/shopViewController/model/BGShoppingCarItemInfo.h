//
//  BGShoppingCarItemInfo.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/29.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGShoppingCarItemInfo : NSObject
@property(nonatomic,copy)NSString* obj_ident;
@property(nonatomic,copy)NSString* obj_type;
@property(nonatomic,copy)NSString* goods_id;
@property(nonatomic,copy)NSString* product_id;
@property(nonatomic,copy)NSString* name;
@property(nonatomic,copy)NSString* spec_info;
@property(nonatomic,copy)NSString* store_real;
@property(nonatomic,copy)NSString* quantity;
@property(nonatomic,strong)NSNumber* price;
@property(nonatomic,strong)NSNumber* discount_price;
@property(nonatomic,strong)NSNumber* total_price;
@property(nonatomic,copy)NSString* score;
@property(nonatomic,copy)NSString* pic;
@end
