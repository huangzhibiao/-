//
//  WillPayCell.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/10.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "orderstyleCell.h"

@interface orderstyleCell()

@property(nonatomic,weak)UIView* view;
@property(nonatomic,weak)UIButton* firstBtn;//第一个操作按钮(从右向左数)
@property(nonatomic,weak)UIButton* secondBtn;//第二个操作按钮

@end

@implementation orderstyleCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //创建父view
        UIView* view = [[UIView alloc] init];
        self.view = view;
        view.backgroundColor = [UIColor whiteColor];
        //创建付款按钮
        UIButton* firstBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        firstBtn.titleLabel.font = [UIFont systemFontOfSize:[global pxTopt:26.0]];
        self.firstBtn = firstBtn;
        //创建取消订单按钮
        UIButton* secondBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        secondBtn.titleLabel.font = [UIFont systemFontOfSize:[global pxTopt:26.0]];
        self.secondBtn = secondBtn;
        
        [view addSubview:firstBtn];
        [view addSubview:secondBtn];
        [self.contentView addSubview:view];
    }
    return self;
}
+(instancetype)cellWithTableView:(UITableView*)tableView {
    static NSString *ID = @"myOrderTBCCell";
    //优化cell，去缓存池中寻找是否有可用的cell
    orderstyleCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell ==nil){
        cell = [[orderstyleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


/**
 设置模型数据
 */
-(void)setData:(MyOrderModel *)data{
    [super setData:data];
    [self setCellViewFrame];
    for(int i=0 ;i<self.CommonViews.count;i++){
        myOrderCommonCellView* CommonView = self.CommonViews[i];
        MyOrderModel_item* item = data.item[i];
        CommonView.icon = item.goods_pic[@"s_url"];//设置商品图标
        CommonView.name = item.goods_name;//设置商品名字
        CommonView.status = data.status;//设置商品交易状态
        CommonView.descri = item.goods_name;//设置商品交易状态
        CommonView.price = @(22.00);//设置商品价格
        CommonView.num = item.quantity;//设置商品数量
    }
    [self judgeStyle];//判断类型设置底部按钮
}
/**
 判断类型设置底部按钮
 */
-(void)judgeStyle{
    if (self.data.style == WillPay) {
        self.secondBtn.hidden = NO;
        [self setBtn:self.firstBtn Title:@"付款" TitleColor:[UIColor whiteColor] BackgroundColor:color(0.0, 162.0, 154.0, 1.0) action:@selector(firstAction)];
        [self setBtn:self.secondBtn Title:@"取消订单" TitleColor:color(100.0,100.0,100.0,1.0) BackgroundColor:[UIColor whiteColor] action:@selector(secondAction)];
        self.secondBtn.layer.borderWidth = 1.0;
        self.secondBtn.layer.borderColor = color(220.0,220.0,220.0,1.0).CGColor;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;//设置可点击
    }else if(self.data.style == WillSend){
        self.secondBtn.hidden = YES;
        [self setBtn:self.firstBtn Title:@"提醒发货" TitleColor:color(100.0,100.0,100.0,1.0) BackgroundColor:[UIColor whiteColor] action:@selector(firstAction)];
        self.firstBtn.layer.borderWidth = 1.0;
        self.firstBtn.layer.borderColor = color(220.0,220.0,220.0,1.0).CGColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;//设置不可点击
    }else if(self.data.style == WillReceive){
        self.secondBtn.hidden = YES;
        [self setBtn:self.firstBtn Title:@"确认收货" TitleColor:[UIColor whiteColor]BackgroundColor:color(0.0, 162.0, 154.0, 1.0) action:@selector(firstAction)];
        self.selectionStyle = UITableViewCellSelectionStyleDefault;//设置可点击
    }else if(self.data.style == WillComments){
        self.secondBtn.hidden = NO;
        [self setBtn:self.firstBtn Title:@"评价" TitleColor:[UIColor whiteColor] BackgroundColor:color(0.0, 162.0, 154.0, 1.0) action:@selector(firstAction)];
        [self setBtn:self.secondBtn Title:@"删除订单" TitleColor:color(100.0,100.0,100.0,1.0) BackgroundColor:[UIColor whiteColor] action:@selector(secondAction)];
        self.secondBtn.layer.borderWidth = 1.0;
        self.secondBtn.layer.borderColor = color(220.0,220.0,220.0,1.0).CGColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;//设置不可点击
    }else;

}
/**
 抽取设置按钮属性函数
 */
-(void)setBtn:(UIButton*)btn Title:(NSString*)title TitleColor:(UIColor*)titleColor BackgroundColor:(UIColor*)backgroundColor action:(SEL)action{
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.backgroundColor = backgroundColor;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
}
/**
 设置底部按钮那一栏view的frame
 */
-(void)setCellViewFrame{
    [super setCellViewFrame];
    CGFloat btnW = [global pxTopt:140.0];
    CGFloat btnH = [global pxTopt:60.0];
    CGFloat Margin = [global pxTopt:25.0];
    UIView* view = [self.CommonViews lastObject];//后加---
    if (self.view != nil) {
        CGFloat Y = CGRectGetMaxY(view.frame)+[global pxTopt:1.0];
        self.view.frame = CGRectMake(0, Y, screenW, [global pxTopt:100.0]);
        CGFloat payX = self.view.frame.size.width -btnW - Margin;
        CGFloat payY = (self.view.frame.size.height - btnH)*0.5;
        self.firstBtn.frame = CGRectMake(payX, payY, btnW, btnH);
        self.secondBtn.frame = CGRectMake(payX-Margin-btnW, payY, btnW, btnH);
    }
}

/**
 第一个按钮操作函数
 */
-(void)firstAction{
//    if (self.data.firstOption) {
//        self.data.firstOption();
//    }
}

/**
 第二个按钮操作函数
 */
-(void)secondAction{
//    if (self.data.secondOption) {
//        self.data.secondOption();
//    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
