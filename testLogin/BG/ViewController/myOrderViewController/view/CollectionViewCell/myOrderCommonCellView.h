//
//  myOrderCommonCellView.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/10.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myOrderCommonCellView : UIView

@property(nonatomic,copy)NSString* icon;//商品图标
@property(nonatomic,copy)NSString* name;//商品名称
@property(nonatomic,copy)NSString* status;//商品交易状态
@property(nonatomic,copy)NSString* descri;//商品描述
@property(nonatomic,strong)NSNumber* price;//商品单件价格
@property(nonatomic,strong)NSNumber* num;//商品数量
+ (instancetype)view;

@end
