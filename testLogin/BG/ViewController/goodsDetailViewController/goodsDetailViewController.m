//
//  goodsDetailViewController.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/7.
//  Copyright © 2015年 haiwang. All rights reserved.
//
/**
 支付宝相关头文件
 */
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"
/**
 其他相关头文件
 */
#import "goodsDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"
#import "NSString+Md5SignString.h"
#import "global.h"
#import "SkusModel.h"
#import "BGAFN.h"
#import "ShipAddress.h"
#import "ShipExpressStyle.h"
#import "BGShoppingCarInfo.h"
#import "BGShoppingCarItemInfo.h"
#import "BGGoodsCommentInfo.h"

@interface goodsDetailViewController ()<NSXMLParserDelegate>

@property(nonatomic,strong)BGAFN* BGAFNet;

@property (nonatomic, strong) NSMutableArray *dataList;//存放xml中解析出来的商品详情链接
@property (weak, nonatomic) IBOutlet UILabel *input_src;
@property (weak, nonatomic) IBOutlet UIScrollView *MyScrollView;

@property(nonatomic,strong) SkusModel* skus;
/**
 存放地址数组
 */
@property(nonatomic,strong)NSMutableArray* addressLists;
@property(nonatomic,strong)ShipAddress* shipAddress;

- (IBAction)back:(id)sender;
- (IBAction)buy:(id)sender;
- (IBAction)addToShoppingCar:(id)sender;
- (IBAction)shoppingCarClear:(id)sender;
- (IBAction)getShoppingCarAction:(id)sender;
- (IBAction)getCommentsAction:(id)sender;


@end

@implementation goodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self startParseXMLWithString:self.goodsDetails.descriptions];
    self.input_src.text = [NSString stringWithFormat:@"    %@",self.goodsDetails.input_str];
    
    NSArray* arr = [global dictionaryWithJsonString:self.goodsDetails.skus];
    SkusModel* skus = [SkusModel objectWithKeyValues:[arr lastObject]];
    self.skus = skus;
    //NSLog(@"商品id ＝ %@",skus);
}
-(BGAFN *)BGAFNet{
    if (_BGAFNet == nil) {
        _BGAFNet = [[BGAFN alloc] init];
    }
    return _BGAFNet;
}
-(NSMutableArray *)addressLists{
    if (_addressLists == nil) {
        _addressLists = [[NSMutableArray alloc] init];
    }
    return _addressLists;
}
/**
 b2c.member.get_cart_info 根据会员ID获取购物车信息
 */
-(void)getShoppingCarInfo{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[member_idKey]  = @([global intance].member_id);
    dict[accesstokenKey] = [global intance].accesstoken;
    dict[methodKey] = @"b2c.member.get_cart_info";
    dict[signKey] = [NSString sign:dict];
    [self.BGAFNet requestWithDict:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"购物车信息-----%@",responseObject);
        if([fail isEqualToString:responseObject[rspKey]])return;//失败则返回
        NSDictionary* dict = responseObject[dataKey];
        BGShoppingCarInfo* carInfo = [BGShoppingCarInfo objectWithKeyValues:dict];
        NSArray* arr = responseObject[dataKey][@"object"][@"goods"];
        NSMutableArray* arrM = [[NSMutableArray alloc] init];
        for(NSDictionary* di in arr){
            BGShoppingCarItemInfo *carInfoItem = [BGShoppingCarItemInfo objectWithKeyValues:di];
            [arrM addObject:carInfoItem];
        }
        carInfo.allGoods = arrM;
        //NSLog(@"购物车信息-----%@",responseObject[dataKey][messageKey]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"购物车信息---error--%@",error);
    }];

}
/**
 添加到购物车 - 立即购买 －》 isfastbuy ＝ true 其它是false
 */
-(void)addShoppingCar:(NSString*)isfastbuy{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[member_idKey]  = @([global intance].member_id);
    dict[accesstokenKey] = [global intance].accesstoken;
    dict[@"goods_id"] = self.skus.iid;
    dict[@"product_id"] = self.skus.sku_id;
    dict[@"num"] = @(1);
    dict[@"isfastbuy"] = isfastbuy;
    dict[methodKey] = @"b2c.member.add_cart";
    dict[signKey] = [NSString sign:dict];
    [self.BGAFNet requestWithDict:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"添加到购物车-----%@",responseObject);
        NSLog(@"添加到购物车-----%@",responseObject[dataKey][messageKey]);
        if ([succ isEqualToString:responseObject[rspKey]] && [isfastbuy isEqualToString:@"true"]) {
            [self createOrder];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"添加到购物车---error--%@",error);
    }];

}
/**
 b2c.member.remove_cart 清除购物车信息购物车信息
 */
-(void)clearShoppingCar:(NSDictionary*)info{
    NSMutableDictionary* dictM = [[NSMutableDictionary alloc] init];
    
    NSString* removeAll = info[@"remove_all"];
    dictM[@"remove_all"] = removeAll;
    if (![removeAll isEqualToString:@"true"]) {
        dictM[@"goods_id"] = info[@"goods_id"];
        dictM[@"product_id"] = info[@"product_id"];
        dictM[@"num"] = info[@"num"];
    }    
    dictM[methodKey] = @"b2c.member.remove_cart";
    dictM[member_idKey] = @([global intance].member_id);
    dictM[accesstokenKey] = [global intance].accesstoken;
    dictM[signKey] = [NSString sign:dictM];
    [self.BGAFNet requestWithDict:dictM success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"清除购物车 --- %@ -- %@",responseObject,responseObject[dataKey][messageKey]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"清除购物车error-----%@",error);
    }];

}
#pragma  -- 以下是下单流程
/**
 创建订单 － 首先获取地址信息
 */
- (void)createOrder{
    NSMutableDictionary* dictM = [[NSMutableDictionary alloc] init];
    dictM[methodKey] = @"b2c.member.get_address";
    dictM[member_idKey] = @([global intance].member_id);
    dictM[accesstokenKey] = [global intance].accesstoken;
    dictM[signKey] = [NSString sign:dictM];
    [self.BGAFNet requestWithDict:dictM success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"获取地址 --- %@",responseObject);
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
 购物车里的货物全部开始下单  立即购买 －》 isfastbuy ＝ true 其它是false
 */
-(void)beginOrder:(ShipExpressStyle*)exStyle isfastbuy:(NSString*)isfastbuy{
    NSMutableDictionary* dictM = [[NSMutableDictionary alloc] init];
    dictM[methodKey] = @"cerp.order.erp_create";
    dictM[@"address_id"] = self.shipAddress.ship_id;
    dictM[@"area_id"] = self.shipAddress.area_id;
    dictM[@"shipping_id"] = exStyle.dt_id;
    dictM[@"payment_pay_app_id"] = @"alipay";
    dictM[@"memo"] = @"购买测试";
    dictM[@"isfastbuy"] = isfastbuy;
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
    dictM[@"area_id"] = self.shipAddress.area_id;
    dictM[methodKey] = @"b2c.member.get_dlytype";//@"cerp.order.getShipMethod";
    dictM[member_idKey] = @([global intance].member_id);
    dictM[accesstokenKey] = [global intance].accesstoken;
    dictM[signKey] = [NSString sign:dictM];
    [self.BGAFNet requestWithDict:dictM success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"获取物流信息--%@",responseObject);
        if ([succ isEqualToString:responseObject[rspKey]]) {
            NSDictionary* dict = responseObject[dataKey][@"50.1"];
            //NSDictionary* dict = //[arr lastObject];
            ShipExpressStyle* ex = [ShipExpressStyle objectWithKeyValues:dict];
            [self beginOrder:ex isfastbuy:@"true"];
        }else{
            NSLog(@"获取物流信息---失败");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取物流信息error-----%@",error);
    }];
    
}
/**
 b2c.member.get_cat_comments 根据商品ID获取评论列表 默认分页大小是10
 */
-(void)getComments:(NSInteger)page{
    NSMutableDictionary* dictM = [[NSMutableDictionary alloc] init];
    
    dictM[member_idKey] = @([global intance].member_id);
    dictM[@"goods_id"] = self.skus.iid;
    dictM[@"page_no"] = @(page);
    dictM[@"page_size"] = @(10);
    dictM[methodKey] = @"b2c.member.get_cat_comments";
    dictM[member_idKey] = @([global intance].member_id);
    dictM[accesstokenKey] = [global intance].accesstoken;
    dictM[signKey] = [NSString sign:dictM];
    [self.BGAFNet requestWithDict:dictM success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"评论列表--%@",responseObject);
        NSDictionary* dicts = responseObject[dataKey][@"discuss"];
        for(NSString* key in dicts.keyEnumerator){
            BGGoodsCommentInfo* comment = [BGGoodsCommentInfo objectWithKeyValues:dicts[key]];
            NSLog(@"key - %@",[key class]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"评论列表error-----%@",error);
    }];

}
-(void)addImageView{
    CGFloat ivW = screenW;
    CGFloat ivH = ivW*0.888;
    NSInteger imgCount = self.dataList.count;
    for(int i=0;i<imgCount;i++){
        UIImageView *iv = [[UIImageView alloc] init];
        CGRect rec = CGRectMake(0, ivH*i, ivW, ivH);
        iv.frame = rec;
        [iv sd_setImageWithURL:[NSURL URLWithString:self.dataList[i]] placeholderImage:nil];
        [_MyScrollView addSubview:iv];
    }
    _MyScrollView.contentSize = CGSizeMake(ivW, ivH*imgCount);
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
/**
 测试购买
 */
- (IBAction)buy:(id)sender {
    
    //[self AliPay];//支付宝支付
    [self addShoppingCar:@"true"];//立即购买
    //[self createOrder];
}

- (IBAction)addToShoppingCar:(id)sender {
    [self addShoppingCar:@"false"];
}

- (IBAction)shoppingCarClear:(id)sender {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    dict[@"remove_all"] = @"false";
    dict[@"goods_id"] = self.skus.iid;
    dict[@"product_id"] = self.skus.sku_id;
    dict[@"num"] = @(1);
    [self clearShoppingCar:dict];

}

- (IBAction)getShoppingCarAction:(id)sender {
    [self getShoppingCarInfo];
}
/**
 获取评论列表
 */
- (IBAction)getCommentsAction:(id)sender {
    [self getComments:1];
}

/**
 支付函数
 */
-(void)AliPay{
    //partner和seller获取失败,提示
    if ([ALIPAY_partner length] == 0 ||
        [ALIPAY_seller length] == 0 ||
        [ALIPAY_privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = ALIPAY_partner;
    order.seller = ALIPAY_seller;
    order.tradeNO = [global generateTradeNO]; //订单ID（由商家自行制定）
    NSLog(@"订单:%@",order.tradeNO);
    order.productName = self.goodsDetails.title; //商品标题
    order.productDescription = self.goodsDetails.input_str; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
    order.notifyURL =  ALIPAY_notifyURL; //回调URL
    order.service = ALIPAY_service;
    order.paymentType = ALIPAY_paymentType;
    order.inputCharset = ALIPAY_inputCharset;
    order.itBPay = ALIPAY_itBPay;
    order.showUrl = ALIPAY_showUrl;
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = APPScheme;
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(ALIPAY_privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //NSLog(@"reslut = %@",resultDic[@"resultStatus"]);
            NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
            if (resultStatus == 9000) {
               NSDictionary* dict = [global AliPayResultParseWithString:resultDic[@"result"]];
                if ([@"true" isEqualToString:dict[@"success"]]) {
                    [MBProgressHUD showSuccess:@"支付成功"];
                }else{
                    [MBProgressHUD showError:@"支付失败!"];
                }
            }else{
               [MBProgressHUD showError:@"支付失败!"];
            }
        }];
        
    }

}
/**
 启动xml解析
 */

-(void)startParseXMLWithString:(NSString*)dataString{
    __weak goodsDetailViewController* shopSelf = self;
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
    // 2> 设置代理
    parser.delegate = shopSelf;//防止在block中重复引用
    // 3> 开始解析
    [parser parse];
}

#pragma mark - XML解析代理方法
#pragma mark 1. 开始
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"开始解析文档");
    // 准备工作
    // 1> dataList
    if (!self.dataList) {
        self.dataList = [NSMutableArray array];
    } else {
        [self.dataList removeAllObjects];
    }
    
}

#pragma mark 2. 所有开始一个节点:<element>
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //BGLog(@"开始节点:%@ %@", elementName, attributeDict);
    if ([elementName isEqualToString:@"img"]) {
        [self.dataList addObject:attributeDict[@"src"]];
    }
    
}

#pragma mark 3. 查找内容,可能会重复多次
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
}

#pragma mark 4. 节点结束 </element>
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //BGLog(@"结束节点 %@", elementName);
}

#pragma mark 5. 文档结束
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //BGLog(@"解析结束 %@ %@", self.dataList, [NSThread currentThread]);
}

#pragma mark 6. 出错处理
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
#warning 这里解析好出错。虽然不影响程序运行，但后面注意一下，看是否会引起程序崩溃
    //BGLog(@"解析出错 %@", parseError.localizedDescription);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addImageView];
    });
}

@end
