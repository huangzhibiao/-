//
//  BGPayStyleView.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/24.
//  Copyright © 2015年 haiwang. All rights reserved.
//


#import "BGPayStyleView.h"
#import "global.h"
#import "payStyleViewCellData.h"
#import "BGPayStyleViewCell.h"
#import "MBProgressHUD+MJ.h"
#import "BGAliPay.h"
#import "BGWXPay.h"

#define topViewH 55.0
#define cellH 70.0

@interface BGPayStyleView()<UITableViewDataSource,UITableViewDelegate,BGAliPayDelegate>

@property(nonatomic,weak)UIView* topView;
@property(nonatomic,weak)UITableView* tableview;
@property(nonatomic,assign)NSIndexPath* indexPath;//记录tablewview的点击行数

@end

@implementation BGPayStyleView

// 移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        if([WXApi isWXAppInstalled]) // 判断 用户是否安装微信
        {NSLog(@"注册监听微信----");
            // 监听一个通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:) name:WXNOTIFICATION object:nil];
        }
        [self initForwardView];
    }
    return self;
}

/**
 显示
 */
+(void)showWithOrderData:(MyOrderModel*)orderData items:(NSArray*)items{
    UIView* view = [BGPayStyleView getUIWindow];
    if (view == nil) {
        return;
    }
    BGPayStyleView* payView = [[self alloc] initWithFrame:CGRectMake(0, screenH, screenW, screenH)];
    payView.orderData = orderData;
    payView.items = items;
    [view addSubview:payView];
    [payView begin];
}

-(void)begin{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 0, screenW, screenH);
    }];
}
/**
 隐藏
 */
-(void)hide{//UIWindow
    UIView* view = [BGPayStyleView getUIWindow];
    if (view == nil) {
        return;
    }
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[BGPayStyleView class]]) {
            [UIView animateWithDuration:0.3 animations:^{
                subview.frame = CGRectMake(0, screenH, screenW, screenH);
            } completion:^(BOOL finished) {
                [subview removeFromSuperview];
                NSLog(@"移除支付view");
            }];
        }
    }
}

/**
 获取UIWindow
 */
+(UIView*)getUIWindow{
    UIView* view = nil;
    NSArray* array = [UIApplication sharedApplication].windows;
    for(int i=0;i<array.count;i++){
        if ([array[i] isKindOfClass:[UIWindow class]]) {
            view = array[i];
            break;
        }
    }
    return view;
}
/**
 添加最外面那层模糊效果view
 */
-(void)initForwardView{
    self.backgroundColor = color(33.0, 33.0, 33.0, 0.4);
    //添加顶部view
    UIView* topView = [self getTopView];
    self.topView = topView;
    topView.frame = CGRectMake(0, screenH*0.5, screenW, topViewH);
    //添加tableview
    UITableView* tableview = [self getTableView];
    tableview.frame = CGRectMake(0, CGRectGetMaxY(topView.frame), screenW,screenH*0.5 - topViewH);
    self.tableview = tableview;
    [self addSubview:topView];
    [self addSubview:tableview];
}
/**
 初始化顶部view
 */
-(UIView*)getTopView{
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = color(238.0, 238.0, 238.0, 1.0);
    //设置退出按钮
    UIButton* backBtn = [[UIButton alloc] init];
    CGFloat imgWH = 18.0;
    CGFloat Margin = 13.0;
    backBtn.frame = CGRectMake(Margin,(topViewH-imgWH)*0.5, imgWH, imgWH);
    [backBtn setImage:[UIImage imageNamed:@"affirm_x"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    //设置标题
    NSString* title = @"请选择支付方式" ;
    CGSize size = [global sizeWithText:title font:BGFont(17.0) maxSize:CGSizeMake(200, MAXFLOAT)];
    UILabel* lable = [[UILabel alloc] init];
    lable.text = title;
    lable.frame = CGRectMake((screenW-size.width)*0.5, (topViewH-size.height)*0.5, size.width, size.height);
    [view addSubview:backBtn];
    [view addSubview:lable];
    return view;
}
/**
 初始化tableview
 */
-(UITableView*)getTableView{
    UITableView* tableview = [[UITableView alloc] init];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.rowHeight = cellH;
    tableview.showsVerticalScrollIndicator = NO;
    tableview.backgroundColor = [UIColor whiteColor];
    return tableview;
}
/**
 刷新某行
 */
/**
 支付宝支付
 */
-(void)AliPay{
    BGAliPay* Alipay = [[BGAliPay alloc] init];
    Alipay.orderData = self.orderData;//传递数据给支付宝
    Alipay.delegate = self;//设置支付宝代理
    [Alipay Pay];
}

#pragma mark - 收到微信支付成功的通知消息后作相应的处理
- (void)getOrderPayResult:(NSNotification *)notification
{
    NSString* message = notification.object;
    [self complete:message];
}

/**
 微信支付
 */
-(void)WXPay{
    BGWXPay* WxPay = [[BGWXPay alloc] init];
    WxPay.orderData = self.orderData;
    [WxPay pay];
}
/**
 刷新某行
 */
-(void)refreshIndexPath{
    
    for(int i=0;i<self.items.count;i++){
        payStyleViewCellData* data = self.items[i];
        data.selected = self.indexPath.row==i?YES:NO;
    }
    [self.tableview reloadData];
}

/**
 支付完成共用的通知处理函数
 */
-(void)complete:(NSString*)message{
    if ([message isEqualToString:succ]) {
        //通知外界支付成功
        NSNotification *notification = [NSNotification notificationWithName:BG_ORDER_STATUS_NPTIFICATION object:paySucc];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [MBProgressHUD showSuccess:@"支付成功"];
        [self hide];//支付成功则隐藏支付view
    }else if([message isEqualToString:fail]){
        [MBProgressHUD showError:@"支付失败!"];
        [self refreshIndexPath];//刷新某行
    }else;
}

#pragma -- UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BGPayStyleViewCell* cell = [BGPayStyleViewCell cellWithTableView:tableView];
    cell.data = self.items[indexPath.row];
    return cell;
    
}

#pragma -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    self.indexPath= indexPath;//记录点击的行数
    payStyleViewCellData* data = self.items[indexPath.row];
    if ([data.title isEqualToString:ZHIFUBAO_PAY]) {
        [self AliPay];
    }else if([data.title isEqualToString:WEIXIN_PAY]){
        [self WXPay];
    }else;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中
    NSLog(@"%@ -- %@",data.title,self.orderData.order_id);
}

#pragma -- BGAliPayDelegate  支付宝代理回调
-(void)BGAliPayComplete:(NSString *)message{
    [self complete:message];
}

@end
