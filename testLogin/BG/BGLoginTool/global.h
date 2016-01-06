//
//  global.h
//  testLogin
//
//  Created by huangzhibiao on 15/12/3.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MJExtension.h"

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

#define color(r,g,b,al) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:al]
#define screenH [UIScreen mainScreen].bounds.size.height
#define screenW [UIScreen mainScreen].bounds.size.width

#define font(size) [UIFont systemFontOfSize:[global pxTopt:size]]
#define BGFont(size) [UIFont systemFontOfSize:size]

#define iphone5 ((screenW==320)?1:0)
#define iphone6 ((screenW==375)?1:0)
#define iphone6plus ((screenW==414)?1:0)
#define iphone5W 320.0
#define iphone6W 375.0
#define iphone6plusW 414.0

/**
 key设置路径：微信商户平台(pay.weixin.qq.com)-->账户设置-->API安全-->密钥设置
 微信统一下单专用
 */
extern NSString* const WXkey;
extern NSString* const WXAPPID;
extern NSString* const WXMCH_ID;
extern NSString* const WXNOTIFICATION;

/**
 自己后台通信token
 */
extern NSString* const token;

extern NSString* const LoginUrl;
extern NSString* const unameKey;
extern NSString* const passwordKey;
extern NSString* const methodKey;
extern NSString* const signKey;
extern NSString* const dataKey;
extern NSString* const messageKey;
extern NSString* const createtimeKey;
extern NSString* const rspKey;
extern NSString* const vcodeKey;//验证码
extern NSString* const mobileKey;//手机号码Key
extern NSString* const lost_tokenKey;//找回密码的token

extern NSString* const cat_idKey;
extern NSString* const cat_nameKey;

extern NSString* const fail;
extern NSString* const succ;

/**
 相关method参数
 */
extern NSString* const get_encrypt_params;//获取会员加密密码参数
extern NSString* const signin;//会员登录
extern NSString* const get_member_info;// 用户基本信息查询
extern NSString* const send_signup_sms; //对注册的手机号发送验证码
extern NSString* const signup; //会员注册接口
extern NSString* const lost_send_vcode; //找回密码1，根据手机号码发送验证码
extern NSString* const lost_verify_vcode;// 找回密码2，验证码验证
extern NSString* const lost_reset_password; //找回密码3，设定新密码 ，并进行修改密码后续操作

extern NSString* const updateStore;// 更新商品库存
extern NSString* const get_cat_list; //根据商品分类ID获取下级分类列表
extern NSString* const get_type_detial; //根据商品类型ID,获取商品类型详情
extern NSString* const get_store; //根据货品ID 查询货品库存
extern NSString* const get_lv_price;// 根据货品ID 查询货品对应等级价格
extern NSString* const get_goods_intro;// 根据商品ID，查询商品详情
extern NSString* const search_properties_goods;// 根据筛选条件查询商品
extern NSString* const get_goods_detail; //根据货品ID获取单个货品的详细信息
extern NSString* const get_brand_detail;//获取品牌数据(根据品牌排序查询列表)
extern NSString* const get_order_list;//根据用户id调取其订单列表，按照下单时间降序排序
extern NSString* const b2c_payment_create;//添加订单支付单(即通知后台支付了)
extern NSString* const b2c_order_status_update;//修改订单状态

//应用注册scheme,在AlixPayDemo-Info.plist定义URL types
extern NSString* const APPScheme;

/**
 登陆状态变量
 */
extern NSString* const accesstokenKey;
extern NSString* const member_idKey;
extern NSString* const statusKey;

extern NSString* const login_nameKey;

extern NSString *const login_fail;
extern NSString *const login_success;

/**
 *  注册状态变量
 */
extern NSString *const enroll_success ;
extern NSString *const enroll_fail;


/**
 *  找回密码
 */
extern NSString *const resetPassword;
extern NSString *const passWordSuccess ;

/**
 阿里支付宝相关常量
 */
extern NSString* const ALIPAY_notifyURL;//回调URL
extern NSString* const ALIPAY_service;
extern NSString* ALIPAY_paymentType;
extern NSString* const ALIPAY_inputCharset;
extern NSString* const ALIPAY_itBPay;
extern NSString* const ALIPAY_showUrl;
/*=======================需要填写商户app申请的===================================*/
extern NSString* const ALIPAY_partner;
extern NSString* const ALIPAY_seller;
extern NSString* const ALIPAY_privateKey;
/*============================================================================*/
/**
 支付方式
 */
extern NSString* const ZHIFUBAO_PAY;
extern NSString* const WEIXIN_PAY;
extern NSString* const YUER_PAY;
extern NSString* const KUAIJIE_PAY;

/**
 订单状态更新通知
 */
extern NSString* const BG_ORDER_STATUS_NPTIFICATION;
extern NSString* const getMyOrderLists;
extern NSString* const paySucc;
@interface global : NSObject

@property(nonatomic,copy)NSString* accesstoken;
@property(nonatomic,assign)NSInteger member_id;
@property(nonatomic,copy)NSString* message;
@property(nonatomic,assign)Boolean status;
/**
 登陆时返回的时间
 */
@property(nonatomic,copy)NSString* createtime;

+(instancetype)intance;

/**
 json字符转字典
 */
+(id)dictionaryWithJsonString:(NSString *)jsonString;
/**
 字典转json字符
 */
+(NSString*)dictionaryToJson:(NSDictionary *)dic;
/**
 解析并生成GoodImgs数组
 */
+(NSArray*)getGoodImgsWithString:(NSString*)jsonString;
/**
 在一段字符串中设置不同字体的大小
 */
+(NSMutableAttributedString*)setMutableStringSize:(NSString*)str;
/**
 根据传入的大小字体的字号设置不同字体的大小
 */
+(NSMutableAttributedString*)setMutableStringWithString:(NSString*)attString bigFont:(UIFont*)bigFont smallFont:(UIFont*)smallFont;
/**
 支付宝结果专门解析函数
 */
+(NSDictionary*)AliPayResultParseWithString:(NSString*)newstring;
/**
 从像素px转换为ios的点阵pt
 */
+(CGFloat)pxTopt:(CGFloat)px;
/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;
// 获取设备ip地址
+ (NSString *)getIPAddress;
/**
 获取当前时间戳 －－毫秒数
 */
+(NSString*)getCurrentTime;
/**
 产生随机订单号
 */
+ (NSString *)generateTradeNO;
@end
