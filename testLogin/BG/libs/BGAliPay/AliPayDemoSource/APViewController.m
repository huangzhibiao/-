//
//  APViewController.m
//  AliSDKDemo
//
//  Created by 方彬 on 11/29/13.
//  Copyright (c) 2013 Alipay.com. All rights reserved.
//

#import "APViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import "APAuthV2Info.h"

@implementation Product


@end

@interface APViewController ()

@end

@implementation APViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self generateData];
}


#pragma mark -
#pragma mark   ==============产生随机订单号==============


- (NSString *)generateTradeNO
{
	static int kNumber = 15;
	
	NSString *sourceStr = @"952136941AatgGRFgvfKLpiUSSTUZHtcf";
	NSMutableString *resultStr = [[NSMutableString alloc] init];
	srand(time(0));
	for (int i = 0; i < kNumber; i++)
	{
		unsigned index = rand() % [sourceStr length];
		NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
		[resultStr appendString:oneStr];
	}
	return resultStr;
}



#pragma mark -
#pragma mark   ==============产生订单信息==============

- (void)generateData{
	NSArray *subjects = @[@"1",
                          @"2",@"3",@"4",
                          @"5",@"6",@"7",
                          @"8",@"9",@"10"];
	NSArray *body = @[@"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据",
                      @"我是测试数据"];
	
	if (nil == self.productList) {
		self.productList = [[NSMutableArray alloc] init];
	}
	else {
		[self.productList removeAllObjects];
	}
    
	for (int i = 0; i < [subjects count]; ++i) {
		Product *product = [[Product alloc] init];
		product.subject = [subjects objectAtIndex:i];
		product.body = [body objectAtIndex:i];
        
		product.price = 0.01f+pow(10,i-2);
		[self.productList addObject:product];
	}
}


#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 55.0f;
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.productList count];
}




//
//用TableView呈现测试数据,外部商户不需要考虑
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
													reuseIdentifier:@"Cell"];
    
	Product *product = [self.productList objectAtIndex:indexPath.row];

    cell.textLabel.text = product.body;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"一口价：%.2f",product.price];
	
	return cell;
}


#pragma mark -
#pragma mark   ==============点击订单模拟支付行为==============
//
//选中商品调用支付宝极简支付
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	/*
	 *点击获取prodcut实例并初始化订单信息
	 */
	Product *product = [self.productList objectAtIndex:indexPath.row];
	
	/*
	 *商户的唯一的parnter和seller。
	 *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
	 */
    
/*============================================================================*/
/*=======================需要填写商户app申请的===================================*/
/*============================================================================*/
	NSString *partner = @"2088811457141796";
    NSString *seller = @"hwjkysc@163.com";
    NSString *privateKey = @"MIICXQIBAAKBgQC9OFOjASq3rgB8LmBiqFu97SH1tKujN/5TeYHe5oKAyPeohRDL9Us80U2lwqWwnNauR/qxGdnSu2ygucFNojQb4KDejMQ/7eV5EMwpBWFvAD36f0X4fSxEz634RWDt6Wmg9gFKnBwJWhZ7aWmy6AozVaF9kPXH5Ic8iij/TCuH1wIDAQABAoGBALlvU/exEw4DBhKs2GSXHaFZnShQMMy5+RIRSAcL2+UeDicmkLlw4JTvgarqwLn+Wh1eCP46mU99wg0ZPak5RtpB68muwTjR4ZNYHvNxTf+yGLsK77JL8l9YNu2KCbmYhsxdfS2fDz9ROCzDB5+4h1c81kK7y7D/l/1WA8FYJxiBAkEA8TxLbIXfZ1EPCAEijT9k2csJJpuOydzEDnmmo9h2L5GwZzRqMblST3Az7pSd96+PLvu/sOfX5Rg9h0gDwE3dNwJBAMjNDCDkzJBT5q7y+18Wb8Zi8lolPwdOqSdYui+YKGGR1OkJFWVBmTN7vdM5AYTTVgCRYiCBUaHCqjsJQkn1+mECQGNfmB5jY20XCh8dAJO4+p1xMxrRV9e19pmT6V5zS/Q6irVo9Rn4onyQ1wO/+vbOPih3kjaYuunnu2jf9JOiP68CQBRwgs6KW6RJVg7y3tGECCaqhb7VUcAdqqw9pN4ZX+rmnESITyw6bCzIaL8qa1Qo6vUt1041u6h6lzdhLuU2a6ECQQDlx/1x1Yo0nB72LVl4AZy0H1hdogB9YEFfQpP6fxd67EaPjEKX0c0c4HXELnNOs0SYUWggKlG0e13jjgYi/2/5";
/*============================================================================*/
/*============================================================================*/
/*============================================================================*/
	
	//partner和seller获取失败,提示
	if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
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
	order.partner = partner;
	order.seller = seller;
	order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    
    NSLog(@"订单:%@",order.tradeNO);
	order.productName = product.subject; //商品标题
	order.productDescription = product.body; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
	order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
	
	//应用注册scheme,在AlixPayDemo-Info.plist定义URL types
	NSString *appScheme = @"alisdkdemo";
	
	//将商品信息拼接成字符串
	NSString *orderSpec = [order description];
	NSLog(@"orderSpec = %@",orderSpec);
	
	//获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
	id<DataSigner> signer = CreateRSADataSigner(privateKey);
	NSString *signedString = [signer signString:orderSpec];
	
	//将签名成功字符串格式化为订单字符串,请严格按照该格式
	NSString *orderString = nil;
	if (signedString != nil) {
		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //NSLog(@"reslut = %@",resultDic[@"resultStatus"]);
            NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
            NSString *newstring = resultDic[@"result"];
            newstring = [newstring stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSArray *AllArray = [newstring componentsSeparatedByString:@"&"];
            NSMutableDictionary* dictM = [[NSMutableDictionary alloc] init];
            for(NSString* str in AllArray){
                NSArray *arr = [str componentsSeparatedByString:@"="];
                [dictM setObject:arr[1] forKey:arr[0]];
            }
            for(NSString* key in dictM.allKeys){
                NSLog(@"%@ = %@",key,dictM[key]);
            }
        }];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
@end
