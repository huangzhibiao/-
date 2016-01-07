//
//  BuyMiddleView.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/21.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "BuyMiddleView.h"

@interface BuyMiddleView()

@property (weak, nonatomic) IBOutlet UILabel *descri_lab;//以选规格
@property (weak, nonatomic) IBOutlet UILabel *storageStatus_lab;//库存状态
@property (weak, nonatomic) IBOutlet UILabel *express_lab;//运费
@property (weak, nonatomic) IBOutlet UILabel *service_lab;//服务
@property (weak, nonatomic) IBOutlet UILabel *prompt_lab;//提示

@end

@implementation BuyMiddleView

+ (instancetype)view
{
    return [[[NSBundle mainBundle] loadNibNamed:@"BuyMiddleView" owner:nil options:nil] firstObject];
}

@end
