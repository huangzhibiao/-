//
//  goodsTableViewCell.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/23.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderModel_item.h"

@interface goodsTableViewCell : UITableViewCell

@property(nonatomic,strong)MyOrderModel_item* orderDataItem;
+(instancetype)cellWithTableView:(UITableView*)tableView;

@end
