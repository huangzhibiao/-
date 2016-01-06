//
//  global.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/3.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "global.h"
#import "GoodsImgs.h"
#import <UIKit/UIKit.h>
/**
 获取ip用到的头文件
 */
#import <ifaddrs.h>
#import <arpa/inet.h>

/**
 key设置路径：微信商户平台(pay.weixin.qq.com)-->账户设置-->API安全-->密钥设置
 微信统一下单专用
 */
NSString* const WXkey = @"xPWHdcwHN6crO87el2mBWoQXjnkzQ9iQ";//@"04418352af073a03a0eb643903c73973";
NSString* const WXAPPID = @"wxda6b0c4b80786c67";
NSString* const WXMCH_ID = @"1300188801";
NSString* const WXNOTIFICATION = @"WEIXIN_ORDER_PAY_NOTIFICATION";

NSString* const token = @"52e6f0db23ce0f15a0b5a48796d0851a6c3a5110b55b3ceddd572daaf57f779f";

NSString* const LoginUrl = @"http://172.18.0.186/index.php/api";//@"http://www.gmjk.com/index.php/api";
NSString* const unameKey = @"uname";
NSString* const passwordKey = @"password";
NSString* const methodKey = @"method";
NSString* const signKey = @"sign";
NSString* const dataKey = @"data";
NSString* const messageKey = @"message";
NSString* const createtimeKey = @"createtime";
NSString* const rspKey = @"rsp";
NSString* const vcodeKey = @"vcode";
NSString* const mobileKey = @"mobile";
NSString* const lost_tokenKey = @"lost_token";
NSString* const cat_idKey = @"cat_id";
NSString* const cat_nameKey = @"cat_name";

NSString* const fail = @"fail";
NSString* const succ = @"succ";

NSString* const APPScheme = @"com.haiwang.testLogin";

/**
 相关method参数
 */
NSString* const get_encrypt_params = @"b2c.member.get_encrypt_params";//获取会员加密密码参数
NSString* const signin = @"b2c.member.signin";
NSString* const get_member_info = @"b2c.member.get_member_info";
NSString* const send_signup_sms = @"b2c.member.send_signup_sms"; //对注册的手机号发送验证码
NSString* const signup = @"b2c.member.signup"; //会员注册接口
NSString* const lost_send_vcode = @"b2c.member.lost_send_vcode";//找回密码1，根据手机号码发送验证码
NSString* const lost_verify_vcode = @"b2c.member.lost_verify_vcode";//找回密码2，验证码验证
NSString* const lost_reset_password = @"b2c.member.lost_reset_password";//找回密码3，设定新密码

NSString* const updateStore = @"b2c.update_store.updateStore"; //更新商品库存
NSString* const get_cat_list = @"b2c.goods.get_cat_list";//根据商品分类ID获取下级分类列表
NSString* const get_type_detial = @"b2c.goods.get_type_detial"; //根据商品类型ID,获取商品类型详情
NSString* const get_store = @"b2c.goods.get_store"; //根据货品ID 查询货品库存
NSString* const get_lv_price = @"b2c.goods.get_lv_price"; //根据货品ID 查询货品对应等级价格
NSString* const get_goods_intro = @"b2c.goods.get_goods_intro";// 根据商品ID，查询商品详情
NSString* const search_properties_goods = @"b2c.goods.search_properties_goods";// 根据筛选条件查询商品
NSString* const get_goods_detail = @"b2c.goods.get_goods_detail";//根据货品ID获取单个货品的详细信息
NSString* const get_brand_detail = @"b2c.brand.get_brand_detail";//获取品牌数据(根据品牌排序查询列表)
NSString* const get_order_list = @"b2c.member.get_order_list";//根据用户id调取其订单列表，按照下单时间降序排序
NSString* const b2c_payment_create = @"b2c.payment.create";//添加订单支付单(即通知后台支付了)
NSString* const b2c_order_status_update = @"b2c.order.status_update";//修改订单状态
/**
 登陆状态变量
 */
NSString* const accesstokenKey = @"accesstoken";
NSString* const member_idKey = @"member_id";
NSString* const statusKey = @"status";

NSString* const login_nameKey = @"login_name";

NSString *const login_fail = @"用户名或密码错误";
NSString *const login_success = @"登录成功";

/**
 *  注册状态变量
 */
NSString *const enroll_success = @"注册成功";
NSString *const enroll_fail;


/**
 *  找回密码
 */
NSString *const resetPassword = @"短信验证成功";
NSString *const passWordSuccess = @"密码修改成功";

/**
 阿里支付宝相关常量
 */
NSString* const ALIPAY_notifyURL = @"http://www.gmjk.com";//回调URL
NSString* const ALIPAY_service = @"mobile.securitypay.pay";
NSString* ALIPAY_paymentType = @"1";
NSString* const ALIPAY_inputCharset = @"utf-8";
NSString* const ALIPAY_itBPay = @"30m";
NSString* const ALIPAY_showUrl = @"m.alipay.com";

/*
 *商户的唯一的parnter和seller。
 *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
 */
/*=======================需要填写商户app申请的===================================*/
NSString* const ALIPAY_partner = @"2088811457141796";
NSString* const ALIPAY_seller = @"hwjkysc@163.com";
NSString* const ALIPAY_privateKey = @"MIICXQIBAAKBgQC9OFOjASq3rgB8LmBiqFu97SH1tKujN/5TeYHe5oKAyPeohRDL9Us80U2lwqWwnNauR/qxGdnSu2ygucFNojQb4KDejMQ/7eV5EMwpBWFvAD36f0X4fSxEz634RWDt6Wmg9gFKnBwJWhZ7aWmy6AozVaF9kPXH5Ic8iij/TCuH1wIDAQABAoGBALlvU/exEw4DBhKs2GSXHaFZnShQMMy5+RIRSAcL2+UeDicmkLlw4JTvgarqwLn+Wh1eCP46mU99wg0ZPak5RtpB68muwTjR4ZNYHvNxTf+yGLsK77JL8l9YNu2KCbmYhsxdfS2fDz9ROCzDB5+4h1c81kK7y7D/l/1WA8FYJxiBAkEA8TxLbIXfZ1EPCAEijT9k2csJJpuOydzEDnmmo9h2L5GwZzRqMblST3Az7pSd96+PLvu/sOfX5Rg9h0gDwE3dNwJBAMjNDCDkzJBT5q7y+18Wb8Zi8lolPwdOqSdYui+YKGGR1OkJFWVBmTN7vdM5AYTTVgCRYiCBUaHCqjsJQkn1+mECQGNfmB5jY20XCh8dAJO4+p1xMxrRV9e19pmT6V5zS/Q6irVo9Rn4onyQ1wO/+vbOPih3kjaYuunnu2jf9JOiP68CQBRwgs6KW6RJVg7y3tGECCaqhb7VUcAdqqw9pN4ZX+rmnESITyw6bCzIaL8qa1Qo6vUt1041u6h6lzdhLuU2a6ECQQDlx/1x1Yo0nB72LVl4AZy0H1hdogB9YEFfQpP6fxd67EaPjEKX0c0c4HXELnNOs0SYUWggKlG0e13jjgYi/2/5";
/*============================================================================*/
/**
 支付方式
 */
NSString* const ZHIFUBAO_PAY = @"支付宝支付";
NSString* const WEIXIN_PAY = @"微信支付";
NSString* const YUER_PAY = @"余额支付";
NSString* const KUAIJIE_PAY = @"快捷支付";
/**
 订单状态更新通知
 */
NSString* const BG_ORDER_STATUS_NPTIFICATION = @"BG_ORDER_STATUS_NPTIFICATION";
NSString* const getMyOrderLists = @"getMyOrderLists";
NSString* const paySucc = @"paySuccess";

static global* myGlobal;
@implementation global

+(instancetype)intance{
    if (myGlobal == nil) {
        myGlobal = [[global alloc] init];
    }
    return myGlobal;
}
/**
 json字符转字典
 */
+(id )dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
    
}
/**
 字典转json字符
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+(NSArray *)getGoodImgsWithString:(NSString *)jsonString{
       NSMutableArray* arrM = [[NSMutableArray alloc] init];
        NSArray* imgs = [self dictionaryWithJsonString:jsonString];
        for(NSDictionary* dict in imgs){
            GoodsImgs* img = [GoodsImgs objectWithKeyValues:dict];
            [arrM addObject:img];
        }
    return arrM;
}

/**
 在一段字符串中设置不同字体的大小
 */
+(NSMutableAttributedString*)setMutableStringSize:(NSString*)attString{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:attString];
    NSInteger length = attString.length;
    NSRange range = [attString rangeOfString:@"."];
    [str addAttribute:NSFontAttributeName value:[UIFont  systemFontOfSize:[global pxTopt:28.0]] range:NSMakeRange(0, range.location)];
    [str addAttribute:NSFontAttributeName value:[UIFont  systemFontOfSize:[global pxTopt:20.0]] range:NSMakeRange(range.location+1, (length - (range.location + 1)))];
    return str;
}
/**
 根据传入的大小字体的字号设置不同字体的大小
 */
+(NSMutableAttributedString*)setMutableStringWithString:(NSString*)attString bigFont:(UIFont*)bigFont smallFont:(UIFont*)smallFont{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:attString];
    NSInteger length = attString.length;
    NSRange range = [attString rangeOfString:@"."];
    [str addAttribute:NSFontAttributeName value:bigFont range:NSMakeRange(0, range.location)];
    [str addAttribute:NSFontAttributeName value:smallFont range:NSMakeRange(range.location+1, (length - (range.location + 1)))];
    return str;
}
/**
 支付宝结果专门解析函数
 */
+(NSDictionary*)AliPayResultParseWithString:(NSString*)newstring{
    newstring = [newstring stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSArray *AllArray = [newstring componentsSeparatedByString:@"&"];
    NSMutableDictionary* dictM = [[NSMutableDictionary alloc] init];
    for(NSString* str in AllArray){
        NSArray *arr = [str componentsSeparatedByString:@"="];
        [dictM setObject:arr[1] forKey:arr[0]];
    }
    return dictM;
}
/**
 从像素px转换为ios的点阵pt
 */
+(CGFloat)pxTopt:(CGFloat)px{
    CGFloat standardPt = px/2.0;
    if (iphone5) {
        standardPt = (iphone5W/iphone6W)*standardPt;
    }else if(iphone6){
        
    }else if(iphone6plus){
        standardPt = (iphone6plusW/iphone6W)*standardPt;
    }else;
    return standardPt;
}
/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
// 获取设备ip地址
+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
/**
 获取当前时间戳 －－毫秒数
 */
+(NSString *)getCurrentTime{
    NSDate* date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%ld",(long)time];
}
/**
 产生随机订单号
 */
+ (NSString *)generateTradeNO
{
    NSDate* date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"gmjk%ld",(long)time];
}
@end
