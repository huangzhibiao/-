//
//  BGOrderViewController.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/23.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "BGOrderViewController.h"
#import "MyOrderTopTabBar.h"
#import "global.h"
#import "BGAFN.h"
#import "MyOrderModel.h"
#import "BGOrderFrame.h"
#import "NSString+Md5SignString.h"
#import "BGOrderFirstCell.h"
#import "GoodsOrderViewController.h"
#import "BGPayStyleView.h"
#import "payStyleViewCellData.h"
#import "MBProgressHUD+MJ.h"

@interface BGOrderViewController ()<MyOrderTopTabBarDelegate,UITableViewDataSource,UITableViewDelegate,BGOrderFirstCellDelegate>

@property(nonatomic,weak)UITableView* MyTableView;
@property(nonatomic,weak)MyOrderTopTabBar* TopTabBar;
@property(nonatomic,assign)NSInteger topTabBarIndex;//实时记录顶部tabbar的点击位置
@property(nonatomic,weak)UIActivityIndicatorView* indicator;//网络请求指示器
@property(nonatomic,strong)BGAFN* BGAFNet;
@property(nonatomic,strong)NSMutableArray* orderLists;//存放全部订单模型数组
@property(nonatomic,strong)NSMutableArray* diffentOrderLists;//存放全部不同类型的订单模型数组
@property(nonatomic,strong)MyOrderModel* tempOrderData;//临时存储订单数据
/**
 存放支付item的模型数据
 */
@property(nonatomic,strong)NSArray* items;

@end

@implementation BGOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTopTabbar];
    [self initMyTableView];
    [self getMyOrderLists];
    [self.indicator startAnimating];//指示正在网络请求
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 监听一个订单状态刷新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationStyle:) name:BG_ORDER_STATUS_NPTIFICATION object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"BGOrderViewController - 移除通知");
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
 初始化存放订单模型数组
 */
-(NSMutableArray *)orderLists{
    if (_orderLists == nil) {
        _orderLists = [[NSMutableArray alloc] init];
    }
    return _orderLists;
}
/**
 初始化存放全部不同类型的订单模型数组
 */
-(NSMutableArray *)diffentOrderLists{
    if (_diffentOrderLists == nil) {
        _diffentOrderLists = [[NSMutableArray alloc] init];
    }
    return _diffentOrderLists;
}
/**
 初始化网络请求指示器
 */
-(UIActivityIndicatorView *)indicator{
    if (_indicator == nil) {
        UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] init];
        [UIActivityIndicatorView setAnimationsEnabled:YES];
        indicator.color = color(0.0,162.0,154.0,1.0);
        CGFloat W = 20.0;
        CGFloat H = 20.0;
        indicator.frame = CGRectMake((screenW-W)*0.5,(screenH-H)*0.5, W,H);
        _indicator = indicator;
        indicator.hidesWhenStopped = YES;
        [self.view addSubview:indicator];
    }
    return _indicator;

}
/**
 初始化顶部tabbar并添加到self.view中
 */
-(void)initTopTabbar{
    NSArray* array  = @[@"全部",@"待付款",@"待发货",@"待收货",@"待评价"];
    MyOrderTopTabBar* tabBar = [[MyOrderTopTabBar alloc] initWithArray:array] ;
    tabBar.frame = CGRectMake(0, 20, screenW, [global pxTopt:100]);
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.delegate = self;
    self.TopTabBar = tabBar;
    [self.view addSubview:tabBar];
}
/**
 初始化MyTableView
 */
-(void)initMyTableView{
    UITableView* tableview = [[UITableView alloc] init];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.showsVerticalScrollIndicator = NO;
    tableview.backgroundColor = color(245.0, 245.0, 245.0, 1.0);
    CGFloat Y = CGRectGetMaxY(self.TopTabBar.frame);
    CGRect rect = CGRectMake(0, Y, screenW,screenH-Y);
    tableview.frame = rect;
    self.MyTableView = tableview;
    [self.view addSubview:tableview];
}
/**
 根据字符串判别通知类型
 */
-(void)notificationStyle:(NSNotification*)dict{
    NSString* object = dict.object;
    if ([getMyOrderLists isEqualToString:object]) {
        [self getMyOrderLists];
    }else if ([paySucc isEqualToString:object]){
        [self orderPay];
    }else;
}

/**
 根据用户id调取其订单列表，按照下单时间降序排序
 */
-(void)getMyOrderLists{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[member_idKey] = @([global intance].member_id);
    dict[accesstokenKey] = [global intance].accesstoken;
    dict[@"page_size"] = @(100);
    dict[methodKey] = get_order_list;
    dict[signKey] = [NSString sign:dict];
    [self.BGAFNet requestWithDict:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicator stopAnimating];////停止指示网络请求
        });
        NSDictionary* dict = responseObject[@"data"];
        NSArray* arr = dict[@"orderData"];
        int pager_total = [dict[@"pager_total"] intValue];
        if(0 == pager_total)return;//没有数据的返回,不作处理
        //NSLog(@"订单列表----%@",dict);
        [self tranlatesWithArray:arr];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"订单列表--error--%@",error);
    }];
    
    
}
/**
 转换类型
 */
-(void)tranlatesWithArray:(NSArray*)arr{
    if (self.diffentOrderLists.count >0) {
        [self.diffentOrderLists removeAllObjects];
    }
    
    for(NSDictionary* di in arr){
        MyOrderModel* good = [MyOrderModel objectWithKeyValues:di];
            //全额退款
        //NSLog(@"支付状态 - %@  发货状态 － %@  订单状态 - %@",good.pay_status,good.ship_status,good.status);
        if ([good.status isEqualToString:@"活动订单"]) {
            if ([good.pay_status isEqualToString:@"未支付"]) {
                good.style = WillPay;
            }else if ([good.pay_status isEqualToString:@"已支付"] && [good.ship_status isEqualToString:@"未发货"]){
                good.style = WillSend;
            }else if ([good.pay_status isEqualToString:@"已支付"] && [good.ship_status isEqualToString:@"已发货"]){
                good.style = WillReceive;
            }else;
        }else if ([good.status isEqualToString:@"已作废"]){
            continue;
        }else if ([good.status isEqualToString:@"已完成"]){
            good.style = WillComments;
        }else;
        BGOrderFrame* orderFrame = [[BGOrderFrame alloc] init];
        orderFrame.orderData = good;
        [self.diffentOrderLists addObject:orderFrame];
        [self selectData:self.topTabBarIndex];
    }
}

/**
 筛选不同类型的订单
 */
-(void)selectData:(NSInteger)index{
    if (self.orderLists.count >0) {
        [self.orderLists removeAllObjects];
    }
    
    if (index == 0) {
        for(BGOrderFrame* data in self.diffentOrderLists){
            [self.orderLists addObject:data];
        }
    }else if (index == 1){
        for(BGOrderFrame* data in self.diffentOrderLists){
            if (data.orderData.style == WillPay) {
                [self.orderLists addObject:data];
            }
        }
    }else if (index == 2){
        for(BGOrderFrame* data in self.diffentOrderLists){
            if (data.orderData.style == WillSend) {
                [self.orderLists addObject:data];
            }
        }
    }else if (index == 3){
        for(BGOrderFrame* data in self.diffentOrderLists){
            if (data.orderData.style == WillReceive) {
                [self.orderLists addObject:data];
            }
        }
    }else if (index == 4){
        for(BGOrderFrame* data in self.diffentOrderLists){
            if (data.orderData.style == WillComments) {
                [self.orderLists addObject:data];
            }
        }
    }else;
    [self.MyTableView reloadData];//刷新数据
}

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


#pragma -- UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderLists.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BGOrderFirstCell* cell = [BGOrderFirstCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.orderFrame = self.orderLists[indexPath.row];
    return cell;
    
}

#pragma -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BGOrderFrame* orderFrame = self.orderLists[indexPath.row];
    MyOrderModel* good = orderFrame.orderData;
    return  good.item.count*topViewCellH + BGOFMiddleViewH +BGOFBottomViewH + BGOFMargin +1.0;
}

#pragma -- MyOrderTopTabBarDelegate(顶部标题栏delegate)
-(void)tabBar:(MyOrderTopTabBar *)tabBar didSelectIndex:(NSInteger)index{
    [self selectData:index];
    self.topTabBarIndex = index;
    NSLog(@"点击了 －－－ %ld",index);
}

#pragma BGOrderFirstCellDelegate 
/**
 第二层tableview的点击监听
 */
-(void)selectCell:(BGOrderFrame *)OrderFrame index:(NSInteger)index{
    GoodsOrderViewController* con = [[GoodsOrderViewController alloc] init];
    con.orderData = OrderFrame.orderData;
    [self presentViewController:con animated:YES completion:^{

    }];
    //NSLog(@"%@  ,  %ld",item.goods_name,index);
}
/**
 第一层第一个按钮的监听
 */
-(void)clickFirstBtn:(BGOrderFrame *)OrderFrame{
    NSLog(@"第一个按钮 - 弹出付费方式选择%@",OrderFrame);
    self.tempOrderData = OrderFrame.orderData;
    if (OrderFrame.orderData.style == WillSend){//待发货
        [MBProgressHUD showSuccess:@"提醒发货成功"];
    }else if (OrderFrame.orderData.style == WillPay){//待付款
        [BGPayStyleView showWithOrderData:OrderFrame.orderData items:self.items];
    }else if(OrderFrame.orderData.style == WillReceive){//待收货
        [self makeSureOrder];
    }else if(OrderFrame.orderData.style == WillComments){//待评价
        
    }else;
}
/**
 第一层第二个按钮的监听
 */
-(void)clickSecondBtn:(BGOrderFrame *)OrderFrame{
    NSLog(@"第二个按钮 - %@",OrderFrame);
    self.tempOrderData = OrderFrame.orderData;
    if (OrderFrame.orderData.style == WillPay){//待付款
        [self CancelOrder];
    }else if(OrderFrame.orderData.style == WillComments){//待评价
        NSLog(@"删除订单");
    }else;
}
//以下---------后台网络请求函数----------
/**
 添加订单支付单(即通知后台支付了)
 */
#warning -- 测试阶段 - 待验证
-(void)orderPay{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"order_bn"] = self.tempOrderData.order_id;
    dict[@"payment_id"] = @"111111222aaabbb";
    dict[@"money"] = self.tempOrderData.amount;
    dict[@"cur_money"] = self.tempOrderData.amount;
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
        [self getMyOrderLists];//重新请求刷新订单数据
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
 修改订单通用接口
 */
-(void)updateOrderStatus:(NSString*)status message:(NSString*)message{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"order_bn"] = self.tempOrderData.order_id;
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
        [self getMyOrderLists];//重新请求刷新订单数据
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@--error--%@",message,error);
    }];
    
}
@end
