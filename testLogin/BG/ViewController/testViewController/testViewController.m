//
//  testViewController.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/17.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "testViewController.h"
#import "UIView+AutoLayout.h"
#import "BGAFN.h"
#import "global.h"
#import "NSString+Md5SignString.h"
#import "MyOrderModel.h"
#import "MyOrderModel_item.h"

@interface testViewController ()

@property(nonatomic,strong)BGAFN* BGAFNet;

- (IBAction)back:(id)sender;
- (IBAction)getOrderLists:(id)sender;

@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(BGAFN *)BGAFNet{
    if (_BGAFNet == nil) {
        _BGAFNet = [[BGAFN alloc] init];
    }
    return _BGAFNet;
}

/**
 根据用户id调取其订单列表，按照下单时间降序排序
 */
#warning ----- 未完成
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
        for(NSDictionary* di in arr){
        MyOrderModel* good = [MyOrderModel objectWithKeyValues:di];
            NSLog(@"子数量 ＝ %d",good.item.count);
        }
        //MyOrderModel_item* item = good.item[0];
        //NSLog(@"订单列表 = %@,%@,%@",good.order_id,good.itemnum,item.goods_pic[@"m_url"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"订单列表--error--%@",error);
    }];

    
}
/**
 退出
 */
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 
                             }];
}

- (IBAction)getOrderLists:(id)sender {
    [self getMyOrderLists];
}
@end
