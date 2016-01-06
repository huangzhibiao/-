//
//  BGPayStyleView.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/24.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderModel.h"

@interface BGPayStyleView : UIView

@property(nonatomic,strong)MyOrderModel* orderData;
@property(nonatomic,strong)NSArray* items;
/**
 显示
 */
+(void)showWithOrderData:(MyOrderModel*)orderData items:(NSArray*)items;

@end
