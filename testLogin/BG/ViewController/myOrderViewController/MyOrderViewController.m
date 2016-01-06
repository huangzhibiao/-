//
//  MyOrderViewController.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/9.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderTopTabBar.h"
#import "global.h"
#import "orderstyleCell.h"
#import "orderCommonData.h"
#import "GoodsOrderViewController.h"

#import "BGAFN.h"
#import "MyOrderModel.h"
#import "MyOrderModel_item.h"
#import "NSString+Md5SignString.h"

#define CellH ([global pxTopt:110.0] + [global pxTopt:191.0]*3 + [global pxTopt:1.0]*3)

@interface MyOrderViewController ()<MyOrderTopTabBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray* orderDatas;//存放模型数据的数组

@property(nonatomic,weak)UITableView* MyTableView;
@property(nonatomic,weak)MyOrderTopTabBar* TopTabBar;

@property(nonatomic,strong)BGAFN* BGAFNet;
@property(nonatomic,strong)NSMutableArray* orderLists;//存放订单模型

@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initTopTabbar];//初始化顶部tabbar
    [self initMyTableView];
    [self getMyOrderLists];
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
 初始化存放订单模型
 */
-(NSMutableArray *)orderLists{
    if (_orderLists == nil) {
        _orderLists = [[NSMutableArray alloc] init];
    }
    return _orderLists;
}

-(NSMutableArray *)orderDatas{
    if (_orderDatas == nil) {
        _orderDatas = [[NSMutableArray alloc] init];
    }
    return _orderDatas;
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
    tableview.backgroundColor = color(239.0, 239.0, 239.0, 1.0);
    CGFloat Y = CGRectGetMaxY(self.TopTabBar.frame);
    CGRect rect = CGRectMake(0, Y, screenW,screenH-Y);
    tableview.frame = rect;
    self.MyTableView = tableview;
    [self.view addSubview:tableview];
}

#pragma -- UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"视频总数.......%d",self.myFrameStatus.count);
    return self.orderDatas.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    orderstyleCell* cell = [orderstyleCell cellWithTableView:tableView];
    cell.data = self.orderDatas[indexPath.row];
    //[cell setCellViewFrame];//设置cell里面view的frame
    
    return cell;
    
}

#pragma -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [self.MyTableView deselectRowAtIndexPath:indexPath animated:NO];//取消选中
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  CellH;
}

#pragma -- MyOrderTopTabBarDelegate(顶部标题栏delegate)
-(void)tabBar:(MyOrderTopTabBar *)tabBar didSelectIndex:(NSInteger)index{
    NSLog(@"点击了 －－－ %ld",index);
    [self selectData:index];
}

/**
 获取网络订单列表
 */
/**
 根据用户id调取其订单列表，按照下单时间降序排序
 */
#warning ----- 测试阶段
-(void)getMyOrderLists{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[member_idKey] = @([global intance].member_id);
    dict[accesstokenKey] = [global intance].accesstoken;
    dict[@"page_size"] = @(100);
    dict[methodKey] = @"b2c.member.get_order_list";
    dict[signKey] = [NSString sign:dict];
    
    [self.BGAFNet requestWithDict:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dict = responseObject[@"data"];
        NSArray* arr = dict[@"orderData"];
        [self tranlatesWithArray:arr];
        //MyOrderModel_item* item = good.item[0];
        //NSLog(@"订单列表 = %@,%@,%@",good.order_id,good.itemnum,item.goods_pic[@"m_url"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"订单列表--error--%@",error);
    }];
    
    
}
/**
 转换类型
 */
-(void)tranlatesWithArray:(NSArray*)arr{
    for(NSDictionary* di in arr){
        MyOrderModel* good = [MyOrderModel objectWithKeyValues:di];
        if ([good.pay_status isEqualToString:@"未支付"]) {
            good.style = WillPay;
        }else if ([good.pay_status isEqualToString:@"已支付"] && [good.ship_status isEqualToString:@"未发货"]){
            good.style = WillSend;
        }else if ([good.pay_status isEqualToString:@"已支付"] && [good.ship_status isEqualToString:@"已发货"]){
            good.style = WillReceive;
        }else if([good.pay_status isEqualToString:@"已支付"] && [good.ship_status isEqualToString:@"已收货未评价"]){
            good.style = WillComments;
        }else;
        [self.orderLists addObject:good];
    }
    [self selectData:0];
}
/**
 最终筛选数据
 */
-(void)selectData:(NSInteger)index{
    if (index == 0) {
        if (self.orderDatas.count >0) {
            [self.orderDatas removeAllObjects];
        }
        for(MyOrderModel* data in self.orderLists){
            [self.orderDatas addObject:data];
        }
    }else if (index == 1){
        if (self.orderDatas.count >0) {
            [self.orderDatas removeAllObjects];
        }
        for(MyOrderModel* data in self.orderLists){
            if (data.style == WillPay) {
                [self.orderDatas addObject:data];
            }
        }
    }else if (index == 2){
        if (self.orderDatas.count >0) {
            [self.orderDatas removeAllObjects];
        }
        for(MyOrderModel* data in self.orderLists){
            if (data.style == WillSend) {
                [self.orderDatas addObject:data];
            }
        }
    }else if (index == 3){
        if (self.orderDatas.count >0) {
            [self.orderDatas removeAllObjects];
        }
        for(MyOrderModel* data in self.orderLists){
            if (data.style == WillReceive) {
                [self.orderDatas addObject:data];
            }
        }
    }else if (index == 4){
        if (self.orderDatas.count >0) {
            [self.orderDatas removeAllObjects];
        }
        for(MyOrderModel* data in self.orderLists){
            if (data.style == WillComments) {
                [self.orderDatas addObject:data];
            }
        }
    }else;
    [self.MyTableView reloadData];
}

@end
