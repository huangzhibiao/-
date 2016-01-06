//
//  ViewController.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/3.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "ViewController.h"
#import "BGAFN.h"
#import "global.h"
#import "NSString+Md5SignString.h"
#import "NSString+Md5String.h"
#import "shopInfoViewControoler.h"
#import "MemberInfo.h"
#import "GoodsOrderViewController.h"
#import "MyOrderViewController.h"
#import "JSWebViewController.h"
#import "testViewController.h"
#import "ShipAddress.h"
#import "ShipExpressStyle.h"
#import "BuyViewController.h"
#import "BGOrderViewController.h"

#import "BGLuckViewController.h"


@interface ViewController ()

@property(nonatomic,strong)BGAFN* BGAFNet;

@property(nonatomic,strong)ShipAddress* shipAddress;
- (IBAction)MyOrderAction:(id)sender;


/**
 存放地址数组
 */
@property(nonatomic,strong)NSMutableArray* addressLists;
@property(nonatomic,copy)NSString* lost_token;//找回密码的token


- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *uname;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)getMemberInfo:(id)sender;
- (IBAction)send_signup_sms:(id)sender;
- (IBAction)sms_ok:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *telphoneMenber;
@property (weak, nonatomic) IBOutlet UITextField *signMenber;
@property (weak, nonatomic) IBOutlet UITextField *signupPassword;
- (IBAction)sendSmsFindPassWork:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *findPassworkphone;
@property (weak, nonatomic) IBOutlet UITextField *findPassworkVcode;
- (IBAction)findPassworkOk:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *xinPasswork;
- (IBAction)XinPassworkOk:(id)sender;
- (IBAction)nextPage:(id)sender;
- (IBAction)nextOption:(id)sender;

- (IBAction)createOrder:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //NSLog(@"屏幕高度 ＝ %f  view高 = %f",screenH,self.view.frame.size.height);
}

-(NSMutableArray *)addressLists{
    if (_addressLists == nil) {
        _addressLists = [[NSMutableArray alloc] init];
    }
    return _addressLists;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

-(BGAFN *)BGAFNet{
    if (_BGAFNet == nil) {
        _BGAFNet = [[BGAFN alloc] init];
    }
    return _BGAFNet;
}

- (IBAction)login:(id)sender {
    [self.BGAFNet loginWithName:self.uname.text password:self.password.text method:get_encrypt_params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"login-----all------%@",responseObject);
        NSLog(@"login-----------%@",[responseObject[dataKey] objectForKey:messageKey]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error------%@",error);
    }];
}


- (IBAction)getMemberInfo:(id)sender {
    [self.BGAFNet getmemberInfoWithID:[global intance].member_id method:get_member_info success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //MemberInfo* info = [MemberInfo objectWithKeyValues:responseObject[dataKey]];
        NSLog(@"获取会员信息-----------%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取会员信息error------%@",error);
    }];
}

- (IBAction)send_signup_sms:(id)sender {
    [self.BGAFNet requestWithValue:self.telphoneMenber.text forKey:mobileKey method:send_signup_sms success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"手机号发送验证码-----------%@",[responseObject[@"data"] objectForKey:messageKey]);
    NSLog(@"手机号发送验证码-----------%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"手机号发送验证码error------%@",error);
    }];
}

- (IBAction)sms_ok:(id)sender {
    NSString* createTime = [global getCurrentTime];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[unameKey] = self.telphoneMenber.text;
    dict[passwordKey] = [NSString md5SignStringWithPasswd:self.signupPassword.text uname:self.telphoneMenber.text createtime:createTime];
    dict[createtimeKey]  = createTime;
    dict[vcodeKey] = self.signMenber.text;
    dict[methodKey] = signup;
    dict[signKey] = [NSString sign:dict];
    [self.BGAFNet requestWithDict:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"手机注册-----%@",responseObject);
        NSLog(@"手机注册-----%@",[responseObject[@"data"] objectForKey:messageKey]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"手机注册error-----%@",error);
    }];
}
- (IBAction)sendSmsFindPassWork:(id)sender {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[mobileKey] = self.findPassworkphone.text;
    dict[methodKey] = lost_send_vcode;
    dict[signKey] = [NSString sign:dict];
    
    [self.BGAFNet requestWithDict:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"发送找回密码验证码-----%@",responseObject);
        NSLog(@"发送找回密码验证码-----%@",[responseObject[@"data"] objectForKey:messageKey]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发送找回密码验证码error-----%@",error);
    }];

}

- (IBAction)findPassworkOk:(id)sender {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[mobileKey] = self.findPassworkphone.text;
    dict[vcodeKey] = self.findPassworkVcode.text;
    dict[methodKey] = lost_verify_vcode;
    dict[signKey] = [NSString sign:dict];
    
    [self.BGAFNet requestWithDict:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dict = responseObject[@"data"];
        NSLog(@"找回密码验证-----%@",responseObject);
        NSLog(@"找回密码验证-----%@",[dict objectForKey:messageKey]);
        NSString* rsp = responseObject[rspKey];
        if ([rsp isEqualToString:fail]) {
            return ;
        }
        self.lost_token = [dict objectForKey:lost_tokenKey];
        [global intance].member_id = [[dict objectForKey:member_idKey] intValue];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"找回密码验证error-----%@",error);
    }];
}
- (IBAction)XinPassworkOk:(id)sender {
//    NSDate* date = [[NSDate alloc] init];
//    NSTimeInterval time = [date timeIntervalSince1970];
//    NSString* createTime = [NSString stringWithFormat:@"%ld",(long)time];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[member_idKey] = @([global intance].member_id);
    dict[lost_tokenKey] = self.lost_token;
    dict[passwordKey] = [NSString md5SignStringWithPasswd:self.xinPasswork.text uname:self.telphoneMenber.text createtime:[global intance].createtime];
    dict[methodKey] = lost_reset_password;
    dict[signKey] = [NSString sign:dict];
    
    [self.BGAFNet requestWithDict:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dict = responseObject[@"data"];
        NSLog(@"重设密码-----%@",responseObject);
        NSLog(@"重设密码-----%@ － token = %@",[dict objectForKey:messageKey],self.lost_token);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"重设密码error-----%@",error);
    }];

}

- (IBAction)nextPage:(id)sender {
    //BGLuckViewController* con = [[BGLuckViewController alloc] init];
    //shopInfoViewControoler* con = [[shopInfoViewControoler alloc] init];
    BuyViewController* con = [[BuyViewController alloc] init];
    [self presentViewController:con animated:YES completion:^{
        
    }];
}

- (IBAction)nextOption:(id)sender {
    BGOrderViewController* order = [[BGOrderViewController alloc] init];
    //testViewController* order = [[testViewController alloc] init];
    [self presentViewController:order animated:YES completion:^{
        
    }];
}
/**
 创建订单
 */
- (IBAction)createOrder:(id)sender {
    NSMutableDictionary* dictM = [[NSMutableDictionary alloc] init];
    dictM[methodKey] = @"b2c.member.get_address";
    dictM[member_idKey] = @([global intance].member_id);
    dictM[accesstokenKey] = [global intance].accesstoken;
    dictM[signKey] = [NSString sign:dictM];
    [self.BGAFNet requestWithDict:dictM success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray* arr = responseObject[dataKey];
        for(NSDictionary* dict in arr){
            NSArray* areaArr = [dict[@"ship_area"] componentsSeparatedByString:@":"];
            ShipAddress* ship = [ShipAddress objectWithKeyValues:dict];
            ship.ship_area = areaArr[1];
            ship.area_id = areaArr[2];
            [self.addressLists addObject:ship];
        }
        for(ShipAddress* add in self.addressLists){
            if ([add.is_default isEqualToString:@"true"]) {
                self.shipAddress = add;
                [self getExpressStyle];
                break;
            }
        }
       // NSLog(@"查询收货地址-----%@",self.addressLists[0]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"查询收货地址error-----%@",error);
    }];
}
/**
 购物车里的货物全部开始下单
 */
-(void)beginOrder:(ShipExpressStyle*)exStyle{
    NSMutableDictionary* dictM = [[NSMutableDictionary alloc] init];
    dictM[methodKey] = @"cerp.order.erp_create";
    dictM[@"address_id"] = self.shipAddress.ship_id;
    dictM[@"area_id"] = self.shipAddress.area_id;
    dictM[@"shipping_id"] = exStyle.dt_id;
    dictM[@"payment_pay_app_id"] = @"alipay";
    dictM[@"memo"] = @"购买测试";
    dictM[member_idKey] = @([global intance].member_id);
    dictM[accesstokenKey] = [global intance].accesstoken;
    dictM[signKey] = [NSString sign:dictM];
    NSLog(@"%@",dictM);
    [self.BGAFNet PostRequestWithDict:dictM success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"下单-----%@",responseObject);
        NSLog(@"下单--res---%@",responseObject[@"res"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下单error-----%@",error);
    }];

}
/**
 获取物流信息
 */
-(void)getExpressStyle{
    NSMutableDictionary* dictM = [[NSMutableDictionary alloc] init];
    dictM[methodKey] = @"cerp.order.getShipMethod";
    dictM[member_idKey] = @([global intance].member_id);
    dictM[accesstokenKey] = [global intance].accesstoken;
    dictM[signKey] = [NSString sign:dictM];
    [self.BGAFNet requestWithDict:dictM success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([succ isEqualToString:responseObject[rspKey]]) {
            NSArray* arr = responseObject[dataKey];
            NSDictionary* dict = [arr lastObject];
            ShipExpressStyle* ex = [ShipExpressStyle objectWithKeyValues:dict];
            [self beginOrder:ex];
            //NSLog(@"dt_id:%@,dt_name:%@,has_cod:%@,money:%@",dict[@"dt_id"],dict[@"dt_name"],dict[@"has_cod"],dict[@"money"]);
        }else{
            NSLog(@"获取物流信息---失败");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取物流信息error-----%@",error);
    }];

}
/**
 固定数据测试下单
 */
- (IBAction)MyOrderAction:(id)sender {
    [self getAllOrderList];
}
-(void)myordertest{
    NSMutableDictionary* dictM = [[NSMutableDictionary alloc] init];
    dictM[methodKey] = @"cerp.order.erp_create";
    dictM[@"address"] = @"{\"addr_id\":6}";
    dictM[@"shipping_id"] = @"{\"id\":1,\"has_cod\":\"false\",\"dt_name\":\"圆通速递\",\"money\":8}";
    dictM[@"payment[currency]"] = @"CNY";
    dictM[@"payment[pay_app_id]"] = @"{\"pay_app_id\":\"alipay\",\"payment_name\":\"支付宝\"}";
    dictM[@"memo"] = @"测试订单";
    //    dictM[@"direct"] = @"true";
    dictM[member_idKey] = [NSString stringWithFormat:@"%ld",[global intance].member_id];
    dictM[accesstokenKey] = [global intance].accesstoken;
    dictM[signKey] = [NSString sign:dictM];
    NSLog(@"%@",dictM);
    [self.BGAFNet PostRequestWithDict:dictM success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"下单-----%@",responseObject);
        NSLog(@"下单--res---%@",responseObject[@"res"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下单error-----%@",error);
    }];

}
/**
 根据member_id获取订单列表
 */
-(void)getAllOrderList{
    NSMutableDictionary* dictM = [[NSMutableDictionary alloc] init];
    dictM[methodKey] = @"b2c.member.get_order_list";
    dictM[member_idKey] = @([global intance].member_id);
    dictM[accesstokenKey] = [global intance].accesstoken;
    dictM[signKey] = [NSString sign:dictM];
    [self.BGAFNet requestWithDict:dictM success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([succ isEqualToString:responseObject[rspKey]]) {
            NSArray* arr = responseObject[dataKey];
            NSLog(@"订单列表 -- %@",arr);
        }else{
            NSLog(@"获取订单列表---失败");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取订单列表error-----%@",error);
    }];
}
@end
