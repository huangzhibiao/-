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
    [NaviBar setBackgroundImage:[global createImageWithColor:color(0.0,162.0,154.0,0.0)] forBarMetrics:UIBarMetricsDefault];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
