//
//  BGAliPay.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/25.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyOrderModel.h"

@protocol BGAliPayDelegate <NSObject>

@required
-(void)BGAliPayComplete:(NSString*)message;

@end

@interface BGAliPay : NSObject

@property(nonatomic,strong)MyOrderModel* orderData;
@property(nonatomic,weak)id<BGAliPayDelegate> delegate;

-(void)Pay;
@end
