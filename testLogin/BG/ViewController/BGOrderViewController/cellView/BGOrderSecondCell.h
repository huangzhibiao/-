//
//  BGOrderSecondCell.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/23.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderModel.h"
#import "MyOrderModel_item.h"

@interface BGOrderSecondCell : UITableViewCell

@property(nonatomic,strong)MyOrderModel* orderData;
@property(nonatomic,assign)NSInteger row;

-(void)setOrderWith:(MyOrderModel*)orderData row:(NSInteger)row;
+(instancetype)cellWithTableView:(UITableView*)tableView;


@end
