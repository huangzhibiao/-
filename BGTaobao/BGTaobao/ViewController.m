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
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[global createImageWithColor:color(0.0,162.0,154.0,1.0)] forBarMetrics:UIBarMetricsDefault];
}

- (IBAction)TaoBaoDetailPage:(id)sender {
    BuyViewController* buy = [[BuyViewController alloc] init];
    [self.navigationController pushViewController:buy animated:YES];
}
@end
