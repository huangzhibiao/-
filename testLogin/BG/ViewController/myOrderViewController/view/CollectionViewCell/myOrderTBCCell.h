//
//  myOrderTBCCell.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/10.
//  Copyright © 2015年 haiwang. All rights reserved.
//
/**
 订单UITableViewCell的基类
 */
#import <UIKit/UIKit.h>
#import "myOrderCommonCellView.h"
#import "global.h"
#import "MyOrderModel.h"
#import "MyOrderModel_item.h"

@interface myOrderTBCCell : UITableViewCell

@property(nonatomic,strong)MyOrderModel* data;

@property(nonatomic,strong)NSMutableArray* CommonViews;
//+ (instancetype)cellWithTableView:(UITableView *)tableView;
-(void)setCellViewFrame;
@end
