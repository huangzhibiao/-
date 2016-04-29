//
//  ViewController.m
//  BGTBSelectBB
//
//  Created by huangzhibiao on 16/4/20.
//  Copyright © 2016年 Biao. All rights reserved.
//

#import "ViewController.h"

#define screenH [UIScreen mainScreen].bounds.size.height
#define screenW [UIScreen mainScreen].bounds.size.width

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    view.frame = CGRectMake(25.0,50.0,screenW-50.0,screenH-100.0);
    [self.view addSubview:view];
    
    [UIView animateWithDuration:5.0 animations:^{
        view.layer.transform = CATransform3DMakeRotation(0.78, 1.0, 0.0, 0.0);
    }];
    
}


@end
