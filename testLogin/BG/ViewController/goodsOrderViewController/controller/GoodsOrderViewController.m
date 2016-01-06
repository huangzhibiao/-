//
//  GoodsOrderViewController.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/8.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "GoodsOrderViewController.h"
#import "orderAdressView.h"
#import "orderExpressView.h"
#import "orderNumberView.h"
#import "global.h"
#import "goodsTableViewCell.h"
#import "NSString+Md5SignString.h"
#import "BGAFN.h"
#import "MBProgressHUD+MJ.h"
#import "BGPayStyleView.h"
#import "payStyleViewCellData.h"

#define AdViewH 100
#define tableViewCellH 95.0
#define RefundViewH 80
#define ExpressViewH 150
#define NumberViewH 80

@interface GoodsOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *status_lab;//交易状态
@property (weak, nonatomic) IBOutlet UILabel *showdownTime;//交易到期时间
@property (weak, nonatomic) IBOutlet UIImageView *status_img;//状态图标
@property (weak, nonatomic) IBOutlet UIScrollView *MyScrollView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;//付款操作
@property (weak, nonatomic) IBOutlet UIButton *cancelPayBtn;//取消付款操作

@property (weak, nonatomic) orderAdressView* Adview;//收货部分的view
@property (weak, nonatomic) UITableView* goodsTableView;//展示商品列表的tablew
@property (weak, nonatomic) UIView* refundView;//退款按钮所在的view
@property (weak, nonatomic) orderExpressView* expressView;//快递详情部分view
@property (weak, nonatomic) orderNumberView* numberView;//订单部分的view
@property(nonatomic,strong)BGAFN* BGAFNet;//网络请求
/**
 存放支付item的模型数据
 */
@property(nonatomic,strong)NSArray* items;

@end

@implementation GoodsOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self judgeStyle];//判断页面类型
    [self addView];//添加相关view到MyScrollView
    [self setNormalData];//设置普通数据
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 监听一个订单状态刷新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationStyle:) name:BG_ORDER_STATUS_NPTIFICATION object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     NSLog(@"GoodsOrderViewController - 移除通知");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

/**
 实例化网络请求对象
 */
-(BGAFN *)BGAFNet{
    if (_BGAFNet == nil) {
        _BGAFNet = [[BGAFN alloc] init];
    }
    return _BGAFNet;
}
/**
 存放支付item的模型数据
 */
-(NSArray *)items{
    if (_items == nil) {
        NSMutableArray* arr = [[NSMutableArray alloc] init];
        payStyleViewCellData* d1 = [[payStyleViewCellData alloc] init];
        d1.icon = @"affirm_qianbao";
        d1.title = YUER_PAY;
        d1.descri = @"优惠多多";
        d1.selected = NO;
        payStyleViewCellData* d2 = [[payStyleViewCellData alloc] init];
        d2.icon = @"affirm_kuaijie";
        d2.title = KUAIJIE_PAY;
        d2.descri = @"优惠多多";
        d2.selected = NO;
        payStyleViewCellData* d3 = [[payStyleViewCellData alloc] init];
        d3.icon = @"affirm_zhifubao";
        d3.title = ZHIFUBAO_PAY;
        d3.descri = @"优惠多多";
        d3.selected = NO;
        payStyleViewCellData* d4 = [[payStyleViewCellData alloc] init];
        d4.icon = @"affirm_weixin";
        d4.title = WEIXIN_PAY;
        d4.descri = @"优惠多多";
        d4.selected = NO;
        [arr addObject:d1];
        [arr addObject:d2];
        [arr addObject:d3];
        [arr addObject:d4];
        _items = arr;
    }
    return _items;
}
/**
 根据字符串判别通知类型
 */
-(void)notificationStyle:(NSNotification*)dict{
    NSString* object = dict.object;
    if ([paySucc isEqualToString:object]){
        [self orderPay];
    }
}

/**
 //设置普通数据
 */
-(void)setNormalData{
    self.expressView.style = @"暂时没有";//快递方式
    self.expressView.cost = @(8.00);//运费
    self.expressView.preferent = @(10.00);//折扣
    self.expressView.price = self.orderData.amount;//订单总价
    self.numberView.orderNum = self.orderData.order_id;//订单编号
    self.numberView.createdTime = @"2015.01.01 00:00:00";//订单创建时间
}
/**
 抽取设置按钮共同属性的函数，简化代码 -> 越看越爽
 */
-(void)setBtnWithTitle:(NSString*)title TitleColor:(UIColor*)titleColor BackgroundColor:(UIColor*)backgroundColor borderWidth:(CGFloat)borderWidth borderColor:(CGColorRef)borderColor action:(SEL)action Button:(UIButton*)button{
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setBackgroundColor:backgroundColor];
    button.layer.borderWidth = borderWidth;
    button.layer.borderColor = borderColor;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
}
/**
 判断是展示待发货详情页面，还是展示已发货详情页面
 */
-(void)judgeStyle{
    if (self.orderData.style == WillPay) {//待付款详情
        [self.payBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelPayBtn addTarget:self action:@selector(cancelPayAction) forControlEvents:UIControlEventTouchUpInside];
        self.status_img.image = [UIImage imageNamed:@"noPayGoodsDetail"];//设置待付款状态图标
        self.status_lab.text = @"买家未付款";
    }else if (self.orderData.style == WillSend){////待发货详情
        self.cancelPayBtn.hidden = YES;//隐藏第二个按钮
        //退款按钮
        [self setBtnWithTitle:@"退款" TitleColor:[UIColor whiteColor] BackgroundColor:color(250.0, 99.0, 81.0, 1.0) borderWidth:0 borderColor:nil action:@selector(refundAction) Button:self.payBtn];
        self.status_img.image = [UIImage imageNamed:@"willSend"];//设置待发货状态图
        self.status_lab.text = @"买家已付款";
    }else if (self.orderData.style == WillReceive){//已发货详情
        self.cancelPayBtn.hidden = YES;//隐藏取消发货按钮
        [self.payBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [self.payBtn addTarget:self action:@selector(confirmPayAction) forControlEvents:UIControlEventTouchUpInside];
        self.status_img.image = [UIImage imageNamed:@"PayOkGoodsDetail"];//设置待确认付款状态图标
        self.status_lab.text = @"卖家已发货";
        self.showdownTime.text = @"剩余九天12小时自动确认";
    }else if(self.orderData.style == WillComments){//待评价详情
        [self setBtnWithTitle:@"评价" TitleColor:[UIColor whiteColor] BackgroundColor:color(0.0, 162.0, 154.0, 1.0) borderWidth:0 borderColor:nil action:@selector(CommentsOrder) Button:self.payBtn];
        [self setBtnWithTitle:@"删除订单" TitleColor:[UIColor whiteColor] BackgroundColor:color(170.0, 170.0, 170.0, 1.0) borderWidth:0 borderColor:nil action:@selector(deleteOrder) Button:self.cancelPayBtn];
        self.status_img.image = [UIImage imageNamed:@"willComment"];//设置待评价状态图
        self.status_lab.text = @"买家已收货";
    }else;
}

/**
 添加订单支付单(即通知后台支付了)
 */
#warning -- 验证通过
-(void)orderPay{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"order_bn"] = self.orderData.order_id;
    dict[@"payment_id"] = @"111111222aaabbb";
    dict[@"money"] = self.orderData.amount;
    dict[@"cur_money"] = self.orderData.amount;
    dict[@"pay_type"] = @"online";
    dict[@"payment_tid"] = @"alipay";
    dict[@"paymethod"] = b2c_payment_create;
    dict[@"t_begin"] = [global getCurrentTime];
    dict[@"t_end"] = [global getCurrentTime];
    dict[@"ip"] = [global getIPAddress];
    dict[@"trade_no"] = @"aaaabbbbb111112222222";
    dict[member_idKey] = @([global intance].member_id);
    dict[accesstokenKey] = [global intance].accesstoken;
    dict[methodKey] = @"b2c.payment.create";
    dict[signKey] = [NSString sign:dict];
    //NSLog(@"dict = %@",dict);
    [self.BGAFNet requestWithDict:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"订单支付单 --- %@",responseObject);
        NSLog(@"订单支付单 --- %@ --- %@",responseObject[dataKey][messageKey],responseObject[@"res"]);
        [MBProgressHUD showSuccess:@"付款成功"];
        [self dismissViewControllerAnimated:YES completion:^{
            NSNotification *notification = [NSNotification notificationWithName:BG_ORDER_STATUS_NPTIFICATION object:getMyOrderLists];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"订单支付单--error--%@",error);
    }];

}
/**
 b2c.order.status_update 修改订单状态 这里用来 -- 确认收货
 */
-(void)makeSureOrder{
    [self updateOrderStatus:@"finish" message:@"确认收货成功"];
}
/**
 b2c.order.status_update 修改订单状态 这里用来 -- 取消订单
 */
-(void)CancelOrder{
    [self updateOrderStatus:@"dead" message:@"取消订单成功"];
}
/**
 退款函数 -- b2c.refund.create 添加订单退款单
 */
-(void)orderRefund{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"order_bn"] = self.orderData.order_id;
    dict[@"refund_bn"] = @"111111222aaabbb";
    dict[@"money"] = self.orderData.amount;
    dict[@"cur_money"] = self.orderData.amount;
    dict[@"pay_type"] = @"online";
    dict[@"payment_tid"] = @"alipay";
    dict[member_idKey] = @([global intance].member_id);
    dict[accesstokenKey] = [global intance].accesstoken;
    dict[methodKey] = @"b2c.refund.create";
    dict[signKey] = [NSString sign:dict];
    //NSLog(@"dict = %@",dict);
    [self.BGAFNet requestWithDict:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"订单退款 --- %@",responseObject);
        NSLog(@"订单退款 --- %@ --- %@",responseObject[dataKey][messageKey],responseObject[@"res"]);
        if ([fail isEqualToString:responseObject[rspKey]])return;
        [MBProgressHUD showSuccess:@"申请退款成功"];
        [self dismissViewControllerAnimated:YES completion:^{
            NSNotification *notification = [NSNotification notificationWithName:BG_ORDER_STATUS_NPTIFICATION object:getMyOrderLists];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"订单退款--error--%@",error);
    }];

}
/**
 修改订单通用接口
 */
-(void)updateOrderStatus:(NSString*)status message:(NSString*)message{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"order_bn"] = self.orderData.order_id;
    dict[@"status"] = status;;
    dict[member_idKey] = @([global intance].member_id);
    dict[accesstokenKey] = [global intance].accesstoken;
    dict[methodKey] = b2c_order_status_update;
    dict[signKey] = [NSString sign:dict];
    NSLog(@"dict = %@",dict);
    [self.BGAFNet requestWithDict:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@ --- %@",message,responseObject);
        NSLog(@"%@ --- %@ --- %@",message,responseObject[dataKey][messageKey],responseObject[@"res"]);
        [MBProgressHUD showSuccess:message];
        [self dismissViewControllerAnimated:YES completion:^{
            NSNotification *notification = [NSNotification notificationWithName:BG_ORDER_STATUS_NPTIFICATION object:getMyOrderLists];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@--error--%@",message,error);
    }];

}

/**
 付款函数
 */
-(void)payAction{
    NSLog(@"付款");
    //[self orderPay];
    [BGPayStyleView showWithOrderData:self.orderData items:self.items];
}

/**
 确认收货函数
 */
-(void)confirmPayAction{
    NSLog(@"确认收货");
    [self makeSureOrder];
}

/**
 取消订单函数
 */
-(void)cancelPayAction{
    NSLog(@"取消订单");
    [self CancelOrder];
}
/**
 删除订单
 */
-(void)deleteOrder{
    NSLog(@"删除订单");
}
/**
 评价订单
 */
-(void)CommentsOrder{
    NSLog(@"评价订单");
}
/**
 创建退款按钮所在的view
 */
-(void)createRefundView{
    UIView* view = [[UIView alloc] init];
    view.frame = CGRectMake(0, CGRectGetMaxY(self.goodsTableView.frame), screenW, RefundViewH);
    self.refundView = view;
    view.backgroundColor = [UIColor whiteColor];
    UIButton* refundBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [refundBtn setTitle:@"退款" forState:UIControlStateNormal];
    refundBtn.titleLabel.font = font(26.0);
    [refundBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [refundBtn addTarget:self action:@selector(refundAction) forControlEvents:UIControlEventTouchUpInside];
    refundBtn.layer.borderWidth = 1.0;
    refundBtn.layer.borderColor = color(255.0, 0.0, 0.0, 0.2).CGColor;
    CGFloat btnW = 75;
    CGFloat btnH = 35;
    CGFloat Margin = 15;
    CGFloat x = screenW - btnW - Margin;
    refundBtn.frame = CGRectMake(x, (RefundViewH - btnH)*0.5, btnW, btnH);
    [view addSubview:refundBtn];
    [self.MyScrollView addSubview:view];
}
/**
 退款函数
 */
-(void)refundAction{
    NSLog(@"退款");
    [self dismissViewControllerAnimated:YES completion:^{}];
    //[self orderRefund];
}
/**
 获取一个初始化好的tableview
 */
-(UITableView*)getTableView{
    UITableView* tableview = [[UITableView alloc] init];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.rowHeight = tableViewCellH;
    tableview.showsVerticalScrollIndicator = NO;
    tableview.backgroundColor = color(245.0, 245.0, 245.0, 1.0);
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.scrollEnabled = NO;//禁止滑动,防止跟外面的scrollview冲突
    return tableview;
}
/**
   添加各个布局的view
 */
-(void)addView{
    CGFloat vW = screenW;//scrollview内容宽
    CGFloat vH = 0;//scrollview内容高
    CGFloat Margin = 10;
    self.MyScrollView.alwaysBounceVertical = YES;
    self.MyScrollView.showsVerticalScrollIndicator = NO;
    //创建收货信息View
    orderAdressView* AdView = [orderAdressView view];
    AdView.frame = CGRectMake(0,0, screenW, AdViewH);
    self.Adview = AdView;
    //创建添加商品详细信息tableview
    UITableView* tableview = [self getTableView];
    tableview.frame = CGRectMake(0, CGRectGetMaxY(AdView.frame) + Margin, screenW,self.orderData.item.count*tableViewCellH);
    self.goodsTableView = tableview;
    //创建快递详情部分view
    orderExpressView* expressView = [orderExpressView view];
    self.expressView = expressView;
    //根据style是否要创建退款按钮
    orderStyle style = self.orderData.style;
    if (style == WillReceive || style == WillComments) {
        [self createRefundView];
        expressView.frame = CGRectMake(0, CGRectGetMaxY(self.refundView.frame) + 0.2*Margin, screenW, ExpressViewH);
    }else{
        expressView.frame = CGRectMake(0, CGRectGetMaxY(self.goodsTableView.frame) + 0.2*Margin, screenW, ExpressViewH);
    }
    
    //创建订单号部分的view
    orderNumberView* numberView = [orderNumberView view];
    numberView.frame = CGRectMake(0, CGRectGetMaxY(expressView.frame) + Margin, screenW, NumberViewH);
    self.numberView = numberView;
    
    [self.MyScrollView addSubview:AdView];
    [self.MyScrollView addSubview:tableview];
    [self.MyScrollView addSubview:expressView];
    [self.MyScrollView addSubview:numberView];
    if (self.orderData.style == WillReceive || style == WillComments) {
       vH = AdViewH+self.orderData.item.count*tableViewCellH + ExpressViewH +NumberViewH + RefundViewH + 2.2*Margin;
    }else{
       vH = AdViewH+self.orderData.item.count*tableViewCellH + ExpressViewH +NumberViewH + 2.2*Margin;
    }
    self.MyScrollView.contentSize = CGSizeMake(vW, vH);//设置scrollview内容宽高
}


#pragma -- UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@" --- %ld",self.orderData.item.count);
    return self.orderData.item.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    goodsTableViewCell* cell = [goodsTableViewCell cellWithTableView:tableView];
    cell.orderDataItem = self.orderData.item[indexPath.row];
    return cell;
    
}

#pragma -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中
}


@end
