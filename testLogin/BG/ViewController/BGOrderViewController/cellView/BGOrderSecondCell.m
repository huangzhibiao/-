//
//  BGOrderSecondCell.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/23.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "BGOrderSecondCell.h"
#import "global.h"
#import "BGOrderSecondCellItemView.h"
#import "UIImageView+WebCache.h"

@interface BGOrderSecondCell()

@property(nonatomic,weak)BGOrderSecondCellItemView* cellView;

@end

@implementation BGOrderSecondCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        BGOrderSecondCellItemView* view = [BGOrderSecondCellItemView view];
        self.cellView = view;
        [self.contentView addSubview:view];
    }
    return self;
}

+(instancetype)cellWithTableView:(UITableView*)tableView {
    static NSString *ID = @"BGOrderSecondCell";
    //优化cell，去缓存池中寻找是否有可用的cell
    BGOrderSecondCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell ==nil){
        cell = [[BGOrderSecondCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

-(void)setOrderWith:(MyOrderModel *)orderData row:(NSInteger)row{
    _orderData = orderData;
    _row = row;
    MyOrderModel_item* item = orderData.item[row];
    self.cellView.frame = CGRectMake(0, 0, screenW, 95.0);
    [self.cellView.icon sd_setImageWithURL:[NSURL URLWithString:item.goods_pic[@"s_url"]] placeholderImage:nil];
    self.cellView.status.text = orderData.pay_status;
    self.cellView.name.text = item.goods_name;
    self.cellView.num.text = [NSString stringWithFormat:@"x%@",item.quantity];
    self.selectionStyle = UITableViewCellSelectionStyleNone;//设置不显示点击效果
}
@end
