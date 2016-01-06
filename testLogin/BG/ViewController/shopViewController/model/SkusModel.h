//
//  SkusModel.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/22.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SkusModel : NSObject

@property(nonatomic,copy)NSString* sku_id; // -> product_id
@property(nonatomic,copy)NSString* iid; // -> goods_id
@property(nonatomic,copy)NSString* bn;
@property(nonatomic,copy)NSString* properties;
@property(nonatomic,copy)NSString* quantity;
@property(nonatomic,strong)NSNumber* weight;
@property(nonatomic,strong)NSNumber* price;
@property(nonatomic,strong)NSNumber* market_price;
@property(nonatomic,copy)NSString* modified;
@property(nonatomic,strong)NSNumber* cost;

@end
