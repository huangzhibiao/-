//
//  ViewController.m
//  BGTaobao
//
//  Created by huangzhibiao on 16/1/7.
//  Copyright © 2016年 haiwang. All rights reserved.
//

#import "ViewController.h"
#import "BuyViewController.h"
#import "global.h"

@interface ViewController ()
- (IBAction)TaoBaoDetailPage:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView* view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, screenW, 64.0);
    view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view];
}

- (IBAction)TaoBaoDetailPage:(id)sender {
    BuyViewController* buy = [[BuyViewController alloc] init];
    [self.navigationController pushViewController:buy animated:YES];
}
@end
