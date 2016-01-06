//
//  JSWebViewController.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/17.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "JSWebViewController.h"

@interface JSWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation JSWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 加载网页
    self.webView.hidden = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.gmjk.com/wap/product-27.html"]]];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
     // 详情页面加载完毕
        // 用来拼接所有的JS
        NSMutableString *js = [NSMutableString string];
    [js appendString:@"var box0 = document.getElementsByClassName('full-screen')[0];"];//根据className获取相关元素组合
    [js appendString:@"var box2 = document.getElementsByClassName('full-screen')[2];"];
    [js appendString:@"box0.parentNode.removeChild(box0);"];
    [js appendString:@"box2.parentNode.removeChild(box2);"];
    
    [js appendString:@"var header = document.getElementsByTagName('header')[0];"];//根据节点名称获取相关元素组合
    
    [js appendString:@"header.parentNode.removeChild(header);"];//移除头部
    
    [js appendString:@"var buy_form = document.getElementById('buy_form');"];//根据id获取元素
    [js appendString:@"buy_form.parentNode.removeChild(buy_form);"];
    
    [js appendString:@"var trigger = document.getElementsByClassName('trigger-list')[0];"];
    [js appendString:@"trigger.parentNode.removeChild(trigger);"];
    
    // 利用webView执行JS
   [webView stringByEvaluatingJavaScriptFromString:js];
    // 显示webView
    webView.hidden = NO;
   
}


@end
