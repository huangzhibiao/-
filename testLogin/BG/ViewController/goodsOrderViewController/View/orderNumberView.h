//
//  orderNumberView.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/9.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orderNumberView : UIView

@property(nonatomic,copy)NSString* orderNum;//订单编号
@property(nonatomic,copy)NSString* createdTime;//订单创建时间

+(instancetype)view;

@end
