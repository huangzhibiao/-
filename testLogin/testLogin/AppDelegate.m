//
//  AppDelegate.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/3.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "global.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 向微信注册
    BOOL isOk = [WXApi registerApp:WXAPPID];
    if (isOk){
        NSLog(@"注册微信成功");
    }else{
        NSLog(@"注册微信失败");
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        // NSLog(@"result = %@",resultDic);
        NSLog(@"支付宝支付成功--delegate");
    }];
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    // 跳转到URL scheme中配置的地址
    NSLog(@"跳转到URL scheme中配置的地址-->%@",url);
    return [WXApi handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}

#warning 3.支付结果回调
- (void)onResp:(BaseResp *)resp
{
    if([resp isKindOfClass:[PayResp class]]){
#warning 4.支付返回结果，实际支付结果需要去自己的服务器端查询  由于demo的局限性这里直接使用返回的结果
        // 返回码参考：https://pay.weixin.qq.com/wiki/doc/api/app.php?chapter=9_12
        switch (resp.errCode) {
            case WXSuccess:{
                NSNotification *notification = [NSNotification notificationWithName:WXNOTIFICATION object:succ];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                break;
            }
            default:{
                NSNotification *notification = [NSNotification notificationWithName:WXNOTIFICATION object:fail];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                break;
            }
        }
    }
}


@end
