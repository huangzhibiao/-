//
//  BGOrderFrame.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/23.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MyOrderModel.h"
#import "MyOrderModel_item.h"

#define topViewCellH 95.0
#define BGOFMiddleViewH 55.0
#define BGOFBottomViewH 55.0
#define BGOFMargin 5.0

@interface BGOrderFrame : NSObject

@property(nonatomic,strong)MyOrderModel* orderData;//订单数据
@property(nonatomic,assign)CGRect topViewFrame;//顶部view frame
@property(nonatomic,assign)CGRect middleViewFrame;//中间view frame
@property(nonatomic,assign)CGRect bottomViewFrame;//底部view frame

@end
