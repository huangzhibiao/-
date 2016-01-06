//
//  WXPay.m
//  微信支付Demo
//
//  Created by huangzhibiao on 15/12/25.
//  Copyright © 2015年 蓝鸥科技. All rights reserved.
//
/**
 *  微信支付需要后台做大量的工作。
 *  SDK及官方Demo下载：https://pay.weixin.qq.com/wiki/doc/api/app.php?chapter=11_1
 *  官方的开发步骤参考这里：https://pay.weixin.qq.com/wiki/doc/api/app.php?chapter=8_5
 *  这篇文档说的也挺详细：http://wenku.baidu.com/link?url=II3oeAaiH9NXWqdoO5HwXWCGcEermreHGBAqKvYfyKz_JVQ2n4NlA56e0H1HJWTNFfUsrTAgjegHBeUpMRzN0S318qcVklep7VCq0wBkpv7
 *  还有这篇：http://www.cocoachina.com/bbs/read.php?tid=303132
 */

#import "BGWXPay.h"
#import "WXApi.h"
#import "ZqNetWork.h"
#import "AFNetworking.h"
#import "NSString+Md5SignString.h"
#import "global.h"

@interface BGWXPay()<NSXMLParserDelegate>
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, copy)NSString* XMLString;//微信解析时拼接用
@property (nonatomic ,copy)NSString* nonce_str;
@end

@implementation BGWXPay

-(void)pay{
    [self weChatOrder];
}

-(void)setOrderData:(MyOrderModel *)orderData{
    _orderData = orderData;
}

/**
 统一下单接口
 */
-(void)weChatOrder{
    NSMutableDictionary* dictM = [[NSMutableDictionary alloc] init];
    
    dictM[@"appid"] = WXAPPID;
    dictM[@"mch_id"] = WXMCH_ID;
    self.nonce_str = [global generateTradeNO];
    dictM[@"nonce_str"] = self.nonce_str;
    dictM[@"body"] = @"鱼油";
    dictM[@"out_trade_no"] = [global generateTradeNO];
    dictM[@"total_fee"] = @(1);
    dictM[@"spbill_create_ip"] = [global getIPAddress];
    dictM[@"notify_url"] = @"www.baidu.com";
    dictM[@"trade_type"] = @"APP";
    dictM[@"sign"] = [NSString WXSign:dictM];
    NSMutableString* appen = [[NSMutableString alloc] init];
    [appen appendString:@"<xml>"];
    for(NSString* str in dictM.allKeys){
        [appen appendFormat:@"<%@>%@</%@>",str,dictM[str],str];
    }
    [appen appendString:@"</xml>"];
    //NSLog(@"统一下单参数 － %@",appen);
    [ZqNetWork postRequestWithURLString:@"https://api.mch.weixin.qq.com/pay/unifiedorder" Parameters:appen RequestHead:nil DataReturnType:DataReturnTypeXml RequestBodyType:RequstBodyTypeString SuccessBlock:^(NSData *data) {
        //NSLog(@"下单成功 = %@",data);
        [self startParseXMLWithString:data];
    } FailureBlock:^(NSError *error) {
        NSLog(@"下单失败 = %@",error);
    }];
}
#pragma mark - 微信支付
-(void)weChatPay:(NSString*)PrepayId {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    dict[@"appid"] = WXAPPID;
    dict[@"partnerid"] = WXMCH_ID;
    dict[@"prepayid"] = PrepayId;
    dict[@"package"] = @"Sign=WXPay";
    dict[@"noncestr"] = self.nonce_str;
    dict[@"timestamp"] = [global getCurrentTime];
    dict[@"sign"] = [NSString WXSign:dict];
    // 生成预支付订单信息
    PayReq *req             = [[PayReq alloc] init];
    req.partnerId           = dict[@"partnerid"];
    req.prepayId            = dict[@"prepayid"];
    req.package             = dict[@"package"];//暂填写固定值Sign=WXPay
    req.nonceStr            = dict[@"noncestr"];
    req.timeStamp           = [dict[@"timestamp"] intValue];
    req.sign                = dict[@"sign"];
#warning 2.调起微信支付
    if ([WXApi sendReq:req])
    {
        NSLog(@"调起成功!!!");
    }
    else
    {
        NSLog(@"调起失败!!!");
    }
    
}


/**
 启动xml解析
 */

-(void)startParseXMLWithString:(NSData*)data{
    __weak BGWXPay* shopSelf = self;
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
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
    if ([elementName isEqualToString:@"xml"]) {
        self.XMLString = nil;
        return;
    }
    self.XMLString = elementName;
    
}

#pragma mark 3. 查找内容,可能会重复多次
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.XMLString == nil) {
        return;
    }else if([string isEqualToString:@"\n"]){
        return;
    }else;
    NSDictionary* dict = @{self.XMLString:string};
    [self.dataList addObject:dict];
    self.XMLString = nil;
    //NSLog(@">> %@",string);
}

#pragma mark 4. 节点结束 </element>
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
}

#pragma mark 5. 文档结束
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //这里已经回到主线程
   // NSLog(@"解析结束 %@ %@", self.dataList, [NSThread currentThread]);
    int count = 0;
    NSString* prepay_id = nil;//微信返回的支付交易会话ID
    for(NSDictionary* dict in self.dataList){
        NSString* key = [[dict allKeys] lastObject];
        //NSLog(@"%@ = %@",key,dict[key]);
        if ( [key isEqualToString:@"return_code"] || [key isEqualToString:@"result_code"]) {
            if ([dict[key] isEqualToString:@"SUCCESS"]) {
                count++;
            }
        }else{
            if ([key isEqualToString:@"prepay_id"]) {
                prepay_id = dict[key];
            }
        }
    }
    if (count == 2) {//两个标识都返回SUCCESS
        [self weChatPay:prepay_id];
    }
}

#pragma mark 6. 出错处理
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
#warning 这里解析好出错。虽然不影响程序运行，但后面注意一下，看是否会引起程序崩溃
    NSLog(@"微信xml解析出错 %@",parseError);
    
}


@end
