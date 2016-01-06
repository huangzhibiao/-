//
//  goodsTableViewCell.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/23.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "goodsTableViewCell.h"
#import "orderGoodsDetailView.h"
#import "global.h"

@interface goodsTableViewCell()

@property(nonatomic,weak)orderGoodsDetailView* cellView;

@end

@implementation goodsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        orderGoodsDetailView* view = [orderGoodsDetailView view];
        self.cellView = view;
        [self.contentView addSubview:view];
    }
    return self;
}

+(instancetype)cellWithTableView:(UITableView*)tableView {
    static NSString *ID = @"goodsTableViewCell";
    //优化cell，去缓存池中寻找是否有可用的cell
    goodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell ==nil){
        cell = [[goodsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

-(void)setOrderDataItem:(MyOrderModel_item *)orderDataItem{
    _orderDataItem = orderDataItem;
    self.cellView.image = orderDataItem.goods_pic[@"s_url"];
    self.cellView.name = orderDataItem.goods_name;
    self.cellView.descri = @"暂时没有";
    self.cellView.num = orderDataItem.quantity;
    self.cellView.frame = CGRectMake(0, 0, screenW, 95.0);
}

@end
