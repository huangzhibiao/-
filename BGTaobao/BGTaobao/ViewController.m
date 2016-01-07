//
//  ViewController.m
//  BGTaobao
//
//  Created by huangzhibiao on 16/1/7.
//  Copyright © 2016年 haiwang. All rights reserved.
//

#import "ViewController.h"
#import "BuyViewController.h"

@interface ViewController ()
- (IBAction)TaoBaoDetailPage:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)TaoBaoDetailPage:(id)sender {
    BuyViewController* buy = [[BuyViewController alloc] init];
    [self.navigationController pushViewController:buy animated:YES];
}
@end
