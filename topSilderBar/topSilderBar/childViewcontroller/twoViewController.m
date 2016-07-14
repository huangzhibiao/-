//
//  twoViewController.m
//  topSilderBar
//
//  Created by huangzhibiao on 16/7/14.
//  Copyright © 2016年 Biao. All rights reserved.
//

#import "twoViewController.h"

@interface twoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;


@end

@implementation twoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _label.text = [NSString stringWithFormat:@"第%d个页面",_index];
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
