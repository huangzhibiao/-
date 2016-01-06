//
//  MyOrderModel.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/22.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "MyOrderModel.h"
#import "MJExtension.h"
#import "MyOrderModel_item.h"
@implementation MyOrderModel

- (NSDictionary *)objectClassInArray
{
    return @{@"item" : [MyOrderModel_item class]};
}

@end
