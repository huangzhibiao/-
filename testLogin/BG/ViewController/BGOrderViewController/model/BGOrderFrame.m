//
//  BGOrderFrame.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/23.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "BGOrderFrame.h"
#import "global.h"


@implementation BGOrderFrame

-(void)setOrderData:(MyOrderModel *)orderData{
    _orderData = orderData;
    NSInteger goodsCount = orderData.item.count;
    self.topViewFrame = CGRectMake(0, 0, screenW, topViewCellH*goodsCount);
    self.middleViewFrame = CGRectMake(0, CGRectGetMaxY(self.topViewFrame), screenW, 55);
    self.bottomViewFrame = CGRectMake(0, CGRectGetMaxY(self.middleViewFrame)+1, screenW, 55);
}

@end
