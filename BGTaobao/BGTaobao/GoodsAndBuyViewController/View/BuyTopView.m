//
//  BuyTopView.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/21.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "BuyTopView.h"
#import "BGCenterLineLabel.h"

@interface BuyTopView()

@property (weak, nonatomic) IBOutlet UILabel *name_lab;//产品名称
@property (weak, nonatomic) IBOutlet UILabel *descri_lab;//产品描述
@property (weak, nonatomic) IBOutlet UILabel *nowPrice_lab;//当前价格
@property (weak, nonatomic) IBOutlet BGCenterLineLabel *oldPrice_lab;//原价
@property (weak, nonatomic) IBOutlet UIButton *collect_Btn;//收藏按钮
@property (weak, nonatomic) IBOutlet UILabel *sales_lab;//月销售量

@end

@implementation BuyTopView

-(void)awakeFromNib{
    [self.collect_Btn addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)collectAction:(UIButton*)sender{
    sender.selected = sender.isSelected?NO:YES;
    
}
+ (instancetype)view
{
    return [[[NSBundle mainBundle] loadNibNamed:@"BuyTopView" owner:nil options:nil] firstObject];
}


@end
