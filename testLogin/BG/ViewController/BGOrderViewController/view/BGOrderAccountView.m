//
//  BGOrderAccountView.m
//  testLogin
//
//  Created by huangzhibiao on 15/12/23.
//  Copyright © 2015年 haiwang. All rights reserved.
//

#import "BGOrderAccountView.h"

@implementation BGOrderAccountView

+ (instancetype)view
{
    return [[[NSBundle mainBundle] loadNibNamed:@"BGOrderAccountView" owner:nil options:nil] firstObject];
}

@end
