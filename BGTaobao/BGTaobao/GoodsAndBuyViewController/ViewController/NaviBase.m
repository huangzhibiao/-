//
//  NaviBase.m
//  BGTaobao
//
//  Created by huangzhibiao on 16/1/7.
//  Copyright © 2016年 haiwang. All rights reserved.
//

#import "NaviBase.h"
#import "global.h"

@interface NaviBase ()

@end

@implementation NaviBase
/**
 这个方法只会在类第一次使用的时候调用
 */
+(void)initialize{
    [super initialize];
    UINavigationBar* NaviBar = [UINavigationBar appearance];
    [NaviBar setBackgroundImage:[global createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    //设置主题字体颜色
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [NaviBar setTitleTextAttributes:dict];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    for(UIView* view in self.navigationBar.subviews){
        for(UIView* vi in view.subviews){
            if([vi isKindOfClass:[UIImageView class]]){
                [vi removeFromSuperview];
            }
        }
    }
}
@end
