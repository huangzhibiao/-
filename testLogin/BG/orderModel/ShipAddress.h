//
//  ShipAddress.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/17.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShipAddress : NSObject

@property(nonatomic,copy)NSString* is_default;
@property(nonatomic,copy)NSString* ship_addr;
@property(nonatomic,copy)NSString* ship_area;
@property(nonatomic,copy)NSString* area_id;
@property(nonatomic,strong)NSNumber* ship_id;
@property(nonatomic,copy)NSString* ship_mobile;
@property(nonatomic,strong)NSNumber* ship_name;
@property(nonatomic,copy)NSString* ship_tel;
@property(nonatomic,strong)NSNumber* ship_zip;

@end
