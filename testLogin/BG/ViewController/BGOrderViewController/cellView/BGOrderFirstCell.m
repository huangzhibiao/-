//
//  BGOrderFirstCell.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/23.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "BGOrderFirstCell.h"
#import "BGOrderSecondCell.h"
#import "global.h"
#import "BGOrderAccountView.h"

@interface BGOrderFirstCell()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak)UITableView* tableview;
@property(nonatomic,weak)BGOrderAccountView* accountView;
@property(nonatomic,weak)UIView* btnActionView;
@property(nonatomic,weak)UIButton* firstBtn;//第一个操作按钮(从右向左数)
@property(nonatomic,weak)UIButton* secondBtn;//第二个操作按钮

@end

@implementation BGOrderFirstCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;//设置不可点击
        self.contentView.backgroundColor = color(245.0, 245.0, 245.0, 1.0);
        [self initTableView];//初始化里层的tableview
        [self initAccountView];//初始化结算部分view
        [self initBtnActionView];//初始化按钮部分view
    }
    return self;
}
+(instancetype)cellWithTableView:(UITableView*)tableView {
    static NSString *ID = @"BGOrderFirstCell";
    //优化cell，去缓存池中寻找是否有可用的cell
    BGOrderFirstCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell ==nil){
        cell = [[BGOrderFirstCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

/**
 设置空间数据和frame
 */
-(void)setOrderFrame:(BGOrderFrame *)orderFrame{
    //商品列表部分
    _orderFrame = orderFrame;
    self.tableview.frame = orderFrame.topViewFrame;
    [self.tableview reloadData];//刷新数据
    //结算部分
    self.accountView.frame = orderFrame.middleViewFrame;
    self.accountView.allNum.text = [NSString stringWithFormat:@"共计%@件商品",orderFrame.orderData.itemnum];
#warning  --  后期8.00要改为真实运费
    NSString* money = [NSString stringWithFormat:@"¥%@(含运费¥%@)",orderFrame.orderData.amount,@(8.00)];
    NSMutableAttributedString* attStr = [global setMutableStringWithString:money bigFont:BGFont(15.0) smallFont:BGFont(11.0)];
    self.accountView.allMoney.attributedText = attStr;
    //按钮点击部分
    self.btnActionView.frame = orderFrame.bottomViewFrame;
    CGFloat btnW = 75.0;
    CGFloat btnH = 35.0;
    self.firstBtn.frame = CGRectMake(screenW-btnW-13.0, (BGOFBottomViewH-btnH)*0.5, btnW, btnH);
    self.secondBtn.frame = CGRectMake(CGRectGetMinX(_firstBtn.frame)-btnW-5.0, (BGOFBottomViewH-btnH)*0.5, btnW, btnH);
    [self judgeStyle];//判断类型设置底部按钮
}

/**
 判断类型设置底部按钮
 */
-(void)judgeStyle{
    if (self.orderFrame.orderData.style == WillPay) {
        self.secondBtn.hidden = NO;
        [self setBtn:self.firstBtn Title:@"付款" TitleColor:[UIColor whiteColor] BackgroundColor:color(0.0, 162.0, 154.0, 1.0) action:@selector(firstAction)];
        [self setBtn:self.secondBtn Title:@"取消订单" TitleColor:color(100.0,100.0,100.0,1.0) BackgroundColor:[UIColor whiteColor] action:@selector(secondAction)];
        self.secondBtn.layer.borderWidth = 1.0;
        self.secondBtn.layer.borderColor = color(220.0,220.0,220.0,1.0).CGColor;
    }else if(self.orderFrame.orderData.style == WillSend){
        self.secondBtn.hidden = YES;
        [self setBtn:self.firstBtn Title:@"提醒发货" TitleColor:color(100.0,100.0,100.0,1.0) BackgroundColor:[UIColor whiteColor] action:@selector(firstAction)];
        self.firstBtn.layer.borderWidth = 1.0;
        self.firstBtn.layer.borderColor = color(220.0,220.0,220.0,1.0).CGColor;
    }else if(self.orderFrame.orderData.style == WillReceive){
        self.secondBtn.hidden = YES;
        [self setBtn:self.firstBtn Title:@"确认收货" TitleColor:[UIColor whiteColor]BackgroundColor:color(0.0, 162.0, 154.0, 1.0) action:@selector(firstAction)];
    }else if(self.orderFrame.orderData.style == WillComments){
        self.secondBtn.hidden = NO;
        [self setBtn:self.firstBtn Title:@"评价" TitleColor:[UIColor whiteColor] BackgroundColor:color(0.0, 162.0, 154.0, 1.0) action:@selector(firstAction)];
        [self setBtn:self.secondBtn Title:@"删除订单" TitleColor:color(100.0,100.0,100.0,1.0) BackgroundColor:[UIColor whiteColor] action:@selector(secondAction)];
        self.secondBtn.layer.borderWidth = 1.0;
        self.secondBtn.layer.borderColor = color(220.0,220.0,220.0,1.0).CGColor;
    }else;
    
}

/**
 第一个按钮操作函数
 */
-(void)firstAction{
    //NSLog(@"第一个按钮操作函数");
    if ([self.delegate respondsToSelector:@selector(clickFirstBtn:)]) {
        [self.delegate clickFirstBtn:self.orderFrame];
    }
}

/**
 第二个按钮操作函数
 */
-(void)secondAction{
    //NSLog(@"第二个按钮操作函数");
    if ([self.delegate respondsToSelector:@selector(clickSecondBtn:)]) {
        [self.delegate clickSecondBtn:self.orderFrame];
    }
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
 拦截设置frame
 */
- (void)setFrame:(CGRect)frame
{
    frame.origin.y += 5;
    frame.size.height -= 5;
    [super setFrame:frame];
}
/**
 初始化按钮部分view
 */
-(void)initBtnActionView{
    //创建父view
    UIView* view = [[UIView alloc] init];
    self.btnActionView = view;
    view.backgroundColor = [UIColor whiteColor];
    //创建付款按钮
    UIButton* firstBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    firstBtn.titleLabel.font = BGFont(14.0);
    self.firstBtn = firstBtn;
    //创建取消订单按钮
    UIButton* secondBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    secondBtn.titleLabel.font = BGFont(14.0);
    self.secondBtn = secondBtn;
    
    [view addSubview:firstBtn];
    [view addSubview:secondBtn];
    [self.contentView addSubview:view];
}
/**
 初始化结算部分view
 */
-(void)initAccountView{
    BGOrderAccountView* view = [BGOrderAccountView view];
    self.accountView = view;
    [self.contentView addSubview:view];
}
/**
 初始化MyTableView
 */
-(void)initTableView{
    UITableView* tableview = [[UITableView alloc] init];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.rowHeight = topViewCellH;
    tableview.showsVerticalScrollIndicator = NO;
    tableview.backgroundColor = color(245.0, 245.0, 245.0, 1.0);
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.scrollEnabled = NO;//禁止滑动,防止跟外面的scrollview冲突
    self.tableview = tableview;
    [self.contentView addSubview:tableview];
}

#pragma -- UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderFrame.orderData.item.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BGOrderSecondCell* cell = [BGOrderSecondCell cellWithTableView:tableView];
    [cell setOrderWith:self.orderFrame.orderData row:indexPath.row];
    return cell;
    
}

#pragma -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //if (self.orderFrame.orderData.style == WillSend)return;//待发货状态不可点击
    
    if ([self.delegate respondsToSelector:@selector(selectCell:index:)]) {
        [self.delegate selectCell:self.orderFrame index:indexPath.row];//代理
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中
}

@end
